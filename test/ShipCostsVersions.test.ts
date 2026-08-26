import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import { parseEther, zeroAddress } from "viem";
import DeployModule from "../ignition/modules/DeployAndConfig";
import { deployShipsFixture } from "./fixtures/deployShipsFixture";
import { ShipTuple, tupleToShip } from "./types";

/** Same Ignition module as Ships tests; builds lobby + constructed free ships for fleet rules. */
async function deployLobbyFleetFixture() {
  const [owner, creator, joiner] = await hre.viem.getWalletClients();
  const publicClient = await hre.viem.getPublicClient();
  const deployed = await hre.ignition.deploy(DeployModule);

  const ships = deployed.ships;
  const freeShipClaim = deployed.freeShipClaim;
  const randomManager = deployed.randomManager;
  const shipAttributes = deployed.shipAttributes;

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

  await freeShipClaim.write.claimFreeShips([1], { account: creator.account });
  await freeShipClaim.write.claimFreeShips([1], { account: joiner.account });

  const fulfillRandomnessForPlayer = async (address: `0x${string}`) => {
    const shipIds = await ships.read.getShipIdsOwned([address]);
    for (const shipId of shipIds) {
      const shipTuple = (await ships.read.ships([shipId])) as ShipTuple;
      const ship = tupleToShip(shipTuple);
      await randomManager.write.revealRandomness([ship.traits.serialNumber]);
    }
    return shipIds;
  };

  await fulfillRandomnessForPlayer(creator.account.address);
  await fulfillRandomnessForPlayer(joiner.account.address);

  await ships.write.constructAllMyShips({ account: creator.account });
  await ships.write.constructAllMyShips({ account: joiner.account });

  const creatorShipIds = await ships.read.getShipIdsOwned([
    creator.account.address,
  ]);

  return {
    owner,
    creator,
    joiner,
    publicClient,
    ships,
    shipAttributes,
    randomManager,
    creatorLobbies,
    joinerLobbies,
    creatorShipIds,
  };
}

function sampleCostsV2() {
  return {
    version: 2,
    baseCost: 60,
    accuracy: [0, 15, 30],
    hull: [0, 15, 30],
    speed: [0, 15, 30],
    mainWeapon: [30, 35, 45, 45],
    armor: [0, 8, 12, 18],
    shields: [0, 12, 24, 36],
    // Special is a per-faction local slot 0-7 (8 members) — costs.special
    // must cover the full range, since GenerateNewShip rolls across all 8
    // slots now, not just the first 4.
    special: [0, 12, 24, 18, 18, 24, 12, 0],
  };
}

// Default gun/armor/shield data — matches ShipAttributes' constructor
// seed. setVariantAttributes now fully replaces a variant's guns/armors/
// shields on every call (delete + re-push), so tests that only care about
// hull/specials still need to supply the full baseline for these to avoid
// wiping them.
function defaultGunsArmorsShields() {
  return {
    guns: [
      { range: 3, damage: 50, movement: 0 },
      { range: 6, damage: 40, movement: 0 },
      { range: 4, damage: 60, movement: -1 },
      { range: 2, damage: 80, movement: 0 },
    ],
    armors: [
      { damageReduction: 0, movement: 1 },
      { damageReduction: 15, movement: 0 },
      { damageReduction: 30, movement: -1 },
      { damageReduction: 45, movement: -2 },
    ],
    shields: [
      { damageReduction: 0, movement: 1 },
      { damageReduction: 15, movement: 1 },
      { damageReduction: 30, movement: 0 },
      { damageReduction: 45, movement: -1 },
    ],
  };
}

