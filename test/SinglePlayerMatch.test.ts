import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import { parseEther, parseEventLogs } from "viem";
import { ShipTuple, tupleToShip, ActionType, GameDataView } from "./types";
import DeployModule from "../ignition/modules/DeployAndConfig";

function findShipPosition(gameData: GameDataView, shipId: bigint) {
  for (const shipPosition of gameData.shipPositions) {
    if (shipPosition.shipId === shipId) {
      return shipPosition.position;
    }
  }
  throw new Error(`Ship ${shipId} not found in game data`);
}

describe("SinglePlayerMatch", function () {
  async function deploySinglePlayerFixture() {
    const [owner, human, other] = await hre.viem.getWalletClients();
    const publicClient = await hre.viem.getPublicClient();

    const deployed = await hre.ignition.deploy(DeployModule);

    const humanLobbies = await hre.viem.getContractAt(
      "Lobbies",
      deployed.lobbies.address,
      { client: { wallet: human } },
    );
    const humanShips = await hre.viem.getContractAt(
      "Ships",
      deployed.ships.address,
      { client: { wallet: human } },
    );
    const humanGame = await hre.viem.getContractAt(
      "Game",
      deployed.game.address,
      { client: { wallet: human } },
    );
    const humanUniversalCredits = await hre.viem.getContractAt(
      "UniversalCredits",
      deployed.universalCredits.address,
      { client: { wallet: human } },
    );
    const singlePlayerMatchOther = await hre.viem.getContractAt(
      "SinglePlayerMatch",
      deployed.singlePlayerMatch.address,
      { client: { wallet: other } },
    );

    return {
      ships: deployed.ships,
      lobbies: deployed.lobbies,
      game: deployed.game,
      maps: deployed.maps,
      singlePlayerMatch: deployed.singlePlayerMatch,
      aiEncounters: deployed.aiEncounters,
      universalCredits: deployed.universalCredits,
      shipPurchaser: deployed.shipPurchaser,
      randomManager: deployed.randomManager,
      humanLobbies,
      humanShips,
      humanGame,
      humanUniversalCredits,
      singlePlayerMatchOther,
      owner,
      human,
      other,
      publicClient,
    };
  }

  const defaultTraits = {
    serialNumber: 0n,
    colors: {
      h1: 0,
      s1: 0,
      l1: 0,
      h2: 0,
      s2: 0,
      l2: 0,
      h3: 0,
      s3: 0,
      l3: 0,
    },
    variant: 1,
    accuracy: 0,
    hull: 0,
    speed: 0,
  };

  const defaultEquipment = {
    mainWeapon: 0, // Laser
    armor: 0, // None
    shields: 0, // None
    special: 0, // None
  };

  const defaultArchetype = 0; // Grunt

  // Creates a preset map with one AI ship config placed at (0, 16) — the
  // same single-ship-at-the-AI's-corner shape the old hardcoded template
  // produced for ship index 0 — and returns its map id. setupAIFleet now
  // reads its fleet composition/placement entirely from AIEncounters, so
  // every single-player test needs a real, non-empty configured map.
  async function setupBasicAIEncounter(maps: any, aiEncounters: any) {
    await maps.write.createPresetMap([[]]);
    const mapId = await maps.read.mapCount();
    await aiEncounters.write.createAIShipConfig([
      "AI Ship",
      defaultEquipment,
      defaultTraits,
      defaultArchetype,
    ]);
    const configId = await aiEncounters.read.aiShipConfigCount();
    await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);
    return mapId;
  }

  // Human reserves the lobby for SinglePlayerMatch and pays the standard 1
  // UTC reservation fee — identical to reserving a specific human opponent.
  async function createReservedLobby(
    ships: any,
    lobbies: any,
    humanLobbies: any,
    humanUniversalCredits: any,
    shipPurchaser: any,
    universalCredits: any,
    singlePlayerMatch: any,
    human: any,
    mapId: bigint,
  ) {
    await shipPurchaser.write.purchaseUTCWithFlow([human.account.address, 1n], {
      value: parseEther("9.99"),
      account: human.account,
    });
    await humanUniversalCredits.write.approve(
      [lobbies.address, parseEther("1")],
      { account: human.account },
    );

    await humanLobbies.write.createLobby([
      1000n,
      86400n,
      true,
      mapId,
      20n,
      singlePlayerMatch.address,
    ]);
  }

  it("only a recognized single-player orchestrator can be dispatched to on game start", async function () {
    const { lobbies, singlePlayerMatch } = await loadFixture(
      deploySinglePlayerFixture,
    );
    expect(
      await lobbies.read.isSinglePlayerOrchestrator([
        singlePlayerMatch.address,
      ]),
    ).to.equal(true);
  });

  it("plays a single-player match end to end through the shared Lobbies flow", async function () {
    const {
      ships,
      lobbies,
      game,
      maps,
      singlePlayerMatch,
      aiEncounters,
      universalCredits,
      shipPurchaser,
      randomManager,
      humanLobbies,
      humanShips,
      humanGame,
      humanUniversalCredits,
      singlePlayerMatchOther,
      human,
      owner,
    } = await loadFixture(deploySinglePlayerFixture);

    const mapId = await setupBasicAIEncounter(maps, aiEncounters);
    await createReservedLobby(
      ships,
      lobbies,
      humanLobbies,
      humanUniversalCredits,
      shipPurchaser,
      universalCredits,
      singlePlayerMatch,
      human,
      mapId,
    );

    const lobbyId = 1n;

    // Lobby is reserved for SinglePlayerMatch — anyone can trigger it to
    // accept, exactly like the reserved human flow, just permissionless
    // instead of gated to the reserved address (a contract has no private
    // key to sign with).
    await singlePlayerMatchOther.write.acceptMatch([lobbyId]);

    let lobby = (await lobbies.read.getLobby([lobbyId])) as any;
    expect(lobby.players.joiner.toLowerCase()).to.equal(
      singlePlayerMatch.address.toLowerCase(),
    );

    // Human purchases and constructs a ship. Creator ships must sit in
    // columns 0-3, so it starts far from the AI's fleet (col 16) — repositioned
    // below via the debug helper to directly exercise the v0 script's Case 1
    // (adjacent enemy) without needing 10+ rounds of the AI closing the gap.
    await ships.write.purchaseWithFlow(
      [human.account.address, 0n, human.account.address, 1],
      { value: parseEther("4.99") },
    );
    // Tier 0 mints 5 ships (ids 1-5); constructAllMyShips constructs all of
    // them, so every one needs its randomness fulfilled first.
    for (let i = 1; i <= 5; i++) {
      const shipTuple = (await ships.read.ships([BigInt(i)])) as ShipTuple;
      const ship = tupleToShip(shipTuple);
      await randomManager.write.fulfillRandomRequest([ship.traits.serialNumber]);
    }
    await humanShips.write.constructAllMyShips({ account: human.account });

    await humanLobbies.write.createFleet(
      [lobbyId, [1n], [{ row: 0, col: 0 }]],
      { account: human.account },
    );

    // Anyone can trigger the AI to build its fleet
    await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

    lobby = (await lobbies.read.getLobby([lobbyId])) as any;
    expect(lobby.players.joinerFleetId).to.not.equal(0n);

    const gameId = lobbyId;
    let gameData = (await game.read.getGame([gameId])) as GameDataView;
    expect(gameData.metadata.ended).to.equal(false);
    expect(gameData.metadata.creator.toLowerCase()).to.equal(
      human.account.address.toLowerCase(),
    );
    expect(gameData.metadata.joiner.toLowerCase()).to.equal(
      singlePlayerMatch.address.toLowerCase(),
    );
    expect(gameData.turnState.currentTurn.toLowerCase()).to.equal(
      human.account.address.toLowerCase(),
    );

    // Human's tier-0 purchase mints ships 1-5, so the AI's first minted ship
    // (via createSpecificShip) is ship 6, starting at (0, 16). Reposition the
    // human's ship to (0, 15) — one column to its left — so Case 1 of the
    // v0 script applies: stay and fire.
    const humanShipId = 1n;
    const aiShipId = 6n;
    await game.write.debugSetShipPosition([gameId, humanShipId, 0, 15], {
      account: owner.account,
    });
    const humanAttrsBefore = await game.read.getShipAttributes([
      gameId,
      humanShipId,
    ]);

    // Human passes in place
    await humanGame.write.moveShip(
      [gameId, humanShipId, 0, 15, ActionType.Pass, 0n],
      { account: human.account },
    );

    gameData = (await game.read.getGame([gameId])) as GameDataView;
    expect(gameData.turnState.currentTurn.toLowerCase()).to.equal(
      singlePlayerMatch.address.toLowerCase(),
    );

    // Anyone can trigger the AI's turn — takeAITurn moves exactly one ship
    // per call now.
    await singlePlayerMatchOther.write.takeAITurn([gameId]);

    // The AI ship should not have moved (Case 1: enemy already adjacent) and
    // should have fired on the human's ship on this first move.
    const aiPosAfter = findShipPosition(
      (await game.read.getGame([gameId])) as GameDataView,
      aiShipId,
    );
    expect(aiPosAfter.row).to.equal(0);
    expect(aiPosAfter.col).to.equal(16);

    const humanAttrsAfter = await game.read.getShipAttributes([
      gameId,
      humanShipId,
    ]);
    expect(humanAttrsAfter.hullPoints).to.be.lessThan(
      humanAttrsBefore.hullPoints,
    );

    // Both sides only have one ship, so the AI's single move immediately
    // ends the round — and turn order alternates by round, so the AI goes
    // first in round 2 as well, meaning the turn stays with the AI after
    // this first call. Drain any further AI-only turns exactly like the
    // frontend does: keep calling takeAITurn (one ship per call) until the
    // turn actually returns to the human.
    gameData = (await game.read.getGame([gameId])) as GameDataView;
    let guard = 0;
    while (
      !gameData.metadata.ended &&
      gameData.turnState.currentTurn.toLowerCase() ===
        singlePlayerMatch.address.toLowerCase()
    ) {
      guard++;
      expect(guard).to.be.lessThan(10); // safety bound against an infinite loop
      await singlePlayerMatchOther.write.takeAITurn([gameId]);
      gameData = (await game.read.getGame([gameId])) as GameDataView;
    }

    expect(gameData.turnState.currentTurn.toLowerCase()).to.equal(
      human.account.address.toLowerCase(),
    );
  });

  it("reverts takeAITurn when it isn't the AI's turn", async function () {
    const {
      ships,
      lobbies,
      maps,
      singlePlayerMatch,
      aiEncounters,
      universalCredits,
      shipPurchaser,
      randomManager,
      humanLobbies,
      humanShips,
      humanUniversalCredits,
      singlePlayerMatchOther,
      human,
    } = await loadFixture(deploySinglePlayerFixture);

    const mapId = await setupBasicAIEncounter(maps, aiEncounters);
    await createReservedLobby(
      ships,
      lobbies,
      humanLobbies,
      humanUniversalCredits,
      shipPurchaser,
      universalCredits,
      singlePlayerMatch,
      human,
      mapId,
    );

    const lobbyId = 1n;
    await singlePlayerMatchOther.write.acceptMatch([lobbyId]);

    await ships.write.purchaseWithFlow(
      [human.account.address, 0n, human.account.address, 1],
      { value: parseEther("4.99") },
    );
    for (let i = 1; i <= 5; i++) {
      const shipTuple = (await ships.read.ships([BigInt(i)])) as ShipTuple;
      const ship = tupleToShip(shipTuple);
      await randomManager.write.fulfillRandomRequest([ship.traits.serialNumber]);
    }
    await humanShips.write.constructAllMyShips({ account: human.account });

    await humanLobbies.write.createFleet(
      [lobbyId, [1n], [{ row: 0, col: 0 }]],
      { account: human.account },
    );
    await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

    // It's the human's turn right after the game starts (human created their
    // fleet first) — takeAITurn must revert rather than act out of turn
    await expect(
      singlePlayerMatchOther.write.takeAITurn([lobbyId]),
    ).to.be.rejectedWith("NotAITurn");
  });

  it("reverts setupAIFleet when selectedMapId is 0 (no map selected)", async function () {
    const {
      ships,
      lobbies,
      singlePlayerMatch,
      universalCredits,
      shipPurchaser,
      humanLobbies,
      humanUniversalCredits,
      singlePlayerMatchOther,
      human,
    } = await loadFixture(deploySinglePlayerFixture);

    await createReservedLobby(
      ships,
      lobbies,
      humanLobbies,
      humanUniversalCredits,
      shipPurchaser,
      universalCredits,
      singlePlayerMatch,
      human,
      0n,
    );

    const lobbyId = 1n;
    await singlePlayerMatchOther.write.acceptMatch([lobbyId]);

    await expect(
      singlePlayerMatchOther.write.setupAIFleet([lobbyId]),
    ).to.be.rejectedWith("NoAIPlacementsConfigured");
  });

  it("reverts setupAIFleet when the selected map exists but has no AI placements configured", async function () {
    const {
      ships,
      lobbies,
      maps,
      singlePlayerMatch,
      universalCredits,
      shipPurchaser,
      humanLobbies,
      humanUniversalCredits,
      singlePlayerMatchOther,
      human,
    } = await loadFixture(deploySinglePlayerFixture);

    await maps.write.createPresetMap([[]]);
    const mapId = await maps.read.mapCount();

    await createReservedLobby(
      ships,
      lobbies,
      humanLobbies,
      humanUniversalCredits,
      shipPurchaser,
      universalCredits,
      singlePlayerMatch,
      human,
      mapId,
    );

    const lobbyId = 1n;
    await singlePlayerMatchOther.write.acceptMatch([lobbyId]);

    await expect(
      singlePlayerMatchOther.write.setupAIFleet([lobbyId]),
    ).to.be.rejectedWith("NoAIPlacementsConfigured");
  });

  it("builds the AI fleet exactly from the configured map placements", async function () {
    const {
      ships,
      lobbies,
      game,
      maps,
      singlePlayerMatch,
      aiEncounters,
      universalCredits,
      shipPurchaser,
      randomManager,
      humanLobbies,
      humanShips,
      humanUniversalCredits,
      singlePlayerMatchOther,
      human,
    } = await loadFixture(deploySinglePlayerFixture);

    await maps.write.createPresetMap([[]]);
    const mapId = await maps.read.mapCount();

    await aiEncounters.write.createAIShipConfig([
      "Scout",
      { mainWeapon: 0, armor: 0, shields: 0, special: 1 }, // Laser/None/None/EMP
      { ...defaultTraits, variant: 1, accuracy: 1 },
      1, // Aggressor
    ]);
    const scoutConfigId = await aiEncounters.read.aiShipConfigCount();
    await aiEncounters.write.createAIShipConfig([
      "Bruiser",
      { mainWeapon: 1, armor: 1, shields: 0, special: 2 }, // Railgun/Light/None/RepairDrones
      { ...defaultTraits, variant: 1, hull: 2 },
      3, // Support
    ]);
    const bruiserConfigId = await aiEncounters.read.aiShipConfigCount();
    await aiEncounters.write.createAIShipConfig([
      "Support",
      { mainWeapon: 2, armor: 0, shields: 1, special: 3 }, // MissileLauncher/None/Light/FlakArray
      { ...defaultTraits, variant: 1, speed: 2 },
      0, // Grunt
    ]);
    const supportConfigId = await aiEncounters.read.aiShipConfigCount();
    await aiEncounters.write.setMapPlacements([
      mapId,
      [
        { row: 0, col: 16 },
        { row: 1, col: 15 },
        { row: 2, col: 14 },
      ],
      [scoutConfigId, bruiserConfigId, supportConfigId],
    ]);

    await createReservedLobby(
      ships,
      lobbies,
      humanLobbies,
      humanUniversalCredits,
      shipPurchaser,
      universalCredits,
      singlePlayerMatch,
      human,
      mapId,
    );

    const lobbyId = 1n;
    await singlePlayerMatchOther.write.acceptMatch([lobbyId]);

    // Human mints/constructs a ship and creates their fleet (tier 0 mints
    // ships 1-5) — the game only starts once both sides' fleets are set, so
    // this is needed before getGame below will resolve.
    await ships.write.purchaseWithFlow(
      [human.account.address, 0n, human.account.address, 1],
      { value: parseEther("4.99") },
    );
    for (let i = 1; i <= 5; i++) {
      const shipTuple = (await ships.read.ships([BigInt(i)])) as ShipTuple;
      const ship = tupleToShip(shipTuple);
      await randomManager.write.fulfillRandomRequest([ship.traits.serialNumber]);
    }
    await humanShips.write.constructAllMyShips({ account: human.account });
    await humanLobbies.write.createFleet(
      [lobbyId, [1n], [{ row: 0, col: 0 }]],
      { account: human.account },
    );

    await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

    const lobby = (await lobbies.read.getLobby([lobbyId])) as any;
    expect(lobby.players.joinerFleetId).to.not.equal(0n);

    // Human's tier-0 purchase mints ships 1-5, so the AI's ships (minted in
    // placement order) start at 6.
    const scout = tupleToShip((await ships.read.ships([6n])) as ShipTuple);
    expect(scout.name).to.equal("Scout");
    expect(scout.equipment.mainWeapon).to.equal(0);
    expect(scout.equipment.special).to.equal(1);
    expect(scout.traits.accuracy).to.equal(1);

    const bruiser = tupleToShip((await ships.read.ships([7n])) as ShipTuple);
    expect(bruiser.name).to.equal("Bruiser");
    expect(bruiser.equipment.mainWeapon).to.equal(1);
    expect(bruiser.traits.hull).to.equal(2);

    const support = tupleToShip((await ships.read.ships([8n])) as ShipTuple);
    expect(support.name).to.equal("Support");
    expect(support.equipment.shields).to.equal(1);
    expect(support.traits.speed).to.equal(2);

    const gameData = (await game.read.getGame([lobbyId])) as GameDataView;
    expect(findShipPosition(gameData, 6n)).to.deep.equal({ row: 0, col: 16 });
    expect(findShipPosition(gameData, 7n)).to.deep.equal({ row: 1, col: 15 });
    expect(findShipPosition(gameData, 8n)).to.deep.equal({ row: 2, col: 14 });
  });

  it("sizes the AI fleet dynamically from however many placements are configured (not fixed at 3)", async function () {
    const {
      ships,
      lobbies,
      maps,
      singlePlayerMatch,
      aiEncounters,
      universalCredits,
      shipPurchaser,
      humanLobbies,
      humanUniversalCredits,
      singlePlayerMatchOther,
      human,
    } = await loadFixture(deploySinglePlayerFixture);

    await maps.write.createPresetMap([[]]);
    const mapId = await maps.read.mapCount();

    await aiEncounters.write.createAIShipConfig([
      "AI Ship",
      defaultEquipment,
      defaultTraits,
      defaultArchetype,
    ]);
    const configId = await aiEncounters.read.aiShipConfigCount();

    const positions = [
      { row: 0, col: 13 },
      { row: 1, col: 13 },
      { row: 2, col: 13 },
      { row: 3, col: 13 },
      { row: 4, col: 13 },
    ];
    await aiEncounters.write.setMapPlacements([
      mapId,
      positions,
      positions.map(() => configId),
    ]);

    await createReservedLobby(
      ships,
      lobbies,
      humanLobbies,
      humanUniversalCredits,
      shipPurchaser,
      universalCredits,
      singlePlayerMatch,
      human,
      mapId,
    );

    const lobbyId = 1n;
    await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
    await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

    const lobby = (await lobbies.read.getLobby([lobbyId])) as any;
    expect(lobby.players.joinerFleetId).to.not.equal(0n);

    for (let i = 1; i <= 5; i++) {
      const ship = tupleToShip((await ships.read.ships([BigInt(i)])) as ShipTuple);
      expect(ship.owner.toLowerCase()).to.equal(
        singlePlayerMatch.address.toLowerCase(),
      );
    }
  });

  describe("AI behavior archetypes", function () {
    // Mints/constructs the human's single ship (ids 1-5 from the tier-0
    // purchase) and creates their fleet with ship 1 — same boilerplate
    // every scenario below needs before the game actually starts. Exact
    // starting position doesn't matter; each test repositions via the
    // owner-only debug helpers afterward.
    async function setupHumanShip(
      ships: any,
      randomManager: any,
      humanShips: any,
      humanLobbies: any,
      human: any,
      lobbyId: bigint,
    ) {
      await ships.write.purchaseWithFlow(
        [human.account.address, 0n, human.account.address, 1],
        { value: parseEther("4.99") },
      );
      for (let i = 1; i <= 5; i++) {
        const shipTuple = (await ships.read.ships([BigInt(i)])) as ShipTuple;
        const ship = tupleToShip(shipTuple);
        await randomManager.write.fulfillRandomRequest([
          ship.traits.serialNumber,
        ]);
      }
      await humanShips.write.constructAllMyShips({ account: human.account });
      await humanLobbies.write.createFleet(
        [lobbyId, [1n], [{ row: 0, col: 0 }]],
        { account: human.account },
      );
    }

    async function getAITurnTakenEvents(publicClient: any, abi: any, hash: any) {
      const receipt = await publicClient.waitForTransactionReceipt({ hash });
      return parseEventLogs({ abi, logs: receipt.logs, eventName: "AITurnTaken" });
    }

    it("Aggressor archetype shoots an enemy in range", async function () {
      const {
        ships,
        lobbies,
        game,
        maps,
        singlePlayerMatch,
        aiEncounters,
        universalCredits,
        shipPurchaser,
        randomManager,
        humanLobbies,
        humanShips,
        humanGame,
        humanUniversalCredits,
        singlePlayerMatchOther,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[]]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Aggressor Ship",
        defaultEquipment, // Laser, range 3
        defaultTraits,
        1, // Aggressor
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      await createReservedLobby(
        ships,
        lobbies,
        humanLobbies,
        humanUniversalCredits,
        shipPurchaser,
        universalCredits,
        singlePlayerMatch,
        human,
        mapId,
      );

      const lobbyId = 1n;
      await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
      await setupHumanShip(ships, randomManager, humanShips, humanLobbies, human, lobbyId);
      await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

      const aiShipId = 6n;
      await game.write.debugSetShipPosition([lobbyId, 1n, 0, 14], {
        account: owner.account,
      });
      await humanGame.write.moveShip([lobbyId, 1n, 0, 14, ActionType.Pass, 0n], {
        account: human.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([lobbyId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Shoot);
      expect(ev!.args.targetShipId).to.equal(1n);
    });

    it("Sniper archetype retreats rather than staying adjacent to an enemy", async function () {
      const {
        ships,
        lobbies,
        game,
        maps,
        singlePlayerMatch,
        aiEncounters,
        universalCredits,
        shipPurchaser,
        randomManager,
        humanLobbies,
        humanShips,
        humanGame,
        humanUniversalCredits,
        singlePlayerMatchOther,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[]]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Sniper Ship",
        defaultEquipment,
        defaultTraits,
        2, // Sniper
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      await createReservedLobby(
        ships,
        lobbies,
        humanLobbies,
        humanUniversalCredits,
        shipPurchaser,
        universalCredits,
        singlePlayerMatch,
        human,
        mapId,
      );

      const lobbyId = 1n;
      await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
      await setupHumanShip(ships, randomManager, humanShips, humanLobbies, human, lobbyId);
      await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

      const aiShipId = 6n;
      // Reposition both ships (away from the fixed fleet-setup corner) so
      // there's room to observe a retreat: Sniper at (5,10), enemy adjacent
      // at (5,9).
      await game.write.debugSetShipPosition([lobbyId, aiShipId, 5, 10], {
        account: owner.account,
      });
      await game.write.debugSetShipPosition([lobbyId, 1n, 5, 9], {
        account: owner.account,
      });
      await humanGame.write.moveShip([lobbyId, 1n, 5, 9, ActionType.Pass, 0n], {
        account: human.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([lobbyId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Pass);

      const gameData = (await game.read.getGame([lobbyId])) as GameDataView;
      const pos = findShipPosition(gameData, aiShipId);
      // Moved away from the enemy (col increased), not toward/adjacent.
      expect(pos.col).to.be.greaterThan(10);
    });

    it("Sniper archetype shoots without moving when the enemy is at range but not adjacent", async function () {
      const {
        ships,
        lobbies,
        game,
        maps,
        singlePlayerMatch,
        aiEncounters,
        universalCredits,
        shipPurchaser,
        randomManager,
        humanLobbies,
        humanShips,
        humanGame,
        humanUniversalCredits,
        singlePlayerMatchOther,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[]]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Sniper Ship",
        defaultEquipment,
        defaultTraits,
        2, // Sniper
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      await createReservedLobby(
        ships,
        lobbies,
        humanLobbies,
        humanUniversalCredits,
        shipPurchaser,
        universalCredits,
        singlePlayerMatch,
        human,
        mapId,
      );

      const lobbyId = 1n;
      await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
      await setupHumanShip(ships, randomManager, humanShips, humanLobbies, human, lobbyId);
      await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

      const aiShipId = 6n;
      await game.write.debugSetShipPosition([lobbyId, aiShipId, 5, 10], {
        account: owner.account,
      });
      await game.write.debugSetShipPosition([lobbyId, 1n, 5, 8], {
        account: owner.account,
      });
      await humanGame.write.moveShip([lobbyId, 1n, 5, 8, ActionType.Pass, 0n], {
        account: human.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([lobbyId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Shoot);
      expect(ev!.args.targetShipId).to.equal(1n);

      const gameData = (await game.read.getGame([lobbyId])) as GameDataView;
      const pos = findShipPosition(gameData, aiShipId);
      expect(pos.row).to.equal(5);
      expect(pos.col).to.equal(10);
    });

    it("Support archetype heals the weakest ally over shooting an available enemy", async function () {
      const {
        ships,
        lobbies,
        game,
        maps,
        singlePlayerMatch,
        aiEncounters,
        universalCredits,
        shipPurchaser,
        randomManager,
        humanLobbies,
        humanShips,
        humanGame,
        humanUniversalCredits,
        singlePlayerMatchOther,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[]]);
      const mapId = await maps.read.mapCount();

      // Scan order (row-major, col 13->16) mints the col-15 placement
      // before col-16, so the healer ends up with the lower shipId and
      // acts first — before the (deliberately 0-HP) ally would otherwise
      // get stuck retrying an illegal turn of its own.
      await aiEncounters.write.createAIShipConfig([
        "Healer",
        { mainWeapon: 0, armor: 0, shields: 0, special: 2 }, // Laser/.../RepairDrones
        defaultTraits,
        3, // Support
      ]);
      const healerConfigId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.createAIShipConfig([
        "Ally",
        defaultEquipment,
        defaultTraits,
        0, // Grunt
      ]);
      const allyConfigId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacements([
        mapId,
        [
          { row: 0, col: 15 },
          { row: 0, col: 16 },
        ],
        [healerConfigId, allyConfigId],
      ]);

      await createReservedLobby(
        ships,
        lobbies,
        humanLobbies,
        humanUniversalCredits,
        shipPurchaser,
        universalCredits,
        singlePlayerMatch,
        human,
        mapId,
      );

      const lobbyId = 1n;
      await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
      await setupHumanShip(ships, randomManager, humanShips, humanLobbies, human, lobbyId);
      await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

      const healerShipId = 6n;
      const allyShipId = 7n;

      await game.write.debugSetHullPointsToZero([lobbyId, allyShipId], {
        account: owner.account,
      });
      await game.write.debugSetShipPosition([lobbyId, 1n, 0, 13], {
        account: owner.account,
      });
      await humanGame.write.moveShip([lobbyId, 1n, 0, 13, ActionType.Pass, 0n], {
        account: human.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([lobbyId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === healerShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Special);
      expect(ev!.args.targetShipId).to.equal(allyShipId);

      const allyAttrs = await game.read.getShipAttributes([lobbyId, allyShipId]);
      expect(allyAttrs.hullPoints).to.be.greaterThan(0);
    });

    it("Turtle archetype moves toward an unclaimed scoring tile when no enemy is in range", async function () {
      const {
        ships,
        lobbies,
        game,
        maps,
        singlePlayerMatch,
        aiEncounters,
        universalCredits,
        shipPurchaser,
        randomManager,
        humanLobbies,
        humanShips,
        humanGame,
        humanUniversalCredits,
        singlePlayerMatchOther,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetScoringMap([
        [{ row: 0, col: 13, points: 5, onlyOnce: false }],
      ]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Turtle Ship",
        defaultEquipment,
        defaultTraits,
        4, // Turtle
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      await createReservedLobby(
        ships,
        lobbies,
        humanLobbies,
        humanUniversalCredits,
        shipPurchaser,
        universalCredits,
        singlePlayerMatch,
        human,
        mapId,
      );

      const lobbyId = 1n;
      await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
      await setupHumanShip(ships, randomManager, humanShips, humanLobbies, human, lobbyId);
      await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

      const aiShipId = 6n;
      // Keep the human ship far away, out of any plausible gun range.
      await game.write.debugSetShipPosition([lobbyId, 1n, 10, 0], {
        account: owner.account,
      });
      await humanGame.write.moveShip([lobbyId, 1n, 10, 0, ActionType.Pass, 0n], {
        account: human.account,
      });

      const beforeData = (await game.read.getGame([lobbyId])) as GameDataView;
      const before = findShipPosition(beforeData, aiShipId);

      const hash = await singlePlayerMatchOther.write.takeAITurn([lobbyId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Pass);

      const afterData = (await game.read.getGame([lobbyId])) as GameDataView;
      const after = findShipPosition(afterData, aiShipId);
      const distBefore = Math.abs(before.row - 0) + Math.abs(before.col - 13);
      const distAfter = Math.abs(after.row - 0) + Math.abs(after.col - 13);
      expect(distAfter).to.be.lessThan(distBefore);
    });

    it("Rammer archetype Rams an adjacent 0-HP enemy when its faction is 1", async function () {
      const {
        ships,
        lobbies,
        game,
        maps,
        singlePlayerMatch,
        aiEncounters,
        universalCredits,
        shipPurchaser,
        randomManager,
        humanLobbies,
        humanShips,
        humanGame,
        humanUniversalCredits,
        singlePlayerMatchOther,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[]]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Rammer Ship",
        defaultEquipment,
        { ...defaultTraits, variant: 1 },
        5, // Rammer
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      await createReservedLobby(
        ships,
        lobbies,
        humanLobbies,
        humanUniversalCredits,
        shipPurchaser,
        universalCredits,
        singlePlayerMatch,
        human,
        mapId,
      );

      const lobbyId = 1n;
      await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
      await setupHumanShip(ships, randomManager, humanShips, humanLobbies, human, lobbyId);
      await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

      const aiShipId = 6n;

      // Human ship takes its own turn at full HP first (a 0-HP ship can
      // only Retreat, not Pass), then gets zeroed and moved adjacent.
      await humanGame.write.moveShip([lobbyId, 1n, 0, 0, ActionType.Pass, 0n], {
        account: human.account,
      });
      await game.write.debugSetHullPointsToZero([lobbyId, 1n], {
        account: owner.account,
      });
      await game.write.debugSetShipPosition([lobbyId, 1n, 0, 15], {
        account: owner.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([lobbyId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.FactionAbility);
      expect(ev!.args.targetShipId).to.equal(1n);
    });

    it("Rammer archetype never attempts Ram when its faction isn't 1", async function () {
      const {
        ships,
        lobbies,
        game,
        maps,
        singlePlayerMatch,
        aiEncounters,
        universalCredits,
        shipPurchaser,
        randomManager,
        humanLobbies,
        humanShips,
        humanGame,
        humanUniversalCredits,
        singlePlayerMatchOther,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[]]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Not-Faction-1 Rammer",
        defaultEquipment,
        { ...defaultTraits, variant: 2 },
        5, // Rammer
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      await createReservedLobby(
        ships,
        lobbies,
        humanLobbies,
        humanUniversalCredits,
        shipPurchaser,
        universalCredits,
        singlePlayerMatch,
        human,
        mapId,
      );

      const lobbyId = 1n;
      await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
      await setupHumanShip(ships, randomManager, humanShips, humanLobbies, human, lobbyId);
      await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

      const aiShipId = 6n;

      await humanGame.write.moveShip([lobbyId, 1n, 0, 0, ActionType.Pass, 0n], {
        account: human.account,
      });
      await game.write.debugSetHullPointsToZero([lobbyId, 1n], {
        account: owner.account,
      });
      await game.write.debugSetShipPosition([lobbyId, 1n, 0, 15], {
        account: owner.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([lobbyId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.not.equal(ActionType.FactionAbility);
    });

    it("falls back to Pass without reverting the whole turn when the decided move is illegal", async function () {
      const {
        ships,
        lobbies,
        game,
        maps,
        singlePlayerMatch,
        aiEncounters,
        universalCredits,
        shipPurchaser,
        randomManager,
        humanLobbies,
        humanShips,
        humanGame,
        humanUniversalCredits,
        singlePlayerMatchOther,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[]]);
      const mapId = await maps.read.mapCount();
      // PlasmaCannon: range 2, well under this ship's movement (3) — an
      // enemy placed exactly at movement distance but outside gun range
      // makes the shared "step toward" primitive walk straight onto the
      // enemy's own tile (it doesn't check occupancy), which Game.sol
      // correctly rejects as an occupied destination. This is a real edge
      // case the cheap stepping primitive has, not a contrived one.
      await aiEncounters.write.createAIShipConfig([
        "Plasma Grunt",
        { mainWeapon: 3, armor: 0, shields: 0, special: 0 },
        defaultTraits,
        0, // Grunt
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      await createReservedLobby(
        ships,
        lobbies,
        humanLobbies,
        humanUniversalCredits,
        shipPurchaser,
        universalCredits,
        singlePlayerMatch,
        human,
        mapId,
      );

      const lobbyId = 1n;
      await singlePlayerMatchOther.write.acceptMatch([lobbyId]);
      await setupHumanShip(ships, randomManager, humanShips, humanLobbies, human, lobbyId);
      await singlePlayerMatchOther.write.setupAIFleet([lobbyId]);

      const aiShipId = 6n;
      await game.write.debugSetShipPosition([lobbyId, 1n, 0, 13], {
        account: owner.account,
      });
      await humanGame.write.moveShip([lobbyId, 1n, 0, 13, ActionType.Pass, 0n], {
        account: human.account,
      });

      // Must not throw/revert.
      const hash = await singlePlayerMatchOther.write.takeAITurn([lobbyId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Pass);
      expect(ev!.args.targetShipId).to.equal(0n);

      const gameData = (await game.read.getGame([lobbyId])) as GameDataView;
      const pos = findShipPosition(gameData, aiShipId);
      expect(pos.row).to.equal(0);
      expect(pos.col).to.equal(16);
    });
  });
});
