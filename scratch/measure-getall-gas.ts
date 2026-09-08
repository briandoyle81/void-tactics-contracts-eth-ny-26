// One-off measurement for the GR-02 discussion (docs/pre-audit.md) — how
// much do AIEncounters.getAllAIShipConfigs() and Maps.getAllPresetMapIds()
// actually cost as their global counters grow? Run with:
//   npx hardhat run scratch/measure-getall-gas.ts
import hre from "hardhat";
import { MapMode } from "../test/types";

const defaultTraits = {
  serialNumber: 0n,
  colors: { h1: 0, s1: 0, l1: 0, h2: 0, s2: 0, l2: 0, h3: 0, s3: 0, l3: 0 },
  variant: 1,
  accuracy: 0,
  hull: 0,
  speed: 0,
};
const defaultEquipment = { mainWeapon: 0, armor: 0, shields: 0, special: 0 };
const defaultArchetype = 0;

async function main() {
  const [account] = await hre.viem.getWalletClients();
  const publicClient = await hre.viem.getPublicClient();

  // --- AIEncounters.getAllAIShipConfigs ---
  const maps1 = await hre.viem.deployContract("Maps", []);
  const aiEncounters = await hre.viem.deployContract("AIEncounters", [
    maps1.address,
  ]);

  const configSampleSizes = [10, 50, 100, 200, 400];
  let configsCreated = 0;
  for (const target of configSampleSizes) {
    while (configsCreated < target) {
      await aiEncounters.write.createAIShipConfig([
        "Scout",
        defaultEquipment,
        defaultTraits,
        defaultArchetype,
      ]);
      configsCreated++;
    }
    const gas = await publicClient.estimateContractGas({
      address: aiEncounters.address,
      abi: aiEncounters.abi,
      functionName: "getAllAIShipConfigs",
      account: account.account,
    });
    console.log(
      `AIEncounters configs=${target}\tgetAllAIShipConfigs() gas=${gas}\tgas/config=${(
        Number(gas) / target
      ).toFixed(1)}`,
    );
  }

  // --- Maps.getAllPresetMapIds ---
  const maps2 = await hre.viem.deployContract("Maps", []);
  const mapSampleSizes = [10, 50, 100, 200, 400];
  let mapsCreated = 0;
  for (const target of mapSampleSizes) {
    while (mapsCreated < target) {
      await maps2.write.createPresetMap([[], MapMode.Both]);
      mapsCreated++;
    }
    const gas = await publicClient.estimateContractGas({
      address: maps2.address,
      abi: maps2.abi,
      functionName: "getAllPresetMapIds",
      account: account.account,
    });
    console.log(
      `Maps mapCount=${target}\tgetAllPresetMapIds() gas=${gas}\tgas/map=${(
        Number(gas) / target
      ).toFixed(1)}`,
    );
  }
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