function sampleSetAllAttributesArgs() {
  const newGuns = [
    { range: 8, damage: 30, movement: 0 },
    { range: 15, damage: 25, movement: 0 },
    { range: 10, damage: 35, movement: -1 },
    { range: 5, damage: 45, movement: 0 },
  ];
  const newArmors = [
    { damageReduction: 0, movement: 1 },
    { damageReduction: 5, movement: 0 },
    { damageReduction: 10, movement: -1 },
    { damageReduction: 15, movement: -2 },
  ];
  const newShields = [
    { damageReduction: 0, movement: 1 },
    { damageReduction: 8, movement: 0 },
    { damageReduction: 15, movement: -1 },
    { damageReduction: 25, movement: -2 },
  ];
  const newSpecials = [
    { range: 0, strength: 0, movement: 0 },
    { range: 6, strength: 10, movement: 0 },
    { range: 8, strength: 0, movement: 0 },
    { range: 4, strength: 15, movement: 0 },
  ];
  const newForeAccuracy = [0, 130, 160];
  const newEngineSpeeds = [0, 2, 3];
  const newHull = [0, 10, 20];
  return {
    newGuns,
    newArmors,
    newShields,
    newSpecials,
    newForeAccuracy,
    newEngineSpeeds,
    newHull,
  };
}

