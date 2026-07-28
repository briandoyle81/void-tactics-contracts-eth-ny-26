import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import { zeroAddress } from "viem";

// Standalone unit tests for AIShips.sol's pool mechanics, isolated from
// SinglePlayerMatch/ShipsRouter. ShipAttributes' constructor takes a
// `_ships` address purely for calculateShipAttributesById (never called by
// AIShips, which only uses getCurrentCostsVersion/calculateShipCost), so an
// arbitrary EOA stands in for it here.
describe("AIShips", function () {
  const AI_SHIP_ID_OFFSET = 2n ** 128n;

  async function deployFixture() {
    const [owner, allowedMinter, router, other] =
      await hre.viem.getWalletClients();

    const shipAttributes = await hre.viem.deployContract("ShipAttributes", [
      owner.account.address, // stand-in `_ships` address, never dereferenced
    ]);
    const aiShips = await hre.viem.deployContract("AIShips", []);

    await aiShips.write.setShipAttributesAddress([shipAttributes.address]);
    await aiShips.write.setRouter([router.account.address]);
    await aiShips.write.setIsAllowedToCreateShips([
      allowedMinter.account.address,
      true,
    ]);

    const minterAiShips = await hre.viem.getContractAt(
      "AIShips",
      aiShips.address,
      { client: { wallet: allowedMinter } },
    );
    const routerAiShips = await hre.viem.getContractAt(
      "AIShips",
      aiShips.address,
      { client: { wallet: router } },
    );
    const otherAiShips = await hre.viem.getContractAt(
      "AIShips",
      aiShips.address,
      { client: { wallet: other } },
    );

    return {
      aiShips,
      shipAttributes,
      minterAiShips,
      routerAiShips,
      otherAiShips,
      owner,
      allowedMinter,
      router,
      other,
    };
  }

  const shipTemplate = (overrides: Partial<any> = {}) => ({
    name: "AI Ship",
    id: 0n,
    equipment: { mainWeapon: 0, armor: 0, shields: 0, special: 0 },
    traits: {
      serialNumber: 0n,
      colors: { h1: 0, s1: 0, l1: 0, h2: 0, s2: 0, l2: 0, h3: 0, s3: 0, l3: 0 },
      variant: 1,
      accuracy: 0,
      hull: 0,
      speed: 0,
    },
    shipData: {
      shipsDestroyed: 0,
      costsVersion: 0,
      cost: 0,
      modified: 0,
      shiny: false,
      constructed: false,
      inFleet: false,
      isFreeShip: false,
      timestampDestroyed: 0n,
    },
    owner: zeroAddress,
    ...overrides,
  });

  describe("allocateShip", function () {
    it("reverts when called by an address not on the whitelist", async function () {
      const { otherAiShips, other } = await loadFixture(deployFixture);

      await expect(
        otherAiShips.write.allocateShip([other.account.address, shipTemplate()]),
      ).to.be.rejectedWith("NotAuthorized");
    });

    it("assigns the first-ever id as AI_SHIP_ID_OFFSET + 1 and stamps it onto the ship", async function () {
      const { minterAiShips, aiShips, other } = await loadFixture(deployFixture);

      await minterAiShips.write.allocateShip([
        other.account.address,
        shipTemplate({ name: "Scout" }),
      ]);

      const ship = await aiShips.read.getShip([AI_SHIP_ID_OFFSET + 1n]);
      expect(ship.name).to.equal("Scout");
      expect(ship.id).to.equal(AI_SHIP_ID_OFFSET + 1n);
      expect(ship.owner.toLowerCase()).to.equal(
        other.account.address.toLowerCase(),
      );
      expect(ship.shipData.constructed).to.equal(true);
      expect(ship.shipData.cost).to.be.greaterThan(0);
    });

    it("allocates sequential ids for successive ships with no free slots available", async function () {
      const { minterAiShips, aiShips, other } = await loadFixture(deployFixture);

      for (let i = 1; i <= 3; i++) {
        await minterAiShips.write.allocateShip([
          other.account.address,
          shipTemplate(),
        ]);
        const ship = await aiShips.read.getShip([AI_SHIP_ID_OFFSET + BigInt(i)]);
        expect(ship.owner.toLowerCase()).to.equal(
          other.account.address.toLowerCase(),
        );
      }
      expect(await aiShips.read.slotCount()).to.equal(3n);
    });
  });

  describe("pool reuse", function () {
    it("reuses a released slot's id instead of growing slotCount, and resets match-scoped fields", async function () {
      const { minterAiShips, routerAiShips, aiShips, other } =
        await loadFixture(deployFixture);

      await minterAiShips.write.allocateShip([
        other.account.address,
        shipTemplate({ name: "First" }),
      ]);
      const firstId = AI_SHIP_ID_OFFSET + 1n;

      // Simulate a full match lifecycle: the ship gets destroyed and racks
      // up an (unrelated) kill credit before its game ends.
      await routerAiShips.write.markDestroyed([firstId]);
      await routerAiShips.write.recordKill([firstId]);
      await routerAiShips.write.setInFleet([firstId, true]);
      expect(await aiShips.read.isShipDestroyed([firstId])).to.equal(true);

      await minterAiShips.write.releaseShips([[firstId]]);
      expect(await aiShips.read.slotCount()).to.equal(1n);

      await minterAiShips.write.allocateShip([
        other.account.address,
        shipTemplate({ name: "Second" }),
      ]);

      // Same id reused — slotCount didn't grow.
      expect(await aiShips.read.slotCount()).to.equal(1n);
      const reused = await aiShips.read.getShip([firstId]);
      expect(reused.name).to.equal("Second");
      expect(reused.shipData.timestampDestroyed).to.equal(0n);
      expect(reused.shipData.shipsDestroyed).to.equal(0);
      expect(reused.shipData.inFleet).to.equal(false);
      expect(await aiShips.read.isShipDestroyed([firstId])).to.equal(false);
    });

    it("expands past any prior high-water mark once the pool is empty again", async function () {
      const { minterAiShips, aiShips, other } = await loadFixture(deployFixture);

      const ids = [
        AI_SHIP_ID_OFFSET + 1n,
        AI_SHIP_ID_OFFSET + 2n,
        AI_SHIP_ID_OFFSET + 3n,
      ];
      for (let i = 0; i < 3; i++) {
        await minterAiShips.write.allocateShip([
          other.account.address,
          shipTemplate(),
        ]);
      }
      expect(await aiShips.read.slotCount()).to.equal(3n);

      await minterAiShips.write.releaseShips([ids]);

      // Drain the pool (3 reused) then allocate one more — must grow past 3.
      for (let i = 0; i < 4; i++) {
        await minterAiShips.write.allocateShip([
          other.account.address,
          shipTemplate(),
        ]);
      }
      expect(await aiShips.read.slotCount()).to.equal(4n);

      const fourth = await aiShips.read.getShip([AI_SHIP_ID_OFFSET + 4n]);
      expect(fourth.owner.toLowerCase()).to.equal(
        other.account.address.toLowerCase(),
      );
    });
  });

  describe("router-gated functions", function () {
    it("markDestroyed/recordKill/setInFleet revert when called by anyone other than the configured router", async function () {
      const { minterAiShips, otherAiShips, other } =
        await loadFixture(deployFixture);

      await minterAiShips.write.allocateShip([
        other.account.address,
        shipTemplate(),
      ]);
      const id = AI_SHIP_ID_OFFSET + 1n;

      await expect(
        otherAiShips.write.markDestroyed([id]),
      ).to.be.rejectedWith("NotAuthorized");
      await expect(
        otherAiShips.write.recordKill([id]),
      ).to.be.rejectedWith("NotAuthorized");
      await expect(
        otherAiShips.write.setInFleet([id, true]),
      ).to.be.rejectedWith("NotAuthorized");
    });

    it("markDestroyed/recordKill mark/credit the right ship", async function () {
      const { minterAiShips, routerAiShips, aiShips, other } =
        await loadFixture(deployFixture);

      await minterAiShips.write.allocateShip([
        other.account.address,
        shipTemplate(),
      ]);
      const id = AI_SHIP_ID_OFFSET + 1n;

      await routerAiShips.write.markDestroyed([id]);
      expect(await aiShips.read.isShipDestroyed([id])).to.equal(true);

      await routerAiShips.write.recordKill([id]);
      const ship = await aiShips.read.getShip([id]);
      expect(ship.shipData.shipsDestroyed).to.equal(1);
    });
  });

  describe("releaseShips authorization", function () {
    it("reverts when called by an address not on the whitelist", async function () {
      const { otherAiShips } = await loadFixture(deployFixture);

      await expect(
        otherAiShips.write.releaseShips([[AI_SHIP_ID_OFFSET + 1n]]),
      ).to.be.rejectedWith("NotAuthorized");
    });
  });
});
