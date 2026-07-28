import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";

// Standalone tests — NodeMap only depends on Maps (read-only, via
// mapExists), so this deploys just those two contracts directly rather than
// the full DeployAndConfig module, matching test/AIEncounters.test.ts's
// convention.
describe("NodeMap", function () {
  async function deployFixture() {
    const [owner, editor, completer, other, player1, player2] =
      await hre.viem.getWalletClients();

    const maps = await hre.viem.deployContract("Maps", []);
    const nodeMap = await hre.viem.deployContract("NodeMap", [maps.address]);

    const editorNodeMap = await hre.viem.getContractAt(
      "NodeMap",
      nodeMap.address,
      { client: { wallet: editor } },
    );
    const otherNodeMap = await hre.viem.getContractAt(
      "NodeMap",
      nodeMap.address,
      { client: { wallet: other } },
    );
    const completerNodeMap = await hre.viem.getContractAt(
      "NodeMap",
      nodeMap.address,
      { client: { wallet: completer } },
    );

    // Two real preset maps for node tests to reference.
    await maps.write.createPresetMap([[]]);
    await maps.write.createPresetMap([[]]);

    return {
      maps,
      nodeMap,
      editorNodeMap,
      otherNodeMap,
      completerNodeMap,
      owner,
      editor,
      completer,
      other,
      player1,
      player2,
    };
  }

  const defaultNodeArgs = (mapId: bigint, prerequisites: bigint[] = []) =>
    [mapId, prerequisites, 2000n, 600n, 20n, true] as const;

  describe("Node editor role", function () {
    it("owner can grant and revoke node-editor rights", async function () {
      const { nodeMap, editor } = await loadFixture(deployFixture);

      expect(await nodeMap.read.isNodeEditor([editor.account.address])).to.be
        .false;

      await nodeMap.write.setNodeEditor([editor.account.address, true]);
      expect(await nodeMap.read.isNodeEditor([editor.account.address])).to.be
        .true;

      await nodeMap.write.setNodeEditor([editor.account.address, false]);
      expect(await nodeMap.read.isNodeEditor([editor.account.address])).to.be
        .false;
    });

    it("reverts createNode from a non-owner, non-editor address", async function () {
      const { otherNodeMap } = await loadFixture(deployFixture);

      await expect(
        otherNodeMap.write.createNode(defaultNodeArgs(1n)),
      ).to.be.rejectedWith("NotNodeEditor");
    });

    it("allows a granted editor to create nodes", async function () {
      const { nodeMap, editorNodeMap, editor } = await loadFixture(
        deployFixture,
      );
      await nodeMap.write.setNodeEditor([editor.account.address, true]);

      await editorNodeMap.write.createNode(defaultNodeArgs(1n));
      expect(await nodeMap.read.nodeCount()).to.equal(1n);
    });
  });

  describe("createNode", function () {
    it("reverts when the map does not exist", async function () {
      const { nodeMap } = await loadFixture(deployFixture);

      await expect(
        nodeMap.write.createNode(defaultNodeArgs(999n)),
      ).to.be.rejectedWith("MapNotFound");
    });

    it("reverts when a prerequisite does not exist", async function () {
      const { nodeMap } = await loadFixture(deployFixture);

      await expect(
        nodeMap.write.createNode(defaultNodeArgs(1n, [999n])),
      ).to.be.rejectedWith("PrerequisiteNotFound");
    });

    it("reverts a self-referential prerequisite", async function () {
      const { nodeMap } = await loadFixture(deployFixture);

      // The next node created will be id 1 — pass that as its own
      // prerequisite.
      await expect(
        nodeMap.write.createNode(defaultNodeArgs(1n, [1n])),
      ).to.be.rejectedWith("SelfPrerequisite");
    });

    it("stores the node's fields and emits NodeCreated", async function () {
      const { nodeMap } = await loadFixture(deployFixture);

      await nodeMap.write.createNode([1n, [], 1500n, 300n, 10n, false]);
      const node = await nodeMap.read.getNode([1n]);

      expect(node.id).to.equal(1n);
      expect(node.mapId).to.equal(1n);
      expect(node.costLimit).to.equal(1500n);
      expect(node.turnTime).to.equal(300n);
      expect(node.maxScore).to.equal(10n);
      expect(node.creatorGoesFirst).to.equal(false);
      expect(node.exists).to.equal(true);
    });
  });

  describe("updateNode / addPrerequisite / removePrerequisite", function () {
    it("updates an existing node's fields", async function () {
      const { nodeMap } = await loadFixture(deployFixture);
      await nodeMap.write.createNode(defaultNodeArgs(1n));

      await nodeMap.write.updateNode([1n, 2n, [], 999n, 111n, 5n, false]);
      const node = await nodeMap.read.getNode([1n]);
      expect(node.mapId).to.equal(2n);
      expect(node.costLimit).to.equal(999n);
      expect(node.turnTime).to.equal(111n);
      expect(node.maxScore).to.equal(5n);
      expect(node.creatorGoesFirst).to.equal(false);
    });

    it("reverts updateNode for a node that doesn't exist", async function () {
      const { nodeMap } = await loadFixture(deployFixture);

      await expect(
        nodeMap.write.updateNode([999n, 1n, [], 1n, 1n, 1n, true]),
      ).to.be.rejectedWith("NodeNotFound");
    });

    it("adds and removes a prerequisite", async function () {
      const { nodeMap, player1 } = await loadFixture(deployFixture);
      await nodeMap.write.createNode(defaultNodeArgs(1n)); // node 1
      await nodeMap.write.createNode(defaultNodeArgs(2n)); // node 2

      expect(
        await nodeMap.read.isNodeUnlocked([player1.account.address, 2n]),
      ).to.equal(true);

      await nodeMap.write.addPrerequisite([2n, 1n]);
      expect(await nodeMap.read.getPrerequisites([2n])).to.deep.equal([1n]);
      expect(
        await nodeMap.read.isNodeUnlocked([player1.account.address, 2n]),
      ).to.equal(false);

      await nodeMap.write.removePrerequisite([2n, 1n]);
      expect(await nodeMap.read.getPrerequisites([2n])).to.deep.equal([]);
      expect(
        await nodeMap.read.isNodeUnlocked([player1.account.address, 2n]),
      ).to.equal(true);
    });

    it("reverts removePrerequisite when the prerequisite isn't on the node", async function () {
      const { nodeMap } = await loadFixture(deployFixture);
      await nodeMap.write.createNode(defaultNodeArgs(1n));
      await nodeMap.write.createNode(defaultNodeArgs(2n));

      await expect(
        nodeMap.write.removePrerequisite([2n, 1n]),
      ).to.be.rejectedWith("PrerequisiteNotInNode");
    });
  });

  describe("isNodeUnlocked (ANY-of semantics)", function () {
    it("a node with no prerequisites is always unlocked", async function () {
      const { nodeMap, player1 } = await loadFixture(deployFixture);
      await nodeMap.write.createNode(defaultNodeArgs(1n));

      expect(
        await nodeMap.read.isNodeUnlocked([player1.account.address, 1n]),
      ).to.equal(true);
    });

    it("reverts for a node that doesn't exist", async function () {
      const { nodeMap, player1 } = await loadFixture(deployFixture);

      await expect(
        nodeMap.read.isNodeUnlocked([player1.account.address, 999n]),
      ).to.be.rejectedWith("NodeNotFound");
    });

    it("unlocks as soon as ANY one of several prerequisites is completed, not all", async function () {
      const { nodeMap, completerNodeMap, completer, player1 } =
        await loadFixture(deployFixture);
      await nodeMap.write.setIsAllowedToCompleteNodes([
        completer.account.address,
        true,
      ]);

      await nodeMap.write.createNode(defaultNodeArgs(1n)); // node 1 (branch A)
      await nodeMap.write.createNode(defaultNodeArgs(2n)); // node 2 (branch B)
      await nodeMap.write.createNode(defaultNodeArgs(1n, [1n, 2n])); // node 3 requires either

      expect(
        await nodeMap.read.isNodeUnlocked([player1.account.address, 3n]),
      ).to.equal(false);

      // Complete only branch B (node 2) — should be enough (ANY-of, not
      // ALL-of), demonstrating a shortcut converging back into node 3.
      await completerNodeMap.write.recordCompletion([
        player1.account.address,
        2n,
      ]);

      expect(
        await nodeMap.read.isNodeUnlocked([player1.account.address, 3n]),
      ).to.equal(true);
      // Branch A was never completed, confirming this isn't an ALL-of check.
      expect(
        await nodeMap.read.isNodeCompleted([player1.account.address, 1n]),
      ).to.equal(false);
    });
  });

  describe("recordCompletion", function () {
    it("reverts from an address not authorized to complete nodes", async function () {
      const { nodeMap, otherNodeMap, player1 } = await loadFixture(
        deployFixture,
      );
      await nodeMap.write.createNode(defaultNodeArgs(1n));

      await expect(
        otherNodeMap.write.recordCompletion([player1.account.address, 1n]),
      ).to.be.rejectedWith("NotAllowedToCompleteNodes");
    });

    it("reverts for a node that doesn't exist even from an authorized completer", async function () {
      const { nodeMap, completerNodeMap, completer, player1 } =
        await loadFixture(deployFixture);
      await nodeMap.write.setIsAllowedToCompleteNodes([
        completer.account.address,
        true,
      ]);

      await expect(
        completerNodeMap.write.recordCompletion([
          player1.account.address,
          999n,
        ]),
      ).to.be.rejectedWith("NodeNotFound");
    });

    it("is idempotent — completing the same node twice doesn't revert and stays completed", async function () {
      const { nodeMap, completerNodeMap, completer, player1 } =
        await loadFixture(deployFixture);
      await nodeMap.write.setIsAllowedToCompleteNodes([
        completer.account.address,
        true,
      ]);
      await nodeMap.write.createNode(defaultNodeArgs(1n));

      await completerNodeMap.write.recordCompletion([
        player1.account.address,
        1n,
      ]);
      await completerNodeMap.write.recordCompletion([
        player1.account.address,
        1n,
      ]);

      expect(
        await nodeMap.read.isNodeCompleted([player1.account.address, 1n]),
      ).to.equal(true);
    });

    it("tracks completion per-player independently", async function () {
      const { nodeMap, completerNodeMap, completer, player1, player2 } =
        await loadFixture(deployFixture);
      await nodeMap.write.setIsAllowedToCompleteNodes([
        completer.account.address,
        true,
      ]);
      await nodeMap.write.createNode(defaultNodeArgs(1n));

      await completerNodeMap.write.recordCompletion([
        player1.account.address,
        1n,
      ]);

      expect(
        await nodeMap.read.isNodeCompleted([player1.account.address, 1n]),
      ).to.equal(true);
      expect(
        await nodeMap.read.isNodeCompleted([player2.account.address, 1n]),
      ).to.equal(false);
    });
  });

  describe("View helpers", function () {
    it("getAllNodes returns every created node in order", async function () {
      const { nodeMap } = await loadFixture(deployFixture);
      await nodeMap.write.createNode(defaultNodeArgs(1n));
      await nodeMap.write.createNode(defaultNodeArgs(2n));

      const all = await nodeMap.read.getAllNodes();
      expect(all.length).to.equal(2);
      expect(all[0].id).to.equal(1n);
      expect(all[1].id).to.equal(2n);
    });

    it("getNode reverts for a node that doesn't exist", async function () {
      const { nodeMap } = await loadFixture(deployFixture);

      await expect(nodeMap.read.getNode([999n])).to.be.rejectedWith(
        "NodeNotFound",
      );
    });
  });
});
