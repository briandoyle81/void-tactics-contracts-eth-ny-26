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

describe("AIController", function () {
  async function deployAIFixture() {
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
    const aiControllerOther = await hre.viem.getContractAt(
      "AIController",
      deployed.aiController.address,
      { client: { wallet: other } },
    );

    return {
      ships: deployed.ships,
      lobbies: deployed.lobbies,
      game: deployed.game,
      gameResults: deployed.gameResults,
      aiController: deployed.aiController,
      randomManager: deployed.randomManager,
      humanLobbies,
      humanShips,
      humanGame,
      aiControllerOther,
      owner,
      human,
      other,
      publicClient,
    };
  }

  it("only the owner can start a single-player match", async function () {
    const { aiController, human, other } = await loadFixture(deployAIFixture);

    await expect(
      aiController.write.startSinglePlayerMatch(
        [human.account.address, true, 1000n, 86400n, 0n, 20n],
        { account: other.account },
      ),
    ).to.be.rejectedWith("OwnableUnauthorizedAccount");
  });

  it("lets anyone build the AI's fleet once a lobby names it as a player", async function () {
    const { aiController, aiControllerOther, humanLobbies, owner, human } =
      await loadFixture(deployAIFixture);

    await aiController.write.startSinglePlayerMatch(
      [human.account.address, true, 1000n, 86400n, 0n, 20n],
      { account: owner.account },
    );

    const lobbyId = 1n;

    // setupAIFleet before the human creates their fleet still works (order
    // between the two sides' createFleet calls doesn't matter).
    await aiControllerOther.write.setupAIFleet([lobbyId]);

    const lobby = (await humanLobbies.read.getLobby([lobbyId])) as any;
    expect(lobby.players.joinerFleetId).to.not.equal(0n);
  });

  it("plays a single-player match end to end and tracks stats separately from PvP", async function () {
    const {
      ships,
      game,
      gameResults,
      aiController,
      randomManager,
      humanLobbies,
      humanShips,
      humanGame,
      aiControllerOther,
      owner,
      human,
    } = await loadFixture(deployAIFixture);

    // Human is creator, AI is joiner
    await aiController.write.startSinglePlayerMatch(
      [human.account.address, true, 1000n, 86400n, 0n, 20n],
      { account: owner.account },
    );

    const lobbyId = 1n;
    const gameId = lobbyId;

    // Human purchases and constructs a ship
    await ships.write.purchaseWithFlow(
      [human.account.address, 0n, human.account.address, 1],
      { value: parseEther("4.99") },
    );
    const shipTuple = (await ships.read.ships([1n])) as ShipTuple;
    const humanShip = tupleToShip(shipTuple);
    await randomManager.write.fulfillRandomRequest([
      humanShip.traits.serialNumber,
    ]);
    await humanShips.write.constructAllMyShips({ account: human.account });

    // Human creates their fleet first, making them go first
    await humanLobbies.write.createFleet(
      [lobbyId, [1n], [{ row: 0, col: 0 }]],
      { account: human.account },
    );

    // Anyone (not the human, not the owner) can trigger the AI to build its
    // fleet and start the game
    await aiControllerOther.write.setupAIFleet([lobbyId]);

    let gameData = (await game.read.getGame([gameId])) as GameDataView;
    expect(gameData.metadata.ended).to.equal(false);
    expect(gameData.turnState.currentTurn.toLowerCase()).to.equal(
      human.account.address.toLowerCase(),
    );

    // Human passes in place
    const humanPos = findShipPosition(gameData, 1n);
    await humanGame.write.moveShip(
      [gameId, 1n, humanPos.row, humanPos.col, ActionType.Pass, 0n],
      { account: human.account },
    );

    // The AI's turn: takeAITurn should move all of its unmoved ships in one
    // call without reverting
    gameData = (await game.read.getGame([gameId])) as GameDataView;
    expect(gameData.turnState.currentTurn.toLowerCase()).to.equal(
      aiController.address.toLowerCase(),
    );
    await aiControllerOther.write.takeAITurn([gameId]);

    gameData = (await game.read.getGame([gameId])) as GameDataView;
    expect(gameData.turnState.currentTurn.toLowerCase()).to.equal(
      human.account.address.toLowerCase(),
    );

    // End the match deterministically (human flees, so the AI wins) rather
    // than simulating combat to completion
    await humanGame.write.flee([gameId], { account: human.account });

    gameData = (await game.read.getGame([gameId])) as GameDataView;
    expect(gameData.metadata.ended).to.equal(true);
    expect(gameData.metadata.winner.toLowerCase()).to.equal(
      aiController.address.toLowerCase(),
    );

    // Result must be tracked separately from the PvP leaderboard
    const humanPvPStats = await gameResults.read.getPlayerStats([
      human.account.address,
    ]);
    expect(humanPvPStats.totalGames).to.equal(0n);

    const humanSPStats = await gameResults.read.getSinglePlayerStats([
      human.account.address,
    ]);
    expect(humanSPStats.totalGames).to.equal(1n);
    expect(humanSPStats.wins).to.equal(0n);
    expect(humanSPStats.losses).to.equal(1n);
  });

  it("reverts takeAITurn when it isn't the AI's turn", async function () {
    const {
      ships,
      randomManager,
      humanLobbies,
      humanShips,
      aiController,
      aiControllerOther,
      owner,
      human,
    } = await loadFixture(deployAIFixture);

    await aiController.write.startSinglePlayerMatch(
      [human.account.address, true, 1000n, 86400n, 0n, 20n],
      { account: owner.account },
    );

    const lobbyId = 1n;

    await ships.write.purchaseWithFlow(
      [human.account.address, 0n, human.account.address, 1],
      { value: parseEther("4.99") },
    );
    const shipTuple = (await ships.read.ships([1n])) as ShipTuple;
    const humanShip = tupleToShip(shipTuple);
    await randomManager.write.fulfillRandomRequest([
      humanShip.traits.serialNumber,
    ]);
    await humanShips.write.constructAllMyShips({ account: human.account });

    await humanLobbies.write.createFleet(
      [lobbyId, [1n], [{ row: 0, col: 0 }]],
      { account: human.account },
    );
    await aiControllerOther.write.setupAIFleet([lobbyId]);

    // It's the human's turn right after the game starts (human created their
    // fleet first) — takeAITurn must revert rather than act out of turn
    await expect(
      aiControllerOther.write.takeAITurn([lobbyId]),
    ).to.be.rejectedWith("NotAITurn");
  });
});
