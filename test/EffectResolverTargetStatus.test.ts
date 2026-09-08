import { expect } from "chai";
import hre from "hardhat";

// Focused unit tests for the SP-02 fix (docs/pre-audit.md): DroneSwarmResolver,
// EMPResolver, and RamResolver must all reject a target whose ShipPosition.status
// is non-zero (already destroyed or fled), not just shipId == 0 — otherwise a
// stale, already-gone ship's deleted (zeroed) Attributes can look like a
// legitimate target. Uses MockGameView/MockShipAttributesSpecial rather than a
// full game so each resolver's own validation logic is exercised directly.
describe("Effect resolver target-status validation (SP-02)", function () {
  const GAME_ID = 1n;
  const ACTING_SHIP_ID = 1n;
  const TARGET_SHIP_ID = 2n;

  const actingPosition = {
    shipId: ACTING_SHIP_ID,
    position: { row: 0, col: 0 },
    isCreator: true,
    status: 0,
  };

  function targetPosition(status: number) {
    return {
      shipId: TARGET_SHIP_ID,
      position: { row: 0, col: 1 },
      isCreator: false,
      status,
    };
  }

  const zeroAttrs = {
    version: 0,
    range: 0,
    gunDamage: 0,
    hullPoints: 0,
    maxHullPoints: 0,
    movement: 0,
    damageReduction: 0,
    reactorCriticalTimer: 0,
    statusEffects: [],
  };

  async function deployGameView() {
    return hre.viem.deployContract("MockGameView", []);
  }

  describe("DroneSwarmResolver", function () {
    async function deployResolver(gameView: any) {
      const shipAttrs = await hre.viem.deployContract(
        "MockShipAttributesSpecial",
        [5, 10],
      );
      return hre.viem.deployContract("DroneSwarmResolver", [
        gameView.address,
        shipAttrs.address,
        1, // Special.Slot1
      ]);
    }

    it("rejects a fled/destroyed target (status != 0)", async function () {
      const gameView = await deployGameView();
      const resolver = await deployResolver(gameView);
      await gameView.write.setShipPosition([
        GAME_ID,
        ACTING_SHIP_ID,
        actingPosition,
      ]);
      await gameView.write.setShipPosition([
        GAME_ID,
        TARGET_SHIP_ID,
        targetPosition(2), // fled
      ]);
      await gameView.write.setShipAttributes([
        GAME_ID,
        TARGET_SHIP_ID,
        zeroAttrs,
      ]);

      await expect(
        resolver.read.resolveEffect([
          GAME_ID,
          ACTING_SHIP_ID,
          1,
          TARGET_SHIP_ID,
          0,
          0,
        ]),
      ).to.be.rejectedWith("TargetNotFound");
    });

    it("accepts a live target (status == 0) — control for the check above", async function () {
      const gameView = await deployGameView();
      const resolver = await deployResolver(gameView);
      await gameView.write.setShipPosition([
        GAME_ID,
        ACTING_SHIP_ID,
        actingPosition,
      ]);
      await gameView.write.setShipPosition([
        GAME_ID,
        TARGET_SHIP_ID,
        targetPosition(0), // alive
      ]);
      await gameView.write.setShipAttributes([
        GAME_ID,
        TARGET_SHIP_ID,
        { ...zeroAttrs, hullPoints: 20, maxHullPoints: 20 },
      ]);

      const effects = await resolver.read.resolveEffect([
        GAME_ID,
        ACTING_SHIP_ID,
        1,
        TARGET_SHIP_ID,
        0,
        0,
      ]);
      expect(effects.length).to.equal(1);
    });
  });

  describe("EMPResolver", function () {
    async function deployResolver(gameView: any) {
      const shipAttrs = await hre.viem.deployContract(
        "MockShipAttributesSpecial",
        [5, 1],
      );
      return hre.viem.deployContract("EMPResolver", [
        gameView.address,
        shipAttrs.address,
        1, // Special.Slot1
      ]);
    }

    it("rejects a fled/destroyed target (status != 0)", async function () {
      const gameView = await deployGameView();
      const resolver = await deployResolver(gameView);
      await gameView.write.setShipPosition([
        GAME_ID,
        ACTING_SHIP_ID,
        actingPosition,
      ]);
      await gameView.write.setShipPosition([
        GAME_ID,
        TARGET_SHIP_ID,
        targetPosition(1), // destroyed
      ]);

      await expect(
        resolver.read.resolveEffect([
          GAME_ID,
          ACTING_SHIP_ID,
          1,
          TARGET_SHIP_ID,
          0,
          0,
        ]),
      ).to.be.rejectedWith("TargetNotFound");
    });

    it("accepts a live target (status == 0) — control for the check above", async function () {
      const gameView = await deployGameView();
      const resolver = await deployResolver(gameView);
      await gameView.write.setShipPosition([
        GAME_ID,
        ACTING_SHIP_ID,
        actingPosition,
      ]);
      await gameView.write.setShipPosition([
        GAME_ID,
        TARGET_SHIP_ID,
        targetPosition(0),
      ]);

      const effects = await resolver.read.resolveEffect([
        GAME_ID,
        ACTING_SHIP_ID,
        1,
        TARGET_SHIP_ID,
        0,
        0,
      ]);
      expect(effects.length).to.equal(1);
    });
  });

  describe("RamResolver", function () {
    async function deployResolver(gameView: any) {
      return hre.viem.deployContract("RamResolver", [gameView.address]);
    }

    it("rejects a fled/destroyed target (status != 0) even though its deleted Attributes read hullPoints == 0", async function () {
      const gameView = await deployGameView();
      const resolver = await deployResolver(gameView);
      await gameView.write.setShipPosition([
        GAME_ID,
        ACTING_SHIP_ID,
        actingPosition,
      ]);
      await gameView.write.setShipPosition([
        GAME_ID,
        TARGET_SHIP_ID,
        targetPosition(2), // fled
      ]);
      await gameView.write.setShipAttributes([
        GAME_ID,
        TARGET_SHIP_ID,
        zeroAttrs, // deleted Attributes: hullPoints == 0, same as a genuinely-downed ship
      ]);

      await expect(
        resolver.read.resolveEffect([
          GAME_ID,
          ACTING_SHIP_ID,
          1,
          TARGET_SHIP_ID,
          0,
          0,
        ]),
      ).to.be.rejectedWith("InvalidRamTarget");
    });

    it("accepts a live, genuinely-downed target (status == 0, hullPoints == 0) — control for the check above", async function () {
      const gameView = await deployGameView();
      const resolver = await deployResolver(gameView);
      await gameView.write.setShipPosition([
        GAME_ID,
        ACTING_SHIP_ID,
        actingPosition,
      ]);
      await gameView.write.setShipPosition([
        GAME_ID,
        TARGET_SHIP_ID,
        targetPosition(0),
      ]);
      await gameView.write.setShipAttributes([
        GAME_ID,
        TARGET_SHIP_ID,
        zeroAttrs,
      ]);

      const effects = await resolver.read.resolveEffect([
        GAME_ID,
        ACTING_SHIP_ID,
        1,
        TARGET_SHIP_ID,
        0,
        0,
      ]);
      expect(effects.length).to.equal(2);
    });
  });
});
