import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import { getAddress } from "viem";
import hre from "hardhat";
import { MapMode } from "./types";

// Standalone tests — ShatteredHiveMedal only depends on NodeMap (read-only,
// via isNodeCompleted), so this deploys just those two contracts directly
// rather than the full DeployAndConfig module, matching test/NodeMap.test.ts's
// convention.
describe("ShatteredHiveMedal", function () {
  async function deployFixture() {
    const [owner, completer, player1, player2] =
      await hre.viem.getWalletClients();

    const maps = await hre.viem.deployContract("Maps", []);
    const nodeMap = await hre.viem.deployContract("NodeMap", [maps.address]);

    await nodeMap.write.createCampaign();
    await maps.write.createPresetMap([[], MapMode.Both]);

    await nodeMap.write.createNode([1n, 1n, [], 2000n, 600n, 20n, true]);
    const finalNodeId = 1n;

    await nodeMap.write.setIsAllowedToCompleteNodes([
      completer.account.address,
      true,
    ]);
    const completerNodeMap = await hre.viem.getContractAt(
      "NodeMap",
      nodeMap.address,
      { client: { wallet: completer } },
    );

    const medal = await hre.viem.deployContract("ShatteredHiveMedal", [
      nodeMap.address,
      finalNodeId,
    ]);

    const player1Medal = await hre.viem.getContractAt(
      "ShatteredHiveMedal",
      medal.address,
      { client: { wallet: player1 } },
    );
    const player2Medal = await hre.viem.getContractAt(
      "ShatteredHiveMedal",
      medal.address,
      { client: { wallet: player2 } },
    );

    return {
      maps,
      nodeMap,
      completerNodeMap,
      medal,
      player1Medal,
      player2Medal,
      finalNodeId,
      owner,
      completer,
      player1,
      player2,
    };
  }

  describe("claimMedal", function () {
    it("reverts CampaignNotCompleted before the final node is completed", async function () {
      const { player1Medal } = await loadFixture(deployFixture);

      await expect(player1Medal.write.claimMedal()).to.be.rejectedWith(
        "CampaignNotCompleted",
      );
    });

    it("mints exactly one medal once the final node is completed", async function () {
      const { completerNodeMap, medal, player1Medal, player1, finalNodeId } =
        await loadFixture(deployFixture);

      await completerNodeMap.write.recordCompletion([
        player1.account.address,
        finalNodeId,
      ]);

      await player1Medal.write.claimMedal();

      expect(await medal.read.balanceOf([player1.account.address])).to.equal(
        1n,
      );
      expect(await medal.read.ownerOf([1n])).to.equal(
        getAddress(player1.account.address),
      );
    });

    it("reverts AlreadyClaimed on a second claim", async function () {
      const { completerNodeMap, player1Medal, player1, finalNodeId } =
        await loadFixture(deployFixture);

      await completerNodeMap.write.recordCompletion([
        player1.account.address,
        finalNodeId,
      ]);
      await player1Medal.write.claimMedal();

      await expect(player1Medal.write.claimMedal()).to.be.rejectedWith(
        "AlreadyClaimed",
      );
    });

    it("completing a different node does not satisfy the gate", async function () {
      const { completerNodeMap, player1Medal, player1 } =
        await loadFixture(deployFixture);

      // Node 1 is the configured final node; there is no node 2 here, so
      // this simulates completing some other, non-final node.
      await expect(
        completerNodeMap.write.recordCompletion([
          player1.account.address,
          2n,
        ]),
      ).to.be.rejectedWith("NodeNotFound");

      await expect(player1Medal.write.claimMedal()).to.be.rejectedWith(
        "CampaignNotCompleted",
      );
    });
  });

  describe("ownerMint", function () {
    it("allows the owner to mint directly, bypassing the completion check", async function () {
      const { medal, player2 } = await loadFixture(deployFixture);

      await medal.write.ownerMint([player2.account.address]);

      expect(await medal.read.balanceOf([player2.account.address])).to.equal(
        1n,
      );
    });

    it("reverts AlreadyClaimed if the recipient already holds a medal", async function () {
      const { medal, player2 } = await loadFixture(deployFixture);

      await medal.write.ownerMint([player2.account.address]);

      await expect(
        medal.write.ownerMint([player2.account.address]),
      ).to.be.rejectedWith("AlreadyClaimed");
    });

    it("reverts for non-owner callers", async function () {
      const { player1Medal, player2 } = await loadFixture(deployFixture);

      await expect(
        player1Medal.write.ownerMint([player2.account.address]),
      ).to.be.rejectedWith("OwnableUnauthorizedAccount");
    });
  });

  describe("Soulbound", function () {
    it("reverts on transferFrom", async function () {
      const { medal, player1Medal, player1, player2 } =
        await loadFixture(deployFixture);

      await medal.write.ownerMint([player1.account.address]);

      await expect(
        player1Medal.write.transferFrom([
          player1.account.address,
          player2.account.address,
          1n,
        ]),
      ).to.be.rejectedWith("Soulbound");
    });
  });

  describe("Owner configuration", function () {
    it("reverts setFinalNodeId/setNodeMapAddress for non-owner callers", async function () {
      const { player1Medal } = await loadFixture(deployFixture);

      await expect(
        player1Medal.write.setFinalNodeId([2n]),
      ).to.be.rejectedWith("OwnableUnauthorizedAccount");

      await expect(
        player1Medal.write.setNodeMapAddress([
          "0x0000000000000000000000000000000000000001",
        ]),
      ).to.be.rejectedWith("OwnableUnauthorizedAccount");
    });

    it("allows the owner to correct the final node id", async function () {
      const { nodeMap, medal, completerNodeMap, player1Medal, player1 } =
        await loadFixture(deployFixture);

      await nodeMap.write.createNode([
        1n,
        1n,
        [],
        2000n,
        600n,
        20n,
        true,
      ]);
      const newFinalNodeId = 2n;

      await medal.write.setFinalNodeId([newFinalNodeId]);

      await completerNodeMap.write.recordCompletion([
        player1.account.address,
        newFinalNodeId,
      ]);

      await player1Medal.write.claimMedal();

      expect(await medal.read.balanceOf([player1.account.address])).to.equal(
        1n,
      );
    });
  });
});
