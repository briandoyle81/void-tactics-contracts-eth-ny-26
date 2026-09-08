import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import { parseEther, zeroAddress } from "viem";
import { ShipTuple, tupleToShip } from "./types";
import DeployModule from "../ignition/modules/DeployAndConfig";

// Same starting-position convention as test/Game.test.ts's own helper.
function generateStartingPositions(shipIds: bigint[], isCreator: boolean) {
  return shipIds.map((_, i) =>
    isCreator
      ? { row: i % 11, col: i % 4 }
      : { row: Math.max(0, 10 - (i % 11)), col: 13 + (i % 4) },
  );
}

// Win-effect dispatch on PvP wins (see IWinEffect.sol) — PvPMatch.onGameEnded
// now fires the same pluggable resolvers RoguelikeMatch does. Own fixture
// rather than reusing Game.test.ts's giant shared one, to avoid touching a
// fixture hundreds of other tests depend on.
describe("PvPMatch win effects", function () {
  async function deployFixture() {
    const [owner, creator, joiner] = await hre.viem.getWalletClients();
    const deployed = await hre.ignition.deploy(DeployModule);

    const creatorLobbies = await hre.viem.getContractAt(
      "Lobbies",
      deployed.lobbies.address,
      { client: { wallet: creator } },
    );
    const joinerLobbies = await hre.viem.getContractAt(
      "Lobbies",
      deployed.lobbies.address,
      { client: { wallet: joiner } },
    );
    const creatorPvpMatch = await hre.viem.getContractAt(
      "PvPMatch",
      deployed.pvpMatch.address,
      { client: { wallet: creator } },
    );

    return {
      owner,
      creator,
      joiner,
      deployed,
      creatorLobbies,
      joinerLobbies,
      creatorPvpMatch,
    };
  }

  async function purchaseConstructAndFightToFlee(
    fx: Awaited<ReturnType<typeof deployFixture>>,
  ) {
    const { deployed, creator, joiner, creatorLobbies, joinerLobbies, creatorPvpMatch } = fx;
    const { ships, randomManager } = deployed;

    await ships.write.purchaseWithFlow(
      [creator.account.address, 0n, joiner.account.address, 1],
      { value: parseEther("4.99") },
    );
    await ships.write.purchaseWithFlow(
      [joiner.account.address, 0n, creator.account.address, 1],
      { value: parseEther("4.99") },
    );
    for (let i = 1; i <= 10; i++) {
      const shipTuple = (await ships.read.ships([BigInt(i)])) as ShipTuple;
      const ship = tupleToShip(shipTuple);
      await randomManager.write.revealRandomness([ship.traits.serialNumber]);
    }
    await ships.write.constructAllMyShips({ account: creator.account });
    await ships.write.constructAllMyShips({ account: joiner.account });

    await creatorLobbies.write.createLobby([
      1000n,
      300n,
      true,
      0n,
      100n,
      zeroAddress,
    ]);
    const lobbyId = 1n;
    await joinerLobbies.write.joinLobby([lobbyId]);
    await creatorLobbies.write.createFleet([
      lobbyId,
      [1n, 2n],
      generateStartingPositions([1n, 2n], true),
    ]);
    await joinerLobbies.write.createFleet([
      lobbyId,
      [6n, 7n],
      generateStartingPositions([6n, 7n], false),
    ]);

    const gameId = 1n;
    // Creator flees — joiner wins immediately, no need to play out combat.
    const fleeHash = await creatorPvpMatch.write.flee([gameId]);
    return { gameId, fleeHash };
  }

  it("has an empty win-effect list by default and setWinEffects is owner-only", async function () {
    const fx = await loadFixture(deployFixture);
    const { deployed, creatorPvpMatch } = fx;

    expect(await deployed.pvpMatch.read.getWinEffects()).to.deep.equal([]);

    await expect(
      creatorPvpMatch.write.setWinEffects([[deployed.decBonusWinEffect.address]]),
    ).to.be.rejected;
  });

  it("mints the configured DEC bonus to the winner on a PvP win", async function () {
    const fx = await loadFixture(deployFixture);
    const { deployed, joiner } = fx;

    await deployed.pvpMatch.write.setWinEffects([
      [deployed.decBonusWinEffect.address],
    ]);

    const decBefore = await deployed.droneEnergyCores.read.balanceOf([
      joiner.account.address,
    ]);
    await purchaseConstructAndFightToFlee(fx);
    const decAfter = await deployed.droneEnergyCores.read.balanceOf([
      joiner.account.address,
    ]);

    const bonusAmount = await deployed.decBonusWinEffect.read.bonusAmount();
    expect(decAfter - decBefore).to.equal(bonusAmount);
  });

  it("still records the result and completes game-end when a configured win effect reverts", async function () {
    const fx = await loadFixture(deployFixture);
    const { deployed, joiner } = fx;

    const brokenEffect = await hre.viem.deployContract(
      "MockAlwaysRevertsWinEffect",
      [],
    );
    await deployed.pvpMatch.write.setWinEffects([
      [deployed.decBonusWinEffect.address, brokenEffect.address],
    ]);

    const decBefore = await deployed.droneEnergyCores.read.balanceOf([
      joiner.account.address,
    ]);
    const { gameId, fleeHash } = await purchaseConstructAndFightToFlee(fx);
    const publicClient = await hre.viem.getPublicClient();
    const receipt = await publicClient.waitForTransactionReceipt({
      hash: fleeHash,
    });

    // Game-end wasn't bricked: result recorded, winner set.
    expect(await deployed.gameResults.read.isGameResultRecorded([gameId])).to
      .be.true;
    const gameAfter = await deployed.game.read.getGame([gameId]);
    expect(gameAfter.metadata.winner.toLowerCase()).to.equal(
      joiner.account.address.toLowerCase(),
    );

    // The working effect before the broken one still fired.
    const decAfter = await deployed.droneEnergyCores.read.balanceOf([
      joiner.account.address,
    ]);
    const bonusAmount = await deployed.decBonusWinEffect.read.bonusAmount();
    expect(decAfter - decBefore).to.equal(bonusAmount);

    const events = await deployed.pvpMatch.getEvents.WinEffectFailed(
      undefined,
      { fromBlock: receipt.blockNumber, toBlock: receipt.blockNumber },
    );
    expect(events).to.have.length(1);
    expect(events[0].args.resolver?.toLowerCase()).to.equal(
      brokenEffect.address.toLowerCase(),
    );
  });
});