describe("Ship costs, versions, and fleets", function () {
  describe("ShipAttributes — current version pointer", function () {
    it("lets owner setCurrentAttributesVersion back to a prior version", async function () {
      const { shipAttributes, owner } = await loadFixture(deployShipsFixture);

      expect(
        await shipAttributes.read.getCurrentAttributesVersion(),
      ).to.equal(1);

      const {
        newGuns,
        newArmors,
        newShields,
        newSpecials,
        newForeAccuracy,
        newEngineSpeeds,
        newHull,
      } = sampleSetAllAttributesArgs();

      await shipAttributes.write.startNewAttributesVersion({
        account: owner.account,
      });

      expect(
        await shipAttributes.read.getCurrentAttributesVersion(),
      ).to.equal(2);

      await shipAttributes.write.setVariantAttributes(
        [
          {
            version: 2,
            variant: 1,
            baseHull: 120,
            baseSpeed: 4,
            foreAccuracy: newForeAccuracy,
            hull: newHull,
            engineSpeeds: newEngineSpeeds,
            guns: newGuns,
            armors: newArmors,
            shields: newShields,
            specials: newSpecials,
          },
        ],
        { account: owner.account },
      );

      await shipAttributes.write.setCurrentAttributesVersion([1n], {
        account: owner.account,
      });

      expect(
        await shipAttributes.read.getCurrentAttributesVersion(),
      ).to.equal(1);

      const v1 = await shipAttributes.read.getAttributesVersionBase([1n, 1]);
      expect(v1[0]).to.equal(1);
      expect(v1[1]).to.equal(100);

      const v2 = await shipAttributes.read.getAttributesVersionBase([2n, 1]);
      expect(v2[0]).to.equal(2);
      expect(v2[1]).to.equal(120);
    });
  });

  describe("Per-variant ship attributes and specials", function () {
    it("gives ships of different variants different hull points and special data", async function () {
      const { ships, shipAttributes, randomManager, owner, user1, shatteredHiveMedal } =
        await loadFixture(deployShipsFixture);

      // Configure variant 2 with much higher hull bonuses and a much
      // stronger/longer-range EMP than the constructor's variant 1 baseline
      await shipAttributes.write.setVariantAttributes(
        [
          {
            version: 1,
            variant: 2,
            baseHull: 100,
            baseSpeed: 3,
            foreAccuracy: [0, 25, 50],
            hull: [0, 50, 100],
            engineSpeeds: [0, 1, 2],
            ...defaultGunsArmorsShields(),
            specials: [
              { range: 0, strength: 0, movement: 0 },
              { range: 5, strength: 99, movement: 0 },
              { range: 3, strength: 40, movement: 0 },
              { range: 3, strength: 30, movement: 0 },
            ],
          },
        ],
        { account: owner.account },
      );

      // Tier 0 mints 5 ships per purchase, so ship 1 is the first ship of the
      // variant-1 purchase and ship 6 is the first ship of the variant-2
      // purchase
      await shatteredHiveMedal.write.ownerMint([user1.account.address], {
        account: owner.account,
      });

      await ships.write.purchaseWithFlow(
        [user1.account.address, 0n, user1.account.address, 1],
        { value: parseEther("4.99") },
      );
      await ships.write.purchaseWithFlow(
        [user1.account.address, 0n, user1.account.address, 2],
        { value: parseEther("4.99") },
      );

      for (let i = 1; i <= 10; i++) {
        const shipTuple = (await ships.read.ships([BigInt(i)])) as ShipTuple;
        const ship = tupleToShip(shipTuple);
        await randomManager.write.revealRandomness([
          ship.traits.serialNumber,
        ]);
      }
      await ships.write.constructAllMyShips({ account: user1.account });

      const variant1Ship = tupleToShip(
        (await ships.read.ships([1n])) as ShipTuple,
      );
      const variant2Ship = tupleToShip(
        (await ships.read.ships([6n])) as ShipTuple,
      );
      expect(variant1Ship.traits.variant).to.equal(1);
      expect(variant2Ship.traits.variant).to.equal(2);

      const attrs2 = await shipAttributes.read.calculateShipAttributesById([
        6n,
      ]);

      // Compare against variant 2's configured hull bonus for whichever hull
      // tier this ship actually rolled (tiers are randomly assigned per ship,
      // so comparing two ships' hullPoints directly isn't reliable — only
      // the bonus at a given ship's own tier is deterministic)
      const variant2HullBonus = [0, 50, 100][variant2Ship.traits.hull];
      expect(attrs2.hullPoints).to.equal(100 + variant2HullBonus);

      const empRange1 = await shipAttributes.read.getSpecialRange([1, 1]);
      const empStrength1 = await shipAttributes.read.getSpecialStrength([
        1, 1,
      ]);
      const empRange2 = await shipAttributes.read.getSpecialRange([1, 2]);
      const empStrength2 = await shipAttributes.read.getSpecialStrength([
        1, 2,
      ]);

      expect(empStrength2).to.be.greaterThan(empStrength1);
      expect(empRange2).to.be.greaterThan(empRange1);
    });

    it("gives ships of different variants different weapon/armor/shield stats", async function () {
      const { ships, shipAttributes, randomManager, owner, user1, shatteredHiveMedal } =
        await loadFixture(deployShipsFixture);

      // Configure variant 2 with a much stronger Laser and heavier armor
      // than the constructor's variant 1 baseline. guns/armors/shields are
      // per-variant now (VariantAttributeData), not shared globally.
      const { guns: v1Guns, armors: v1Armors, shields: v1Shields } =
        defaultGunsArmorsShields();
      await shipAttributes.write.setVariantAttributes(
        [
          {
            version: 1,
            variant: 2,
            baseHull: 100,
            baseSpeed: 3,
            foreAccuracy: [0, 25, 50],
            hull: [0, 10, 20],
            engineSpeeds: [0, 1, 2],
            guns: [
              { range: 10, damage: 150, movement: 0 }, // Generic, boosted
              v1Guns[1],
              v1Guns[2],
              v1Guns[3],
            ],
            armors: [
              { damageReduction: 0, movement: 1 },
              { damageReduction: 60, movement: 0 }, // Light, boosted
              v1Armors[2],
              v1Armors[3],
            ],
            shields: v1Shields,
            specials: [
              { range: 0, strength: 0, movement: 0 },
              { range: 1, strength: 1, movement: 0 },
              { range: 3, strength: 40, movement: 0 },
              { range: 3, strength: 30, movement: 0 },
            ],
          },
        ],
        { account: owner.account },
      );

      const gunVariant1 = await shipAttributes.read.getGunData([0, 1]); // Generic
      const gunVariant2 = await shipAttributes.read.getGunData([0, 2]);
      expect(gunVariant2.range).to.be.greaterThan(gunVariant1.range);
      expect(gunVariant2.damage).to.be.greaterThan(gunVariant1.damage);

      const armorVariant1 = await shipAttributes.read.getArmorData([1, 1]); // Light
      const armorVariant2 = await shipAttributes.read.getArmorData([1, 2]);
      expect(armorVariant2.damageReduction).to.be.greaterThan(
        armorVariant1.damageReduction,
      );

      await shatteredHiveMedal.write.ownerMint([user1.account.address], {
        account: owner.account,
      });

      // Tier 0 mints 5 ships per purchase, so ship 1 is the first ship of the
      // variant-1 purchase and ship 6 is the first ship of the variant-2
      // purchase
      await ships.write.purchaseWithFlow(
        [user1.account.address, 0n, user1.account.address, 1],
        { value: parseEther("4.99") },
      );
      await ships.write.purchaseWithFlow(
        [user1.account.address, 0n, user1.account.address, 2],
        { value: parseEther("4.99") },
      );

      for (let i = 1; i <= 10; i++) {
        const shipTuple = (await ships.read.ships([BigInt(i)])) as ShipTuple;
        const ship = tupleToShip(shipTuple);
        await randomManager.write.revealRandomness([
          ship.traits.serialNumber,
        ]);
      }
      await ships.write.constructAllMyShips({ account: user1.account });

      // Force both ships onto the same weapon (Laser) so the only variable
      // left is which variant's gun stats got applied.
      const ship1 = tupleToShip((await ships.read.ships([1n])) as ShipTuple);
      const ship6 = tupleToShip((await ships.read.ships([6n])) as ShipTuple);
      expect(ship1.traits.variant).to.equal(1);
      expect(ship6.traits.variant).to.equal(2);

      if (ship1.equipment.mainWeapon === 0 && ship6.equipment.mainWeapon === 0) {
        const attrs1 = await shipAttributes.read.calculateShipAttributesById([
          1n,
        ]);
        const attrs6 = await shipAttributes.read.calculateShipAttributesById([
          6n,
        ]);
        expect(attrs6.gunDamage).to.be.greaterThan(attrs1.gunDamage);
      }
    });

    it("changing variant 2's costs leaves variant 1's cost version and fleet eligibility untouched", async function () {
      const {
        owner,
        shipAttributes,
        creatorLobbies,
        joinerLobbies,
        creatorShipIds,
      } = await loadFixture(deployLobbyFleetFixture);

      // All ships from claimFreeShips are variant 1 (TutorialClaim mints
      // every fixed reward ship as variant 1).
      const variant1VersionBefore =
        await shipAttributes.read.getCurrentCostsVersion([1]);

      await shipAttributes.write.setCosts([2, sampleCostsV2()], {
        account: owner.account,
      });

      const variant1VersionAfter =
        await shipAttributes.read.getCurrentCostsVersion([1]);
      expect(variant1VersionAfter).to.equal(variant1VersionBefore);

      const costLimit = 1000n;
      const turnTime = 300n;
      await creatorLobbies.write.createLobby([
        costLimit,
        turnTime,
        true,
        0n,
        100n,
        zeroAddress,
      ]);
      await joinerLobbies.write.joinLobby([1n]);

      // A variant-1 ship's stored costsVersion is still current — creating
      // a fleet with it must not revert ShipCostVersionMismatch, even
      // though variant 2's costs version was just bumped.
      await creatorLobbies.write.createFleet([
        1n,
        [creatorShipIds[0]],
        [{ row: 0, col: 0 }],
      ]);
    });

    it("reverts (fails loud) when reading an unconfigured variant", async function () {
      const { shipAttributes } = await loadFixture(deployShipsFixture);

      await expect(shipAttributes.read.getSpecialRange([1, 99])).to.be
        .rejected;
    });

    it("gives variant 2 a genuinely different baseCost than variant 1", async function () {
      const { shipAttributes, owner } = await loadFixture(deployShipsFixture);

      // Costs are per-variant now (ShipAttributes.costsByVariant) — set
      // variant 2's baseCost 50 higher than variant 1's constructor-seeded
      // default (50), leaving variant 1 untouched.
      const variant2Costs = {
        version: 0,
        baseCost: 100,
        accuracy: [0, 10, 25],
        hull: [0, 10, 25],
        speed: [0, 10, 25],
        mainWeapon: [25, 30, 40, 40],
        armor: [0, 5, 10, 15],
        shields: [0, 10, 20, 30],
        special: [0, 10, 20, 15, 15, 20, 10, 0],
      };
      await shipAttributes.write.setCosts([2, variant2Costs], {
        account: owner.account,
      });

      const baseShip = {
        name: "",
        id: 0n,
        equipment: { mainWeapon: 0, armor: 0, shields: 0, special: 0 },
        traits: {
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
      };

      const costVariant1 = await shipAttributes.read.calculateShipCost([
        baseShip,
      ]);
      const costVariant2 = await shipAttributes.read.calculateShipCost([
        { ...baseShip, traits: { ...baseShip.traits, variant: 2 } },
      ]);

      expect(costVariant2 - costVariant1).to.equal(50);
    });
  });

  describe("Ships.setCostOfShip", function () {
    it("rejects non-owner non-game callers", async function () {
      const { ships, user1, randomManager } =
        await loadFixture(deployShipsFixture);

      await ships.write.purchaseWithFlow(
        [user1.account.address, 0n, user1.account.address, 1],
        { value: parseEther("4.99") },
      );

      const shipTuple = (await ships.read.ships([1n])) as ShipTuple;
      const ship = tupleToShip(shipTuple);
      await randomManager.write.revealRandomness([ship.traits.serialNumber]);
      await ships.write.constructShip([1n], { account: user1.account });

      await expect(
        ships.write.setCostOfShip([1n], { account: user1.account }),
      ).to.be.rejectedWith("NotAuthorized");
    });

    it("after setCosts, owner syncs ship cost and costsVersion to match live tables", async function () {
      const { ships, shipAttributes, owner, user1, randomManager } =
        await loadFixture(deployShipsFixture);

      await ships.write.purchaseWithFlow(
        [user1.account.address, 0n, user1.account.address, 1],
        { value: parseEther("4.99") },
      );

      const shipTupleBefore = (await ships.read.ships([1n])) as ShipTuple;
      const s0 = tupleToShip(shipTupleBefore);
      await randomManager.write.revealRandomness([s0.traits.serialNumber]);
      await ships.write.constructShip([1n], { account: user1.account });

      const vBefore = await shipAttributes.read.getCurrentCostsVersion([1]);
      const shipBefore = tupleToShip(
        (await ships.read.ships([1n])) as ShipTuple,
      );
      expect(Number(shipBefore.shipData.costsVersion)).to.equal(
        Number(vBefore),
      );

      await shipAttributes.write.setCosts([1, sampleCostsV2()], {
        account: owner.account,
      });

      const vAfter = await shipAttributes.read.getCurrentCostsVersion([1]);
      expect(Number(vAfter)).to.equal(Number(vBefore) + 1);

      const stale = tupleToShip((await ships.read.ships([1n])) as ShipTuple);
      expect(stale.shipData.costsVersion).to.equal(vBefore);

      await ships.write.setCostOfShip([1n], { account: owner.account });

      const shipMem = await ships.read.getShip([1n]);
      const expectedCost =
        await shipAttributes.read.calculateShipCost([shipMem]);

      const updated = tupleToShip((await ships.read.ships([1n])) as ShipTuple);
      expect(Number(updated.shipData.costsVersion)).to.equal(Number(vAfter));
      expect(BigInt(updated.shipData.cost)).to.equal(BigInt(expectedCost));
    });

    it("syncShipCosts is permissionless and updates multiple ships", async function () {
      const { ships, shipAttributes, owner, user1, user2, randomManager } =
        await loadFixture(deployShipsFixture);

      await ships.write.purchaseWithFlow(
        [user1.account.address, 0n, user1.account.address, 1],
        { value: parseEther("4.99") },
      );

      for (const id of [1n, 2n] as const) {
        const shipTuple = (await ships.read.ships([id])) as ShipTuple;
        const s = tupleToShip(shipTuple);
        await randomManager.write.revealRandomness([s.traits.serialNumber]);
        await ships.write.constructShip([id], { account: user1.account });
      }

      await shipAttributes.write.setCosts([1, sampleCostsV2()], {
        account: owner.account,
      });

      const vAfter = await shipAttributes.read.getCurrentCostsVersion([1]);

      await ships.write.syncShipCosts([[1n, 2n]], { account: user2.account });

      for (const id of [1n, 2n] as const) {
        const shipMem = await ships.read.getShip([id]);
        const expectedCost =
          await shipAttributes.read.calculateShipCost([shipMem]);
        const updated = tupleToShip((await ships.read.ships([id])) as ShipTuple);
        expect(Number(updated.shipData.costsVersion)).to.equal(Number(vAfter));
        expect(BigInt(updated.shipData.cost)).to.equal(BigInt(expectedCost));
      }
    });

    it("reverts ShipInFleet while ship is in a lobby fleet", async function () {
      const {
        owner,
        creator,
        joiner,
        ships,
        shipAttributes,
        creatorLobbies,
        joinerLobbies,
        creatorShipIds,
      } = await loadFixture(deployLobbyFleetFixture);

      const costLimit = 1000n;
      const turnTime = 300n;

      await creatorLobbies.write.createLobby([
        costLimit,
        turnTime,
        true,
        0n,
        100n,
        zeroAddress,
      ]);
      await joinerLobbies.write.joinLobby([1n]);

      const shipId = creatorShipIds[0];
      await creatorLobbies.write.createFleet([
        1n,
        [shipId],
        [{ row: 0, col: 0 }],
      ]);

      await expect(
        ships.write.syncShipCosts([[shipId]], { account: joiner.account }),
      ).to.be.rejectedWith("ShipInFleet");

      await expect(
        ships.write.setCostOfShip([shipId], { account: owner.account }),
      ).to.be.rejectedWith("ShipInFleet");

      await shipAttributes.write.setCosts([1, sampleCostsV2()], {
        account: owner.account,
      });

      await expect(
        ships.write.setCostOfShip([shipId], { account: owner.account }),
      ).to.be.rejectedWith("ShipInFleet");
    });

    it("allows setCostOfShip after creator fleet is cleared (creator leaves)", async function () {
      const {
        owner,
        creator,
        joiner,
        ships,
        shipAttributes,
        creatorLobbies,
        joinerLobbies,
        creatorShipIds,
      } = await loadFixture(deployLobbyFleetFixture);

      const costLimit = 1000n;
      const turnTime = 300n;

      await creatorLobbies.write.createLobby([
        costLimit,
        turnTime,
        true,
        0n,
        100n,
        zeroAddress,
      ]);
      await joinerLobbies.write.joinLobby([1n]);

      const shipId = creatorShipIds[0];
      await creatorLobbies.write.createFleet([
        1n,
        [shipId],
        [{ row: 0, col: 0 }],
      ]);

      await creatorLobbies.write.leaveLobby([1n]);

      await shipAttributes.write.setCosts([1, sampleCostsV2()], {
        account: owner.account,
      });

      await ships.write.setCostOfShip([shipId], { account: owner.account });

      const v = await shipAttributes.read.getCurrentCostsVersion([1]);
      const updated = tupleToShip((await ships.read.ships([shipId])) as ShipTuple);
      expect(Number(updated.shipData.costsVersion)).to.equal(Number(v));

      const shipMem = await ships.read.getShip([shipId]);
      const expectedCost =
        await shipAttributes.read.calculateShipCost([shipMem]);
      expect(BigInt(updated.shipData.cost)).to.equal(BigInt(expectedCost));
    });
  });

  describe("Fleets cost version guard", function () {
    it("reverts createFleet with ShipCostVersionMismatch when ship lags global costs version", async function () {
      const {
        owner,
        creator,
        joiner,
        ships,
        shipAttributes,
        creatorLobbies,
        joinerLobbies,
        creatorShipIds,
      } = await loadFixture(deployLobbyFleetFixture);

      await shipAttributes.write.setCosts([1, sampleCostsV2()], {
        account: owner.account,
      });

      const costLimit = 1000n;
      const turnTime = 300n;

      await creatorLobbies.write.createLobby([
        costLimit,
        turnTime,
        true,
        0n,
        100n,
        zeroAddress,
      ]);
      await joinerLobbies.write.joinLobby([1n]);

      const shipId = creatorShipIds[0];

      await expect(
        creatorLobbies.write.createFleet([
          1n,
          [shipId],
          [{ row: 0, col: 0 }],
        ]),
      ).to.be.rejectedWith("ShipCostVersionMismatch");

      await ships.write.setCostOfShip([shipId], { account: owner.account });

      await creatorLobbies.write.createFleet([
        1n,
        [shipId],
        [{ row: 0, col: 0 }],
      ]);
    });
  });

  describe("Fleets variant guard", function () {
    it("reverts createFleet when ship variants are mixed", async function () {
      const {
        owner,
        creator,
        ships,
        shipAttributes,
        creatorLobbies,
        joinerLobbies,
        creatorShipIds,
      } = await loadFixture(deployLobbyFleetFixture);

      // Mint a second, plain variant-1 ship (ungated, unlike variant 2
      // which requires holding ShatteredHiveMedal — irrelevant to this
      // test), then overwrite it in place to variant 2 via customizeShip.
      // customizeShip fully replaces the stored struct and doesn't call
      // VariantPurchaseGate.checkGate (that only runs on the _mintShip
      // path), so it's the simplest way to get a fleet-eligible variant-2
      // ship for this test without needing to actually hold the medal.
      await ships.write.setIsAllowedToCreateShips(
        [owner.account.address, true],
        { account: owner.account },
      );
      await ships.write.createShips(
        [creator.account.address, 1, 1, 0, false],
        { account: owner.account },
      );

      const ownedAfter = await ships.read.getShipIdsOwned([
        creator.account.address,
      ]);
      const variant2ShipId = ownedAfter[ownedAfter.length - 1];

      const variant2CostsVersion =
        await shipAttributes.read.getCurrentCostsVersion([2]);

      await ships.write.customizeShip(
        [
          variant2ShipId,
          {
            name: "Variant 2 Test Ship",
            id: variant2ShipId,
            equipment: { mainWeapon: 0, armor: 0, shields: 0, special: 0 },
            traits: {
              serialNumber: 999999n,
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
              variant: 2,
              accuracy: 0,
              hull: 0,
              speed: 0,
            },
            shipData: {
              constructed: true,
              inFleet: false,
              isFreeShip: false,
              modified: 0,
              timestampDestroyed: 0n,
              shiny: false,
              shipsDestroyed: 0,
              costsVersion: variant2CostsVersion,
              cost: 0,
            },
            owner: creator.account.address,
          },
        ],
        { account: owner.account },
      );

      const costLimit = 1000n;
      const turnTime = 300n;
      await creatorLobbies.write.createLobby([
        costLimit,
        turnTime,
        true,
        0n,
        100n,
        zeroAddress,
      ]);
      await joinerLobbies.write.joinLobby([1n]);

      await expect(
        creatorLobbies.write.createFleet([
          1n,
          [creatorShipIds[0], variant2ShipId],
          [
            { row: 0, col: 0 },
            { row: 0, col: 1 },
          ],
        ]),
      ).to.be.rejectedWith("MixedVariantFleet");
    });
  });
});
