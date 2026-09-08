// Extended follow-up to measure-getall-gas.ts — pins down the actual
// breaking point for AIEncounters.getAllAIShipConfigs() against Base's
// 30,000,000 block gas limit, since the earlier 10-400 sample showed a
// clearly increasing (super-linear) marginal cost per config, not flat.
// Run with: npx hardhat run scratch/measure-getall-gas-extended.ts
import hre from "hardhat";

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
  const maps1 = await hre.viem.deployContract("Maps", []);
  const aiEncounters = await hre.viem.deployContract("AIEncounters", [
    maps1.address,
  ]);

  const sampleSizes = [600, 800, 1000, 1200];
  let created = 0;
  for (const target of sampleSizes) {
    while (created < target) {
      await aiEncounters.write.createAIShipConfig([
        "Scout",
        defaultEquipment,
        defaultTraits,
        defaultArchetype,
      ]);
      created++;
    }
    const gas = await publicClient.estimateContractGas({
      address: aiEncounters.address,
      abi: aiEncounters.abi,
      functionName: "getAllAIShipConfigs",
      account: account.account,
    });
    console.log(
      `configs=${target}\tgas=${gas}\tgas/config=${(
        Number(gas) / target
      ).toFixed(1)}\tover30M=${gas > 30000000n}`,
    );
  }
}
main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
