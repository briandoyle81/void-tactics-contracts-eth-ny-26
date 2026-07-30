import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import { parseEther, parseEventLogs } from "viem";
import {
  ShipTuple,
  tupleToShip,
  ActionType,
  GameDataView,
  MapMode,
} from "./types";
import DeployModule from "../ignition/modules/DeployAndConfig";

// Node-match game ids live in a disjoint range above Lobbies-sourced (PvP)
// ids — see SinglePlayerMatch.sol's NODE_MATCH_ID_OFFSET. Every test below
// starts exactly one node match against a fresh fixture, so its gameId is
// always this offset plus 1.
const NODE_MATCH_ID_OFFSET = 2n ** 40n;

// AI ship ids live in AIShips.sol's own local id space, offset by this same
// constant (mirrors AIShips.sol's AI_SHIP_ID_OFFSET) so ShipsRouter can tell
// them apart from Ships.sol's (human) ids. Every test below allocates AI
// ships against a fresh AIShips pool, so the Nth AI ship ever allocated in
// that test is always this offset plus N, regardless of how many human
// ships were minted first.
const AI_SHIP_ID_OFFSET = 2n ** 40n;

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
    const humanSinglePlayerMatch = await hre.viem.getContractAt(
      "SinglePlayerMatch",
      deployed.singlePlayerMatch.address,
      { client: { wallet: human } },
    );
    const singlePlayerMatchOther = await hre.viem.getContractAt(
      "SinglePlayerMatch",
      deployed.singlePlayerMatch.address,
      { client: { wallet: other } },
    );

    return {
      ships: deployed.ships,
      aiShips: deployed.aiShips,
      shipsRouter: deployed.shipsRouter,
      game: deployed.game,
      maps: deployed.maps,
      nodeMap: deployed.nodeMap,
      singlePlayerMatch: deployed.singlePlayerMatch,
      aiEncounters: deployed.aiEncounters,
      universalCredits: deployed.universalCredits,
      droneEnergyCores: deployed.droneEnergyCores,
      randomManager: deployed.randomManager,
      humanShips,
      humanGame,
      humanSinglePlayerMatch,
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
  // produced for ship index 0 — and returns its map id. _mintAIFleet reads
  // its fleet composition/placement entirely from AIEncounters, so every
  // single-player test needs a real, non-empty configured map.
  async function setupBasicAIEncounter(maps: any, aiEncounters: any) {
    await maps.write.createPresetMap([[], MapMode.Both]);
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

  // Admin-curates a campaign node against the given map (as owner, the
  // deployer/node editor by default) and returns its id. costLimit/turnTime/
  // maxScore mirror what a generous player-chosen lobby used to allow.
  async function createCampaignNode(
    nodeMap: any,
    mapId: bigint,
    prerequisites: bigint[] = [],
  ) {
    await nodeMap.write.createNode([
      1n, // campaignId — reuses the deploy-seeded "mainCampaign" (id 1)
      mapId,
      prerequisites,
      2000n, // costLimit
      86400n, // turnTime
      20n, // maxScore
      true, // creatorGoesFirst
      2000n, // enemyThreat (descriptive only, not enforced)
    ]);
    return await nodeMap.read.nodeCount();
  }

  // Mints and constructs the human's tier-0 ships (ids 1-5) — same
  // boilerplate every scenario below needs before startNodeMatch. Does not
  // create a fleet itself; startNodeMatch does that as part of entering the
  // match.
  async function purchaseAndConstructHumanShip(
    ships: any,
    randomManager: any,
    humanShips: any,
    human: any,
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
  }

  it("identifies only this contract's own address as the single-player orchestrator", async function () {
    const { singlePlayerMatch, human } = await loadFixture(
      deploySinglePlayerFixture,
    );
    expect(
      await singlePlayerMatch.read.isSinglePlayerOrchestrator([
        singlePlayerMatch.address,
      ]),
    ).to.equal(true);
    expect(
      await singlePlayerMatch.read.isSinglePlayerOrchestrator([
        human.account.address,
      ]),
    ).to.equal(false);
  });

  it("plays a single-player match end to end through startNodeMatch", async function () {
    const {
      ships,
      game,
      maps,
      nodeMap,
      singlePlayerMatch,
      aiEncounters,
      randomManager,
      humanShips,
      humanGame,
      humanSinglePlayerMatch,
      singlePlayerMatchOther,
      human,
      owner,
    } = await loadFixture(deploySinglePlayerFixture);

    const mapId = await setupBasicAIEncounter(maps, aiEncounters);
    const nodeId = await createCampaignNode(nodeMap, mapId);

    // Human purchases and constructs a ship. Creator ships must sit in
    // columns 0-3, so it starts far from the AI's fleet (col 16) — repositioned
    // below via the debug helper to directly exercise the v0 script's Case 1
    // (adjacent enemy) without needing 10+ rounds of the AI closing the gap.
    await purchaseAndConstructHumanShip(ships, randomManager, humanShips, human);

    await humanSinglePlayerMatch.write.startNodeMatch([
      nodeId,
      [1n],
      [{ row: 0, col: 0 }],
    ]);

    const gameId = NODE_MATCH_ID_OFFSET + 1n;

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

    // The AI's first ship allocated from AIShips' pool starts at (0, 16),
    // regardless of the human's own ship ids. Reposition the human's ship
    // to (0, 15) — one column to its left — so Case 1 of the v0 script
    // applies: stay and fire.
    const humanShipId = 1n;
    const aiShipId = AI_SHIP_ID_OFFSET + 1n;
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
      maps,
      nodeMap,
      aiEncounters,
      randomManager,
      humanShips,
      humanSinglePlayerMatch,
      singlePlayerMatchOther,
      human,
    } = await loadFixture(deploySinglePlayerFixture);

    const mapId = await setupBasicAIEncounter(maps, aiEncounters);
    const nodeId = await createCampaignNode(nodeMap, mapId);

    await purchaseAndConstructHumanShip(ships, randomManager, humanShips, human);
    await humanSinglePlayerMatch.write.startNodeMatch([
      nodeId,
      [1n],
      [{ row: 0, col: 0 }],
    ]);

    const gameId = NODE_MATCH_ID_OFFSET + 1n;

    // It's the human's turn right after the game starts (human is always
    // creatorGoesFirst on a campaign node here) — takeAITurn must revert
    // rather than act out of turn.
    await expect(
      singlePlayerMatchOther.write.takeAITurn([gameId]),
    ).to.be.rejectedWith("NotAITurn");
  });

  it("reverts startNodeMatch when the node does not exist", async function () {
    const { humanSinglePlayerMatch } = await loadFixture(
      deploySinglePlayerFixture,
    );

    await expect(
      humanSinglePlayerMatch.write.startNodeMatch([999n, [], []]),
    ).to.be.rejectedWith("NodeNotFound");
  });

  it("reverts startNodeMatch when the node's map has no AI placements configured", async function () {
    const { maps, nodeMap, humanSinglePlayerMatch } = await loadFixture(
      deploySinglePlayerFixture,
    );

    await maps.write.createPresetMap([[], MapMode.Both]);
    const mapId = await maps.read.mapCount();
    const nodeId = await createCampaignNode(nodeMap, mapId);

    await expect(
      humanSinglePlayerMatch.write.startNodeMatch([nodeId, [], []]),
    ).to.be.rejectedWith("NoAIPlacementsConfigured");
  });

  it("builds the AI fleet exactly from the configured map placements", async function () {
    const {
      ships,
      aiShips,
      game,
      maps,
      nodeMap,
      aiEncounters,
      randomManager,
      humanShips,
      humanSinglePlayerMatch,
      human,
    } = await loadFixture(deploySinglePlayerFixture);

    await maps.write.createPresetMap([[], MapMode.Both]);
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

    const nodeId = await createCampaignNode(nodeMap, mapId);

    // Human mints/constructs a ship — the game only starts once
    // startNodeMatch runs, so this is needed before getGame below resolves.
    await purchaseAndConstructHumanShip(ships, randomManager, humanShips, human);
    await humanSinglePlayerMatch.write.startNodeMatch([
      nodeId,
      [1n],
      [{ row: 0, col: 0 }],
    ]);

    const gameId = NODE_MATCH_ID_OFFSET + 1n;

    // AIShips' pool allocates ids independently of the human's own ships —
    // the AI's ships (allocated in placement order) start at
    // AI_SHIP_ID_OFFSET + 1.
    const scoutId = AI_SHIP_ID_OFFSET + 1n;
    const bruiserId = AI_SHIP_ID_OFFSET + 2n;
    const supportId = AI_SHIP_ID_OFFSET + 3n;

    const scout = await aiShips.read.getShip([scoutId]);
    expect(scout.name).to.equal("Scout");
    expect(scout.equipment.mainWeapon).to.equal(0);
    expect(scout.equipment.special).to.equal(1);
    expect(scout.traits.accuracy).to.equal(1);

    const bruiser = await aiShips.read.getShip([bruiserId]);
    expect(bruiser.name).to.equal("Bruiser");
    expect(bruiser.equipment.mainWeapon).to.equal(1);
    expect(bruiser.traits.hull).to.equal(2);

    const support = await aiShips.read.getShip([supportId]);
    expect(support.name).to.equal("Support");
    expect(support.equipment.shields).to.equal(1);
    expect(support.traits.speed).to.equal(2);

    const gameData = (await game.read.getGame([gameId])) as GameDataView;
    expect(findShipPosition(gameData, scoutId)).to.deep.equal({ row: 0, col: 16 });
    expect(findShipPosition(gameData, bruiserId)).to.deep.equal({ row: 1, col: 15 });
    expect(findShipPosition(gameData, supportId)).to.deep.equal({ row: 2, col: 14 });
  });

  it("sizes the AI fleet dynamically from however many placements are configured (not fixed at 3)", async function () {
    const { aiShips, maps, nodeMap, singlePlayerMatch, aiEncounters, humanSinglePlayerMatch, human } =
      await loadFixture(deploySinglePlayerFixture);

    await maps.write.createPresetMap([[], MapMode.Both]);
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

    const nodeId = await createCampaignNode(nodeMap, mapId);

    await humanSinglePlayerMatch.write.startNodeMatch([nodeId, [], []]);

    // No human ships were minted in this test (empty fleet), so all 5 ids
    // allocated here are the AI's — AIShips' pool starts at
    // AI_SHIP_ID_OFFSET + 1 regardless.
    for (let i = 1; i <= 5; i++) {
      const ship = await aiShips.read.getShip([AI_SHIP_ID_OFFSET + BigInt(i)]);
      expect(ship.owner.toLowerCase()).to.equal(
        singlePlayerMatch.address.toLowerCase(),
      );
    }
  });

  it("does not cap the AI fleet's cost against the node's costLimit", async function () {
    const { maps, nodeMap, aiEncounters, humanSinglePlayerMatch } =
      await loadFixture(deploySinglePlayerFixture);

    // setupBasicAIEncounter's single default-traits AI ship still costs 75
    // (baseCost 50 + Laser's mainWeapon cost 25) — comfortably more than
    // the costLimit: 1n below. If the AI fleet were still capped against
    // the node's costLimit (the old behavior), minting it would revert
    // InvalidFleetCost; an admin-curated encounter should never be
    // second-guessed by the human's own fleet-cost ceiling.
    const mapId = await setupBasicAIEncounter(maps, aiEncounters);
    await nodeMap.write.createNode([1n, mapId, [], 1n, 600n, 20n, true, 1n]);
    const nodeId = await nodeMap.read.nodeCount();

    // Human enters with an empty fleet (cost 0, so it alone can't prove
    // anything — the AI fleet is what has to clear a costLimit of 1).
    await humanSinglePlayerMatch.write.startNodeMatch([nodeId, [], []]);
  });

  describe("Deploy-seeded starter maps", function () {
    it("seeds ten starter maps, the first two with AI fleets clustered at column 13, closest to the human's side", async function () {
      const { maps, aiEncounters } = await loadFixture(deploySinglePlayerFixture);

      expect(await maps.read.mapCount()).to.equal(10n);

      // Map 1: starter map — 3 blocked tiles (a light wall biasing the
      // early fight toward the AI, per the map's own light-terrain design)
      // and one scoring tile, moved toward the AI's side for the same
      // reason.
      const map1Blocked = await maps.read.getPresetMap([1n]);
      expect(map1Blocked.length).to.equal(3);
      const map1Scoring = await maps.read.getPresetScoringMap([1n]);
      expect(map1Scoring.length).to.equal(1);
      expect(map1Scoring[0].col).to.equal(12);

      // Trimmed to 3 ships (Grunt/Aggressor/Turtle) for an easier first
      // fight — Sniper's retreat behavior and Support's healing are held
      // back for later maps.
      const [map1Positions] = await aiEncounters.read.getMapPlacements([1n]);
      expect(map1Positions.length).to.equal(3);
      for (const pos of map1Positions as any[]) {
        expect(pos.col).to.equal(13);
      }
      const map1Rows = (map1Positions as any[])
        .map((p) => p.row)
        .sort((a, b) => a - b);
      expect(map1Rows).to.deep.equal([4, 5, 6]);

      // Map 2: nebula map — 52 blocked tiles, 5 scoring tiles
      const map2Blocked = await maps.read.getPresetMap([2n]);
      expect(map2Blocked.length).to.equal(52);
      const map2Scoring = await maps.read.getPresetScoringMap([2n]);
      expect(map2Scoring.length).to.equal(5);

      const [map2Positions] = await aiEncounters.read.getMapPlacements([2n]);
      expect(map2Positions.length).to.equal(5); // no Rammer — AI has no ram decision path
      for (const pos of map2Positions as any[]) {
        expect(pos.col).to.equal(13);
        // None of these spawn points should land on a blocked (nebula) tile
        const isBlocked = (map2Blocked as any[]).some(
          (b) => b.row === pos.row && b.col === pos.col,
        );
        expect(isBlocked).to.equal(false);
      }
      const map2Rows = (map2Positions as any[])
        .map((p) => p.row)
        .sort((a, b) => a - b);
      expect(map2Rows).to.deep.equal([4, 5, 6, 7, 8]);
    });

    it("seeds a ten-node campaign graph with a two-node dead end and a hard-fight shortcut", async function () {
      const { nodeMap, human } = await loadFixture(deploySinglePlayerFixture);

      expect(await nodeMap.read.nodeCount()).to.equal(10n);

      // All 10 seeded nodes belong to the single deploy-seeded
      // "mainCampaign" (id 1).
      expect(await nodeMap.read.campaignCount()).to.equal(1n);
      const campaignNodeIds = (await nodeMap.read.getNodesInCampaign([
        1n,
      ])) as bigint[];
      expect(campaignNodeIds.length).to.equal(10);

      // Node 7 (silentHulk) is the dead end's terminal node: it requires
      // node 6 (driftWreck), which itself branches off node 2, and nothing
      // in the graph lists node 7 as a prerequisite — so completing it
      // doesn't unlock anything further.
      expect(await nodeMap.read.getPrerequisites([6n])).to.deep.equal([2n]);
      expect(await nodeMap.read.getPrerequisites([7n])).to.deep.equal([6n]);
      for (let nodeId = 1n; nodeId <= 10n; nodeId++) {
        const prereqs = (await nodeMap.read.getPrerequisites([
          nodeId,
        ])) as bigint[];
        expect(prereqs).to.not.deep.include(7n);
      }

      // Node 9 (gauntlet) is reachable either the "long way" — node 2 -> 3
      // (outpost) -> 4 (junkyard) -> 5 (asteroidField), three intermediate
      // nodes — or via node 8 (warlordsRedoubt), a single hard fight
      // branching directly off node 2. ANY-of prerequisite semantics mean
      // beating node 8 alone unlocks node 9, skipping nodes 3-5 entirely.
      expect(await nodeMap.read.getPrerequisites([8n])).to.deep.equal([2n]);
      expect(await nodeMap.read.getPrerequisites([9n])).to.deep.equal([
        5n,
        8n,
      ]);

      expect(
        await nodeMap.read.isNodeUnlocked([human.account.address, 9n]),
      ).to.equal(false);
    });
  });

  describe("AI behavior archetypes", function () {
    async function getAITurnTakenEvents(publicClient: any, abi: any, hash: any) {
      const receipt = await publicClient.waitForTransactionReceipt({ hash });
      return parseEventLogs({ abi, logs: receipt.logs, eventName: "AITurnTaken" });
    }

    // Shared setup: curate a node against mapId, mint/construct the human's
    // ship, and enter the match. Returns the started match's gameId.
    async function startMatch(
      nodeMap: any,
      ships: any,
      randomManager: any,
      humanShips: any,
      humanSinglePlayerMatch: any,
      human: any,
      mapId: bigint,
    ) {
      const nodeId = await createCampaignNode(nodeMap, mapId);
      await purchaseAndConstructHumanShip(ships, randomManager, humanShips, human);
      await humanSinglePlayerMatch.write.startNodeMatch([
        nodeId,
        [1n],
        [{ row: 0, col: 0 }],
      ]);
      return NODE_MATCH_ID_OFFSET + 1n;
    }

    it("Aggressor archetype shoots an enemy in range", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        singlePlayerMatch,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[], MapMode.Both]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Aggressor Ship",
        defaultEquipment, // Laser, range 3
        defaultTraits,
        1, // Aggressor
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      const gameId = await startMatch(
        nodeMap,
        ships,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
        mapId,
      );

      const aiShipId = AI_SHIP_ID_OFFSET + 1n;
      await game.write.debugSetShipPosition([gameId, 1n, 0, 14], {
        account: owner.account,
      });
      await humanGame.write.moveShip([gameId, 1n, 0, 14, ActionType.Pass, 0n], {
        account: human.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([gameId]);
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
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        singlePlayerMatch,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[], MapMode.Both]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Sniper Ship",
        defaultEquipment,
        defaultTraits,
        2, // Sniper
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      const gameId = await startMatch(
        nodeMap,
        ships,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
        mapId,
      );

      const aiShipId = AI_SHIP_ID_OFFSET + 1n;
      // Reposition both ships (away from the fixed fleet-setup corner) so
      // there's room to observe a retreat: Sniper at (5,10), enemy adjacent
      // at (5,9).
      await game.write.debugSetShipPosition([gameId, aiShipId, 5, 10], {
        account: owner.account,
      });
      await game.write.debugSetShipPosition([gameId, 1n, 5, 9], {
        account: owner.account,
      });
      await humanGame.write.moveShip([gameId, 1n, 5, 9, ActionType.Pass, 0n], {
        account: human.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([gameId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Pass);

      const gameData = (await game.read.getGame([gameId])) as GameDataView;
      const pos = findShipPosition(gameData, aiShipId);
      // Moved away from the enemy (col increased), not toward/adjacent.
      expect(pos.col).to.be.greaterThan(10);
    });

    it("Sniper archetype shoots without moving when the enemy is at range but not adjacent", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        singlePlayerMatch,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[], MapMode.Both]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "Sniper Ship",
        defaultEquipment,
        defaultTraits,
        2, // Sniper
      ]);
      const configId = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacement([mapId, 0, 16, configId]);

      const gameId = await startMatch(
        nodeMap,
        ships,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
        mapId,
      );

      const aiShipId = AI_SHIP_ID_OFFSET + 1n;
      await game.write.debugSetShipPosition([gameId, aiShipId, 5, 10], {
        account: owner.account,
      });
      await game.write.debugSetShipPosition([gameId, 1n, 5, 8], {
        account: owner.account,
      });
      await humanGame.write.moveShip([gameId, 1n, 5, 8, ActionType.Pass, 0n], {
        account: human.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([gameId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Shoot);
      expect(ev!.args.targetShipId).to.equal(1n);

      const gameData = (await game.read.getGame([gameId])) as GameDataView;
      const pos = findShipPosition(gameData, aiShipId);
      expect(pos.row).to.equal(5);
      expect(pos.col).to.equal(10);
    });

    it("Support archetype heals the weakest ally over shooting an available enemy", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        singlePlayerMatch,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[], MapMode.Both]);
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

      const gameId = await startMatch(
        nodeMap,
        ships,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
        mapId,
      );

      const healerShipId = AI_SHIP_ID_OFFSET + 1n;
      const allyShipId = AI_SHIP_ID_OFFSET + 2n;

      await game.write.debugSetHullPointsToZero([gameId, allyShipId], {
        account: owner.account,
      });
      await game.write.debugSetShipPosition([gameId, 1n, 0, 13], {
        account: owner.account,
      });
      await humanGame.write.moveShip([gameId, 1n, 0, 13, ActionType.Pass, 0n], {
        account: human.account,
      });

      const hash = await singlePlayerMatchOther.write.takeAITurn([gameId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === healerShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Special);
      expect(ev!.args.targetShipId).to.equal(allyShipId);

      const allyAttrs = await game.read.getShipAttributes([gameId, allyShipId]);
      expect(allyAttrs.hullPoints).to.be.greaterThan(0);
    });

    it("Turtle archetype moves toward an unclaimed scoring tile when no enemy is in range", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        singlePlayerMatch,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetScoringMap([
        [{ row: 0, col: 13, points: 5, onlyOnce: false }],
        MapMode.Both,
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

      const gameId = await startMatch(
        nodeMap,
        ships,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
        mapId,
      );

      const aiShipId = AI_SHIP_ID_OFFSET + 1n;
      // Keep the human ship far away, out of any plausible gun range.
      await game.write.debugSetShipPosition([gameId, 1n, 10, 0], {
        account: owner.account,
      });
      await humanGame.write.moveShip([gameId, 1n, 10, 0, ActionType.Pass, 0n], {
        account: human.account,
      });

      const beforeData = (await game.read.getGame([gameId])) as GameDataView;
      const before = findShipPosition(beforeData, aiShipId);

      const hash = await singlePlayerMatchOther.write.takeAITurn([gameId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Pass);

      const afterData = (await game.read.getGame([gameId])) as GameDataView;
      const after = findShipPosition(afterData, aiShipId);
      const distBefore = Math.abs(before.row - 0) + Math.abs(before.col - 13);
      const distAfter = Math.abs(after.row - 0) + Math.abs(after.col - 13);
      expect(distAfter).to.be.lessThan(distBefore);
    });

    it("falls back to Pass without reverting the whole turn when the decided move is illegal", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        singlePlayerMatch,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      await maps.write.createPresetMap([[], MapMode.Both]);
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

      const gameId = await startMatch(
        nodeMap,
        ships,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
        mapId,
      );

      const aiShipId = AI_SHIP_ID_OFFSET + 1n;
      await game.write.debugSetShipPosition([gameId, 1n, 0, 13], {
        account: owner.account,
      });
      await humanGame.write.moveShip([gameId, 1n, 0, 13, ActionType.Pass, 0n], {
        account: human.account,
      });

      // Must not throw/revert.
      const hash = await singlePlayerMatchOther.write.takeAITurn([gameId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      const ev = events.find((e: any) => e.args.shipId === aiShipId);
      expect(ev).to.not.be.undefined;
      expect(ev!.args.actionType).to.equal(ActionType.Pass);
      expect(ev!.args.targetShipId).to.equal(0n);

      const gameData = (await game.read.getGame([gameId])) as GameDataView;
      const pos = findShipPosition(gameData, aiShipId);
      expect(pos.row).to.equal(0);
      expect(pos.col).to.equal(16);
    });

    it("skips a 0-HP ship and moves the next one instead of getting stuck (regression: this used to deadlock the whole match)", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        singlePlayerMatch,
        human,
        owner,
        publicClient,
      } = await loadFixture(deploySinglePlayerFixture);

      // Two AI ships on this map instead of one, so there's a live ship
      // behind the zeroed-out one for the AI to reach.
      await maps.write.createPresetMap([[], MapMode.Both]);
      const mapId = await maps.read.mapCount();
      await aiEncounters.write.createAIShipConfig([
        "AI Grunt A",
        defaultEquipment,
        defaultTraits,
        defaultArchetype,
      ]);
      const config1 = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.createAIShipConfig([
        "AI Grunt B",
        defaultEquipment,
        defaultTraits,
        defaultArchetype,
      ]);
      const config2 = await aiEncounters.read.aiShipConfigCount();
      await aiEncounters.write.setMapPlacements([
        mapId,
        [
          { row: 0, col: 16 },
          { row: 1, col: 16 },
        ],
        [config1, config2],
      ]);

      const gameId = await startMatch(
        nodeMap,
        ships,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
        mapId,
      );

      const deadAiShipId = AI_SHIP_ID_OFFSET + 1n;
      const liveAiShipId = AI_SHIP_ID_OFFSET + 2n;

      // Human passes in place, handing the turn to the AI
      await humanGame.write.moveShip(
        [gameId, 1n, 0, 0, ActionType.Pass, 0n],
        { account: human.account },
      );

      // Simulate the first AI ship having already been shot down to 0 HP
      // (mid reactor-critical grace period, not yet removed) — exactly the
      // state that used to permanently deadlock the AI's turn, since
      // _findUnmovedShip always picked this ship first (it's the first
      // unmoved ship in joinerActiveShipIds) and it could never
      // successfully move (moveShip reverts ShipDestroyed for any
      // non-Retreat action at 0 HP), so it never entered
      // joinerMovedShipIds and every other ship behind it was unreachable.
      await game.write.debugSetHullPointsToZero([gameId, deadAiShipId], {
        account: owner.account,
      });

      const preGameData = (await game.read.getGame([gameId])) as GameDataView;
      const preRound = preGameData.turnState.currentRound;

      // Must not get stuck: the AI should skip the dead ship and
      // successfully move the live one instead. This was the human's ship
      // (1), the AI's dead ship (accounted for via shipsWithZeroHP, no
      // move needed) and the AI's live ship (7) — every active ship this
      // round, so a successful move here also completes the round, which
      // is the clearest possible proof the deadlock is gone: before this
      // fix, this call would silently do nothing and the round (and the
      // whole match) would never progress past this point.
      const hash = await singlePlayerMatchOther.write.takeAITurn([gameId]);
      const events = await getAITurnTakenEvents(
        publicClient,
        singlePlayerMatch.abi,
        hash,
      );
      expect(events.length).to.equal(1);
      const ev = events.find((e: any) => e.args.shipId === liveAiShipId);
      expect(ev).to.not.be.undefined;

      const gameData = (await game.read.getGame([gameId])) as GameDataView;
      expect(gameData.turnState.currentRound).to.equal(preRound + 1n);
    });

    it("surrenders (human wins) when every one of the AI's ships is at 0 HP", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        human,
        owner,
      } = await loadFixture(deploySinglePlayerFixture);

      const mapId = await setupBasicAIEncounter(maps, aiEncounters);

      const gameId = await startMatch(
        nodeMap,
        ships,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
        mapId,
      );

      const aiShipId = AI_SHIP_ID_OFFSET + 1n;

      // Human passes in place, handing the turn to the AI
      await humanGame.write.moveShip(
        [gameId, 1n, 0, 0, ActionType.Pass, 0n],
        { account: human.account },
      );

      // The AI's only ship is at 0 HP -- it has nothing left it can
      // meaningfully do (its only legal action, Retreat, isn't a decision
      // worth making — see takeAITurn's comment), so it should surrender
      // rather than deadlock the match.
      await game.write.debugSetHullPointsToZero([gameId, aiShipId], {
        account: owner.account,
      });

      await singlePlayerMatchOther.write.takeAITurn([gameId]);

      const gameData = (await game.read.getGame([gameId])) as GameDataView;
      expect(gameData.metadata.ended).to.equal(true);
      expect(gameData.metadata.winner.toLowerCase()).to.equal(
        human.account.address.toLowerCase(),
      );
    });
  });

  describe("Node completion", function () {
    it("records the node as completed for the human when they win, and unlocks a node that requires it", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        singlePlayerMatchOther,
        human,
        owner,
      } = await loadFixture(deploySinglePlayerFixture);

      const mapId = await setupBasicAIEncounter(maps, aiEncounters);
      const nodeId = await createCampaignNode(nodeMap, mapId);
      const nextMapId = await setupBasicAIEncounter(maps, aiEncounters);
      const nextNodeId = await createCampaignNode(nodeMap, nextMapId, [
        nodeId,
      ]);

      expect(
        await nodeMap.read.isNodeUnlocked([human.account.address, nextNodeId]),
      ).to.equal(false);

      await purchaseAndConstructHumanShip(ships, randomManager, humanShips, human);
      await humanSinglePlayerMatch.write.startNodeMatch([
        nodeId,
        [1n],
        [{ row: 0, col: 0 }],
      ]);
      const gameId = NODE_MATCH_ID_OFFSET + 1n;

      await humanGame.write.moveShip(
        [gameId, 1n, 0, 0, ActionType.Pass, 0n],
        { account: human.account },
      );
      await game.write.debugSetHullPointsToZero(
        [gameId, AI_SHIP_ID_OFFSET + 1n],
        { account: owner.account },
      );
      await singlePlayerMatchOther.write.takeAITurn([gameId]);

      expect(
        await nodeMap.read.isNodeCompleted([human.account.address, nodeId]),
      ).to.equal(true);
      expect(
        await nodeMap.read.isNodeUnlocked([human.account.address, nextNodeId]),
      ).to.equal(true);
    });

    it("does not record completion when the AI wins", async function () {
      const {
        ships,
        game,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanGame,
        humanSinglePlayerMatch,
        human,
      } = await loadFixture(deploySinglePlayerFixture);

      const mapId = await setupBasicAIEncounter(maps, aiEncounters);
      const nodeId = await createCampaignNode(nodeMap, mapId);

      await purchaseAndConstructHumanShip(ships, randomManager, humanShips, human);
      await humanSinglePlayerMatch.write.startNodeMatch([
        nodeId,
        [1n],
        [{ row: 0, col: 0 }],
      ]);
      const gameId = NODE_MATCH_ID_OFFSET + 1n;

      // Force the AI to win directly via forceEndSession's sibling path:
      // simplest is debugDestroyShip on the human's only ship, which
      // triggers _checkGameEndCondition -> _endGame with the AI as winner.
      await game.write.debugDestroyShip([gameId, 1n]);

      const gameData = (await game.read.getGame([gameId])) as GameDataView;
      expect(gameData.metadata.ended).to.equal(true);
      expect(gameData.metadata.winner.toLowerCase()).to.not.equal(
        human.account.address.toLowerCase(),
      );
      expect(
        await nodeMap.read.isNodeCompleted([human.account.address, nodeId]),
      ).to.equal(false);
    });
  });

  describe("Kill rewards", function () {
    // setTimestampDestroyed is exactly what Game.sol calls mid-combat to
    // attribute a kill — it's also directly callable by ShipsRouter's
    // owner (that's how Game.sol itself is authorized to call it:
    // `msg.sender == owner() || msg.sender == gameAddress`). Using it
    // directly here (via the router, since AI ship ids only resolve
    // through it) tests DestroyRewardLib's UTC-vs-DEC branching without
    // needing to reproduce Game.sol's deterministic-but-opaque damage math
    // just to force a real one-shot kill in combat.
    async function setUpOneAIShip(fixture: any) {
      const {
        ships,
        maps,
        nodeMap,
        aiEncounters,
        randomManager,
        humanShips,
        humanSinglePlayerMatch,
        human,
      } = fixture;

      const mapId = await setupBasicAIEncounter(maps, aiEncounters);
      const nodeId = await createCampaignNode(nodeMap, mapId);

      await purchaseAndConstructHumanShip(ships, randomManager, humanShips, human);
      await humanSinglePlayerMatch.write.startNodeMatch([
        nodeId,
        [1n],
        [{ row: 0, col: 0 }],
      ]);

      return {
        gameId: NODE_MATCH_ID_OFFSET + 1n,
        humanShipId: 1n,
        aiShipId: AI_SHIP_ID_OFFSET + 1n,
      };
    }

    it("pays the human DEC (not UTC) for destroying an AI-owned ship", async function () {
      const fixture = await loadFixture(deploySinglePlayerFixture);
      const { ships, shipsRouter, universalCredits, droneEnergyCores, owner, human } =
        fixture;
      const { humanShipId, aiShipId } = await setUpOneAIShip(fixture);

      const [utcBefore, decBefore, recycleReward] = await Promise.all([
        universalCredits.read.balanceOf([human.account.address]),
        droneEnergyCores.read.balanceOf([human.account.address]),
        ships.read.recycleReward(),
      ]);

      await shipsRouter.write.setTimestampDestroyed([aiShipId, humanShipId], {
        account: owner.account,
      });

      const [utcAfter, decAfter] = await Promise.all([
        universalCredits.read.balanceOf([human.account.address]),
        droneEnergyCores.read.balanceOf([human.account.address]),
      ]);

      expect(decAfter - decBefore).to.equal(recycleReward >> 2n);
      expect(utcAfter).to.equal(utcBefore);
    });

    it("pays UTC to SinglePlayerMatch (not the human) when the AI destroys a human ship, and the owner can withdraw it", async function () {
      const fixture = await loadFixture(deploySinglePlayerFixture);
      const {
        ships,
        shipsRouter,
        universalCredits,
        droneEnergyCores,
        singlePlayerMatch,
        owner,
        human,
      } = fixture;
      const { humanShipId, aiShipId } = await setUpOneAIShip(fixture);

      await shipsRouter.write.setTimestampDestroyed([humanShipId, aiShipId], {
        account: owner.account,
      });

      const recycleReward = await ships.read.recycleReward();
      const contractUtcBalance = await universalCredits.read.balanceOf([
        singlePlayerMatch.address,
      ]);
      expect(contractUtcBalance).to.equal(recycleReward >> 2n);

      // Human's own DEC balance is untouched by this — DEC only pays out
      // the other direction (a human destroying an AI ship).
      expect(
        await droneEnergyCores.read.balanceOf([human.account.address]),
      ).to.equal(0n);

      await expect(
        singlePlayerMatch.write.withdrawUC({ account: human.account }),
      ).to.be.rejectedWith("OwnableUnauthorizedAccount");

      const ownerUtcBefore = await universalCredits.read.balanceOf([
        owner.account.address,
      ]);
      await singlePlayerMatch.write.withdrawUC({ account: owner.account });

      expect(
        await universalCredits.read.balanceOf([singlePlayerMatch.address]),
      ).to.equal(0n);
      expect(
        await universalCredits.read.balanceOf([owner.account.address]),
      ).to.equal(ownerUtcBefore + contractUtcBalance);
    });
  });
});
