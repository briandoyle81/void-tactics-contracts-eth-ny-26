import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";

// Standalone tests — RandomManager has no constructor args and no
// dependencies, so this deploys just that contract directly.
describe("RandomManager", function () {
  async function deployFixture() {
    const randomManager = await hre.viem.deployContract("RandomManager", []);
    return { randomManager };
  }

  async function getResult(randomManager: any, id: bigint) {
    const request = await randomManager.read.requests([id]);
    // Request struct: (blockNumber, prevRandaoAtCommit, revealed, result)
    return { revealed: request[2] as boolean, result: request[3] as bigint };
  }

  it("fulfillRandomRequest reveals-and-locks on first call — no separate reveal transaction needed", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    await randomManager.write.requestRandomness(); // id 1
    await hre.network.provider.send("evm_mine");

    expect(await randomManager.read.canFulfill([1n])).to.equal(true);

    await randomManager.write.fulfillRandomRequest([1n]);
    const { revealed, result } = await getResult(randomManager, 1n);
    expect(revealed).to.equal(true);
    expect(result).to.not.equal(0n);
  });

  it("fulfillRandomRequest is idempotent — a second call returns the same already-locked result", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    await randomManager.write.requestRandomness(); // id 1
    await hre.network.provider.send("evm_mine");

    await randomManager.write.fulfillRandomRequest([1n]);
    const first = await getResult(randomManager, 1n);

    // Mine more blocks (new prevrandao epochs) — must NOT change the result.
    await hre.network.provider.send("evm_mine");
    await hre.network.provider.send("evm_mine");
    await randomManager.write.fulfillRandomRequest([1n]);
    const second = await getResult(randomManager, 1n);

    expect(second.result).to.equal(first.result);
  });

  // Note: can't reliably test "TooSoonToReveal because prevrandao hasn't
  // changed yet" here — Hardhat auto-mines one block per transaction, so
  // requestRandomness and a following fulfillRandomRequest always land in
  // different blocks, and this local network's simulated prevrandao
  // already differs across any two consecutive blocks (unlike real Base,
  // where it's stable for ~6). The revert path itself
  // (block.prevrandao == request.prevRandaoAtCommit) is a one-line
  // equality check exercised on real Base's actual behavior instead — see
  // docs/pre-audit.md's C-01/C-02 remediation addendum for the empirical
  // verification this logic is based on.

  it("fulfillRandomRequest reverts RequestNotFound for an invalid id", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    await expect(
      randomManager.write.fulfillRandomRequest([999n]),
    ).to.be.rejectedWith("RequestNotFound");
  });

  it("canFulfillBatch is false if any id in the batch isn't ready, true once all are", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    await randomManager.write.requestRandomness(); // id 1
    await randomManager.write.requestRandomness(); // id 2
    expect(await randomManager.read.canFulfillBatch([[1n, 2n]])).to.equal(
      false,
    );

    await hre.network.provider.send("evm_mine");
    expect(await randomManager.read.canFulfillBatch([[1n, 2n]])).to.equal(
      true,
    );
  });

  it("revealRandomness (optional pre-warming) locks in the same way fulfillRandomRequest would", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    await randomManager.write.requestRandomness(); // id 1
    await hre.network.provider.send("evm_mine");

    await randomManager.write.revealRandomness([1n]);
    const { revealed, result } = await getResult(randomManager, 1n);
    expect(revealed).to.equal(true);

    // fulfillRandomRequest afterward just returns the same locked value.
    await randomManager.write.fulfillRandomRequest([1n]);
    const after = await getResult(randomManager, 1n);
    expect(after.result).to.equal(result);
  });

  it("revealRandomness reverts RequestNotFound for an invalid id (regression: this check was dropped when reveal was folded into fulfillRandomRequest)", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    await expect(
      randomManager.write.revealRandomness([999n]),
    ).to.be.rejectedWith("RequestNotFound");
    await expect(
      randomManager.write.revealRandomness([0n]),
    ).to.be.rejectedWith("RequestNotFound");
  });

  it("reveals a batch in one call, matching individual reveals", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    const requestIds: bigint[] = [];
    for (let i = 0; i < 5; i++) {
      await randomManager.write.requestRandomness();
      requestIds.push(BigInt(i + 1));
    }

    // The last request's commit block is the current chain head — mine one
    // more block so its prevrandao has actually had a chance to change,
    // matching production where all N requests share one mint tx/block and
    // reveal only ever happens in a later one.
    await hre.network.provider.send("evm_mine");

    expect(await randomManager.read.canRevealBatch([requestIds])).to.equal(
      true,
    );

    await randomManager.write.revealRandomnessBatch([requestIds]);

    for (const id of requestIds) {
      const { revealed, result } = await getResult(randomManager, id);
      expect(revealed).to.equal(true);
      expect(result).to.not.equal(0n);
    }
  });

  it("canRevealBatch tolerates an already-revealed id (only checks readiness of the rest)", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    await randomManager.write.requestRandomness(); // id 1
    await randomManager.write.requestRandomness(); // id 2
    await hre.network.provider.send("evm_mine");
    await randomManager.write.revealRandomnessBatch([[1n]]); // reveal id 1 only

    // id 1 is already revealed (tolerated, not a failure condition); id 2
    // is still unrevealed but ready — the batch as a whole is callable.
    expect(await randomManager.read.canRevealBatch([[1n, 2n]])).to.equal(
      true,
    );
  });

  it("revealRandomnessBatch reverts the whole batch on a genuinely invalid id", async function () {
    const { randomManager } = await loadFixture(deployFixture);

    await randomManager.write.requestRandomness(); // id 1

    await expect(
      randomManager.write.revealRandomnessBatch([[1n, 999n]]),
    ).to.be.rejectedWith("RequestNotFound");
  });

  it("revealRandomnessBatch tolerates (skips) an id someone else already revealed, instead of reverting the whole batch", async function () {
    // Regression test for a griefing vector: revealRandomness/
    // revealRandomnessBatch are deliberately permissionless, so a hostile
    // third party can watch for a pending mint and front-run a single id
    // out of the victim's batch with their own revealRandomness call, for
    // the cost of gas only. If the batch reverted on any already-revealed
    // id, that would let an attacker force any player back to one-at-a-time
    // reveals for free. It must not revert — the already-done id should
    // just be skipped, with its already-locked-in result returned.
    const { randomManager } = await loadFixture(deployFixture);

    await randomManager.write.requestRandomness(); // id 1
    await randomManager.write.requestRandomness(); // id 2
    await hre.network.provider.send("evm_mine");

    // A hostile outside actor (not the "victim" submitting the batch)
    // reveals id 1 first, purely to try to break the victim's batch call.
    await randomManager.write.revealRandomness([1n]);
    const griefedResult = (await getResult(randomManager, 1n)).result;

    // The victim's batch call must not revert just because id 1 was
    // already revealed by someone else.
    await randomManager.write.revealRandomnessBatch([[1n, 2n]]);

    // id 1's result is unchanged (the griefer's reveal, not overwritten),
    // and id 2 got freshly revealed by the victim's batch call.
    expect((await getResult(randomManager, 1n)).result).to.equal(
      griefedResult,
    );
    expect((await getResult(randomManager, 2n)).result).to.not.equal(0n);
  });
});
