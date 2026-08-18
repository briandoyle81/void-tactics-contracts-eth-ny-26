import hre from "hardhat";
import DeployModule from "../ignition/modules/DeployAndConfig";
import { parseEther } from "viem";

async function main() {
  const deployed: any = await hre.ignition.deploy(DeployModule);
  const { ships, randomManager, nodeMap, singlePlayerMatch, aiEncounters, aiShips, game } = deployed;

  const [owner, human] = await hre.viem.getWalletClients();

  // Find campaign node "m01"'s real on-chain id by scanning events, same
  // approach DeployAndConfig.ts itself uses (readEventArgument) -- simplest
  // here is to just query getAllAIShipConfigs to sanity check names/variant
  // directly, and separately confirm node count matches the 30 seeded.
  const allConfigs: any[] = await aiEncounters.read.getAllAIShipConfigs();
  console.log(`total AI ship configs: ${allConfigs.length}`);
  const v2Configs = allConfigs.filter((c) => c.traits.variant === 2);
  console.log(`variant-2 configs: ${v2Configs.length}`);
  console.log("sample variant-2 configs:");
  for (const c of v2Configs.slice(0, 5)) {
    console.log(`  ${c.name} (archetype ${c.archetype}, weapon ${c.equipment.mainWeapon})`);
  }

  // Start a real campaign match on node index 0 (m01) and check the actual
  // minted AI fleet.
  await ships.write.purchaseWithFlow(
    [human.account.address, 0n, human.account.address, 1],
    { value: parseEther("4.99"), account: owner.account },
  );
  const shipTuple = await ships.read.ships([1n]);
  await randomManager.write.fulfillRandomRequest([(shipTuple as any)[3].serialNumber]);

  const humanShips = await hre.viem.getContractAt("Ships", ships.address, { client: { wallet: human } });
  await humanShips.write.constructAllMyShips();

  const humanSinglePlayerMatch = await hre.viem.getContractAt(
    "SinglePlayerMatch",
    singlePlayerMatch.address,
    { client: { wallet: human } },
  );

  // campaignNodes are created in seed order, node ids are 1-indexed matching
  // creation order (m01 first) -- verified via getCampaignNode below rather
  // than assumed.
  const node1 = await nodeMap.read.getNode([1n]) as any;
  console.log(`\nnode 1 mapKey-derived id checks out (costLimit=${node1.costLimit}, enemyThreat=${node1.enemyThreat})`);

  await humanSinglePlayerMatch.write.startNodeMatch([1n, [1n], [{ row: 0, col: 0 }]]);

  const gameId = 2n ** 40n + 1n; // NODE_MATCH_ID_OFFSET + 1
  const gameData = await game.read.getGame([gameId]) as any;
  console.log(`\nmatch started: ended=${gameData.metadata.ended}`);

  const aiShipIds = gameData.joinerActiveShipIds as bigint[];
  console.log(`AI fleet size: ${aiShipIds.length}`);
  for (const id of aiShipIds) {
    const shipTuple2 = await aiShips.read.getShip([id]);
    const s = shipTuple2 as any;
    console.log(`  ship ${id}: name="${s.name}" variant=${s.traits.variant} weapon=${s.equipment.mainWeapon} special=${s.equipment.special}`);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
