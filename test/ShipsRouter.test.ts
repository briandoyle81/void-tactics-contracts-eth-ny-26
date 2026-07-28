import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import { zeroAddress } from "viem";

// Standalone unit tests for ShipsRouter.sol's dispatch logic: does an id
// resolve to Ships.sol (human) or AIShips.sol (AI) correctly, and does
// setTimestampDestroyed's cross-contract kill-reward orchestration work in
// both directions plus the pure-PvP (both-human) case. Deploys Ships/
// AIShips/ShipAttributes/UniversalCredits/DroneEnergyCores directly rather
// than the full DeployAndConfig module, matching test/NodeMap.test.ts's
// convention for contracts with few real dependencies.
describe("ShipsRouter", function () {
  const AI_SHIP_ID_OFFSET = 2n ** 128n;

  async function deployFixture() {
    const [owner, gameEOA, fleetsEOA, human, aiOwner, other] =
      await hre.viem.getWalletClients();

    const ships = await hre.viem.deployContract("Ships", [
      owner.account.address, // dummy metadata renderer, never called in these tests
    ]);
    const aiShips = await hre.viem.deployContract("AIShips", []);
    const shipAttributes = await hre.viem.deployContract("ShipAttributes", [
      ships.address,
    ]);
    const universalCredits = await hre.viem.deployContract("UniversalCredits");
    const droneEnergyCores = await hre.viem.deployContract("DroneEnergyCores");
    const mockLobbyCheck = await hre.viem.deployContract(
      "MockLobbiesOrchestratorCheck",
    );

    const randomManager = await hre.viem.deployContract("RandomManager");

    const destroyRewardLib = await hre.viem.deployContract("DestroyRewardLib");
    const shipsRouter = await hre.viem.deployContract(
      "ShipsRouter",
      [ships.address, aiShips.address, universalCredits.address, droneEnergyCores.address],
      { libraries: { DestroyRewardLib: destroyRewardLib.address } },
    );

    // Mirrors DeployAndConfig.ts's production wiring: Ships.sol whitelists
    // the router (not Game.sol/Fleets.sol directly) for gameAddress/
    // fleetsAddress, since it's the router that calls Ships.sol now.
    await ships.write.setConfig([
      shipsRouter.address, // gameAddress
      mockLobbyCheck.address, // lobbyAddress
      shipsRouter.address, // fleetsAddress
      zeroAddress, // shipGenerator (unused here)
      randomManager.address,
      zeroAddress, // metadataRenderer (unused here)
      shipAttributes.address,
      universalCredits.address,
      droneEnergyCores.address,
    ]);
    await ships.write.setIsAllowedToCreateShips([owner.account.address, true]);

    await aiShips.write.setShipAttributesAddress([shipAttributes.address]);
    await aiShips.write.setRouter([shipsRouter.address]);
    await aiShips.write.setIsAllowedToCreateShips([owner.account.address, true]);

    await shipsRouter.write.setGameAddress([gameEOA.account.address]);
    await shipsRouter.write.setFleetsAddress([fleetsEOA.account.address]);
    await shipsRouter.write.setLobbyAddress([mockLobbyCheck.address]);

    await universalCredits.write.setMintIsActive([true]);
    await universalCredits.write.setAuthorizedToMint([shipsRouter.address, true]);
    await droneEnergyCores.write.setMintIsActive([true]);
    await droneEnergyCores.write.setAuthorizedToMint([shipsRouter.address, true]);

    // mockLobbyCheck.isSinglePlayerOrchestrator(x) == (x == aiOwner) — the
    // AI's ships are always "owned" by this address in this test, same
    // pattern as SinglePlayerMatch.isSinglePlayerOrchestrator in production.
    await mockLobbyCheck.write.setAiOrchestrator([aiOwner.account.address]);

    const gameRouter = await hre.viem.getContractAt(
      "ShipsRouter",
      shipsRouter.address,
      { client: { wallet: gameEOA } },
    );
    const fleetsRouter = await hre.viem.getContractAt(
      "ShipsRouter",
      shipsRouter.address,
      { client: { wallet: fleetsEOA } },
    );
    const otherRouter = await hre.viem.getContractAt(
      "ShipsRouter",
      shipsRouter.address,
      { client: { wallet: other } },
    );

    return {
      ships,
      aiShips,
      shipsRouter,
      gameRouter,
      fleetsRouter,
      otherRouter,
      universalCredits,
      droneEnergyCores,
      mockLobbyCheck,
      owner,
      gameEOA,
      fleetsEOA,
      human,
      aiOwner,
      other,
    };
  }

  const defaultEquipment = { mainWeapon: 0, armor: 0, shields: 0, special: 0 };
  const defaultTraits = {
    serialNumber: 0n,
    colors: { h1: 0, s1: 0, l1: 0, h2: 0, s2: 0, l2: 0, h3: 0, s3: 0, l3: 0 },
    variant: 1,
    accuracy: 0,
    hull: 0,
    speed: 0,
  };
  const shipData = {
    shipsDestroyed: 0,
    costsVersion: 0,
    cost: 0,
    modified: 0,
    shiny: false,
    constructed: false,
    inFleet: false,
    isFreeShip: false,
    timestampDestroyed: 0n,
  };

  async function mintHumanShip(ships: any, to: `0x${string}`, name: string) {
    await ships.write.createSpecificShip([
      to,
      { name, id: 0n, equipment: defaultEquipment, traits: defaultTraits, shipData, owner: zeroAddress },
    ]);
    return await ships.read.shipCount();
  }

  async function allocateAiShip(aiShips: any, to: `0x${string}`, name: string) {
    await aiShips.write.allocateShip([
      to,
      { name, id: 0n, equipment: defaultEquipment, traits: defaultTraits, shipData, owner: zeroAddress },
    ]);
    return AI_SHIP_ID_OFFSET + (await aiShips.read.slotCount());
  }

  describe("getShip / isShipDestroyed dispatch", function () {
    it("resolves a human id against Ships.sol and an AI id against AIShips.sol", async function () {
      const { ships, aiShips, shipsRouter, human, aiOwner } =
        await loadFixture(deployFixture);

      const humanId = await mintHumanShip(ships, human.account.address, "Human Ship");
      const aiId = await allocateAiShip(aiShips, aiOwner.account.address, "AI Ship");

      const viaRouterHuman = await shipsRouter.read.getShip([humanId]);
      expect(viaRouterHuman.name).to.equal("Human Ship");
      expect(viaRouterHuman.owner.toLowerCase()).to.equal(
        human.account.address.toLowerCase(),
      );

      const viaRouterAi = await shipsRouter.read.getShip([aiId]);
      expect(viaRouterAi.name).to.equal("AI Ship");
      expect(viaRouterAi.owner.toLowerCase()).to.equal(
        aiOwner.account.address.toLowerCase(),
      );

      expect(await shipsRouter.read.isShipDestroyed([humanId])).to.equal(false);
      expect(await shipsRouter.read.isShipDestroyed([aiId])).to.equal(false);
    });
  });

  describe("setInFleet", function () {
    it("reverts when called by anyone other than owner or the configured fleetsAddress", async function () {
      const { otherRouter, ships, human } = await loadFixture(deployFixture);
      const humanId = await mintHumanShip(ships, human.account.address, "Ship");

      await expect(
        otherRouter.write.setInFleet([humanId, true]),
      ).to.be.rejectedWith("NotAuthorized");
    });

    it("dispatches to Ships.sol for a human id and AIShips.sol for an AI id", async function () {
      const { fleetsRouter, ships, aiShips, human, aiOwner } =
        await loadFixture(deployFixture);
      const humanId = await mintHumanShip(ships, human.account.address, "Ship");
      const aiId = await allocateAiShip(aiShips, aiOwner.account.address, "AI Ship");

      await fleetsRouter.write.setInFleet([humanId, true]);
      await fleetsRouter.write.setInFleet([aiId, true]);

      expect((await ships.read.getShip([humanId])).shipData.inFleet).to.equal(
        true,
      );
      expect((await aiShips.read.getShip([aiId])).shipData.inFleet).to.equal(
        true,
      );
    });
  });

  describe("setTimestampDestroyed", function () {
    it("reverts when called by anyone other than owner or the configured gameAddress", async function () {
      const { otherRouter, ships, human } = await loadFixture(deployFixture);
      const humanId = await mintHumanShip(ships, human.account.address, "Ship");

      await expect(
        otherRouter.write.setTimestampDestroyed([humanId, humanId]),
      ).to.be.rejectedWith("NotAuthorized");
    });

    it("pays the destroyer DEC (not UTC) when a human ship destroys an AI-owned ship", async function () {
      const { gameRouter, ships, aiShips, universalCredits, droneEnergyCores, human, aiOwner } =
        await loadFixture(deployFixture);

      const humanId = await mintHumanShip(ships, human.account.address, "Human Ship");
      const aiId = await allocateAiShip(aiShips, aiOwner.account.address, "AI Ship");

      const recycleReward = await ships.read.recycleReward();
      await gameRouter.write.setTimestampDestroyed([aiId, humanId]);

      expect(await aiShips.read.isShipDestroyed([aiId])).to.equal(true);
      expect(
        await droneEnergyCores.read.balanceOf([human.account.address]),
      ).to.equal(recycleReward >> 2n);
      expect(
        await universalCredits.read.balanceOf([human.account.address]),
      ).to.equal(0n);

      const humanShip = await ships.read.getShip([humanId]);
      expect(humanShip.shipData.shipsDestroyed).to.equal(1);
    });

    it("pays the destroyer UTC (not DEC) when an AI ship destroys a human-owned ship", async function () {
      const { gameRouter, ships, aiShips, universalCredits, droneEnergyCores, human, aiOwner } =
        await loadFixture(deployFixture);

      const humanId = await mintHumanShip(ships, human.account.address, "Human Ship");
      const aiId = await allocateAiShip(aiShips, aiOwner.account.address, "AI Ship");

      const recycleReward = await ships.read.recycleReward();
      await gameRouter.write.setTimestampDestroyed([humanId, aiId]);

      expect((await ships.read.getShip([humanId])).shipData.timestampDestroyed).to.not.equal(0n);
      expect(
        await universalCredits.read.balanceOf([aiOwner.account.address]),
      ).to.equal(recycleReward >> 2n);
      expect(
        await droneEnergyCores.read.balanceOf([aiOwner.account.address]),
      ).to.equal(0n);

      const aiShip = await aiShips.read.getShip([aiId]);
      expect(aiShip.shipData.shipsDestroyed).to.equal(1);
    });

    it("still pays UTC correctly for a pure human-vs-human (PvP) kill", async function () {
      const { gameRouter, ships, universalCredits, droneEnergyCores, human, other } =
        await loadFixture(deployFixture);

      const destroyedId = await mintHumanShip(ships, human.account.address, "Victim");
      const destroyerId = await mintHumanShip(ships, other.account.address, "Attacker");

      const recycleReward = await ships.read.recycleReward();
      await gameRouter.write.setTimestampDestroyed([destroyedId, destroyerId]);

      expect(
        await universalCredits.read.balanceOf([other.account.address]),
      ).to.equal(recycleReward >> 2n);
      expect(
        await droneEnergyCores.read.balanceOf([other.account.address]),
      ).to.equal(0n);
    });
  });

  describe("dead-in-production passthroughs", function () {
    it("createSpecificShip reverts through the router since it is deliberately never whitelisted on Ships.sol", async function () {
      const { shipsRouter, human } = await loadFixture(deployFixture);

      await expect(
        shipsRouter.write.createSpecificShip([
          human.account.address,
          { name: "x", id: 0n, equipment: defaultEquipment, traits: defaultTraits, shipData, owner: zeroAddress },
        ]),
      ).to.be.rejectedWith("NotAuthorized");
    });

    it("maxVariant/recycleReward passthrough to Ships.sol's own values", async function () {
      const { shipsRouter, ships } = await loadFixture(deployFixture);

      expect(await shipsRouter.read.maxVariant()).to.equal(
        await ships.read.maxVariant(),
      );
      expect(await shipsRouter.read.recycleReward()).to.equal(
        await ships.read.recycleReward(),
      );
    });
  });
});
