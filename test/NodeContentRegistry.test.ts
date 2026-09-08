import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import { getAddress } from "viem";
import hre from "hardhat";

describe("NodeContentRegistry", function () {
  async function deployFixture() {
    const [owner, editor, other] = await hre.viem.getWalletClients();

    const registry = await hre.viem.deployContract("NodeContentRegistry", []);

    const editorRegistry = await hre.viem.getContractAt(
      "NodeContentRegistry",
      registry.address,
      { client: { wallet: editor } },
    );
    const otherRegistry = await hre.viem.getContractAt(
      "NodeContentRegistry",
      registry.address,
      { client: { wallet: other } },
    );

    return { registry, editorRegistry, otherRegistry, owner, editor, other };
  }

  describe("Node editor role", function () {
    it("owner can grant and revoke node-editor rights", async function () {
      const { registry, editor } = await loadFixture(deployFixture);

      expect(await registry.read.isNodeEditor([editor.account.address])).to
        .be.false;

      await registry.write.setNodeEditor([editor.account.address, true]);
      expect(await registry.read.isNodeEditor([editor.account.address])).to
        .be.true;

      await registry.write.setNodeEditor([editor.account.address, false]);
      expect(await registry.read.isNodeEditor([editor.account.address])).to
        .be.false;
    });

    it("reverts setNodeContentBatch from a non-owner, non-editor address", async function () {
      const { otherRegistry } = await loadFixture(deployFixture);

      await expect(
        otherRegistry.write.setNodeContentBatch([
          [false],
          [1n],
          ["Title"],
          ["Description"],
        ]),
      ).to.be.rejectedWith("NotNodeEditor");
    });

    it("reverts setNodeEditor from a non-owner address", async function () {
      const { otherRegistry, other } = await loadFixture(deployFixture);

      await expect(
        otherRegistry.write.setNodeEditor([other.account.address, true]),
      ).to.be.rejected;
    });
  });

  describe("setNodeContentBatch / getNodeContentBatch", function () {
    it("owner can publish and read back content for mixed campaign/roguelike node ids", async function () {
      const { registry } = await loadFixture(deployFixture);

      await registry.write.setNodeContentBatch([
        [false, false, true],
        [1n, 2n, 1n],
        ["Campaign Node 1", "Campaign Node 2", "Roguelike Node 1"],
        ["First campaign node.", "Second campaign node.", "First roguelike node."],
      ]);

      const [titles, descriptions] = await registry.read.getNodeContentBatch([
        [false, false, true],
        [1n, 2n, 1n],
      ]);
      expect(titles).to.deep.equal([
        "Campaign Node 1",
        "Campaign Node 2",
        "Roguelike Node 1",
      ]);
      expect(descriptions).to.deep.equal([
        "First campaign node.",
        "Second campaign node.",
        "First roguelike node.",
      ]);
    });

    it("a granted editor can publish content", async function () {
      const { registry, editorRegistry, editor } = await loadFixture(
        deployFixture,
      );
      await registry.write.setNodeEditor([editor.account.address, true]);

      await editorRegistry.write.setNodeContentBatch([
        [false],
        [1n],
        ["Editor Title"],
        ["Editor Description"],
      ]);

      const [title, description] = await registry.read.getNodeContent([
        false,
        1n,
      ]);
      expect(title).to.equal("Editor Title");
      expect(description).to.equal("Editor Description");
    });

    it("does not collide between campaign and roguelike node ids", async function () {
      const { registry } = await loadFixture(deployFixture);

      await registry.write.setNodeContentBatch([
        [false, true],
        [1n, 1n],
        ["Campaign Node 1", "Roguelike Node 1"],
        ["Campaign flavor.", "Roguelike flavor."],
      ]);

      const [campaignTitle] = await registry.read.getNodeContent([false, 1n]);
      const [roguelikeTitle] = await registry.read.getNodeContent([true, 1n]);
      expect(campaignTitle).to.equal("Campaign Node 1");
      expect(roguelikeTitle).to.equal("Roguelike Node 1");
    });

    it("overwrites an existing entry on republish", async function () {
      const { registry } = await loadFixture(deployFixture);

      await registry.write.setNodeContentBatch([
        [false],
        [1n],
        ["Original Title"],
        ["Original Description"],
      ]);
      await registry.write.setNodeContentBatch([
        [false],
        [1n],
        ["Updated Title"],
        ["Updated Description"],
      ]);

      const [title, description] = await registry.read.getNodeContent([
        false,
        1n,
      ]);
      expect(title).to.equal("Updated Title");
      expect(description).to.equal("Updated Description");
    });

    it("returns empty strings for a node with no published content", async function () {
      const { registry } = await loadFixture(deployFixture);

      const [title, description] = await registry.read.getNodeContent([
        false,
        999n,
      ]);
      expect(title).to.equal("");
      expect(description).to.equal("");
    });

    it("reverts on mismatched array lengths in setNodeContentBatch", async function () {
      const { registry } = await loadFixture(deployFixture);

      await expect(
        registry.write.setNodeContentBatch([
          [false, true],
          [1n],
          ["Title"],
          ["Description"],
        ]),
      ).to.be.rejectedWith("ArrayLengthMismatch");
    });

    it("reverts on mismatched array lengths in getNodeContentBatch", async function () {
      const { registry } = await loadFixture(deployFixture);

      await expect(
        registry.read.getNodeContentBatch([[false, true], [1n]]),
      ).to.be.rejectedWith("ArrayLengthMismatch");
    });

    it("emits NodeContentSet per published entry", async function () {
      const { registry } = await loadFixture(deployFixture);

      const hash = await registry.write.setNodeContentBatch([
        [false, true],
        [1n, 2n],
        ["Title A", "Title B"],
        ["Description A", "Description B"],
      ]);
      const publicClient = await hre.viem.getPublicClient();
      const receipt = await publicClient.waitForTransactionReceipt({ hash });
      const events = await registry.getEvents.NodeContentSet(undefined, {
        fromBlock: receipt.blockNumber,
        toBlock: receipt.blockNumber,
      });
      expect(events).to.have.length(2);
      expect(events[0].args.isRoguelike).to.equal(false);
      expect(events[0].args.nodeId).to.equal(1n);
      expect(events[0].args.title).to.equal("Title A");
      expect(events[1].args.isRoguelike).to.equal(true);
      expect(events[1].args.nodeId).to.equal(2n);
    });
  });

  describe("Gas sizing (informational — sizes the frontend publish batch chunk constant)", function () {
    it("reports gas for a batch of realistically-sized content entries", async function () {
      const { registry } = await loadFixture(deployFixture);

      // ~50-char title, ~450-char description — representative of real
      // (non-placeholder) node flavor text, unlike the short strings used
      // in the correctness tests above.
      const title = "The Shattered Perimeter — First Contact With The Hive";
      const description =
        "Sensor drones picked up the signature three cycles ago: a lattice " +
        "of Hive constructs spreading across the outer perimeter like frost " +
        "on a viewport. Command wants a picket line held here, at the edge " +
        "of the debris field, before the swarm can consolidate and push " +
        "inward toward the shipyards. Expect layered defenses and no " +
        "reinforcements once the engagement begins.";
      const entryCount = 20;

      const hash = await registry.write.setNodeContentBatch([
        Array(entryCount).fill(false),
        Array.from({ length: entryCount }, (_, i) => BigInt(i + 1)),
        Array(entryCount).fill(title),
        Array(entryCount).fill(description),
      ]);
      const publicClient = await hre.viem.getPublicClient();
      const receipt = await publicClient.waitForTransactionReceipt({ hash });

      const gasUsed = receipt.gasUsed;
      const perEntry = gasUsed / BigInt(entryCount);
      // eslint-disable-next-line no-console
      console.log(
        `      setNodeContentBatch(${entryCount} realistic entries): ` +
          `${gasUsed} gas total, ~${perEntry} gas/entry`,
      );

      // Sanity bound only — not a strict gas-golfing assertion, just a
      // guard against a future change accidentally blowing this up.
      expect(gasUsed < 30_000_000n).to.be.true;
    });
  });

  describe("Ownership", function () {
    it("owner is the deployer by default", async function () {
      const { registry, owner } = await loadFixture(deployFixture);
      expect(await registry.read.owner()).to.equal(
        getAddress(owner.account.address),
      );
    });
  });
});
