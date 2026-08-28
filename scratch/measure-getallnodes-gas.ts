// One-off measurement for the GR-02 discussion (docs/pre-audit.md) — how
// much does NodeMap.getAllNodes() actually cost as node count grows, and at
// what count does it become unaffordable? Run with:
//   npx hardhat run scratch/measure-getallnodes-gas.ts
import hre from "hardhat";
import { MapMode } from "../test/types";

async function main() {
  const maps = await hre.viem.deployContract("Maps", []);
  const nodeMap = await hre.viem.deployContract("NodeMap", [maps.address]);
  const publicClient = await hre.viem.getPublicClient();

  await nodeMap.write.createCampaign();
  await maps.write.createPresetMap([[], MapMode.Both]);

  const sampleSizes = [10, 50, 100, 200, 400];
  let created = 0;

  for (const target of sampleSizes) {
    while (created < target) {
      await nodeMap.write.createNode([1n, 1n, [], 2000n, 600n, 20n, true]);
      created++;
    }

    const gas = await publicClient.estimateContractGas({
      address: nodeMap.address,
      abi: nodeMap.abi,
      functionName: "getAllNodes",
      account: (await hre.viem.getWalletClients())[0].account,
    });

    console.log(
      `nodes=${target}\tgetAllNodes() gas=${gas}\tgas/node=${(
        Number(gas) / target
      ).toFixed(1)}`,
    );
  }
}

main().catch((e) => {
  console.error(e);
  process.exitCode = 1;
});
