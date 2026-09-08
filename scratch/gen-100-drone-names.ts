import hre from "hardhat";
import { keccak256, encodePacked } from "viem";
import fs from "fs";

async function main() {
  const droneNames = await hre.viem.deployContract("DroneNames", []);

  const weapons = [
    { idx: 0, label: "Laser", display: "Medium Mining Laser" },
    { idx: 1, label: "Railgun", display: "Linear Accelerator" },
    { idx: 2, label: "MissileLauncher", display: "Torpedo Launcher" },
    { idx: 3, label: "PlasmaCannon", display: "Mining Drill" },
  ];

  const results: { weapon: string; display: string; name: string }[] = [];

  for (const w of weapons) {
    for (let i = 0; i < 25; i++) {
      const seed = keccak256(
        encodePacked(["uint256", "uint8"], [BigInt(i * 104729 + 999983), w.idx]),
      );
      const name = await droneNames.read.getRandomDroneName([seed, w.idx]);
      results.push({ weapon: w.label, display: w.display, name });
    }
  }

  fs.writeFileSync(
    "/private/tmp/claude-501/-Users-briandoyle-void-tactics-contracts-eth-ny-26/d7ff2b7d-7241-4f30-bec2-dc23879cebd3/scratchpad/drone-names-100.json",
    JSON.stringify(results, null, 2),
  );
  console.log(`wrote ${results.length} names`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
