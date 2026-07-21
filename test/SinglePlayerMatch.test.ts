import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import { parseEther } from "viem";
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
      singlePlayerMatch: deployed.singlePlayerMatch,
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
      0n,
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
      singlePlayerMatch,
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

    await createReservedLobby(
      ships,
      lobbies,
      humanLobbies,
      humanUniversalCredits,
      shipPurchaser,
      universalCredits,
      singlePlayerMatch,
      human,
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

    // Anyone can trigger the AI's turn
    await singlePlayerMatchOther.write.takeAITurn([gameId]);

    // The AI ship should not have moved (Case 1: enemy already adjacent) and
    // should have fired on the human's ship
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

    gameData = (await game.read.getGame([gameId])) as GameDataView;
    expect(gameData.turnState.currentTurn.toLowerCase()).to.equal(
      human.account.address.toLowerCase(),
    );
  });

  it("reverts takeAITurn when it isn't the AI's turn", async function () {
    const {
      ships,
      lobbies,
      singlePlayerMatch,
      universalCredits,
      shipPurchaser,
      randomManager,
      humanLobbies,
      humanShips,
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
});
