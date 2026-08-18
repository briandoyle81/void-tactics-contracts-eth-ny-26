import hre from "hardhat";
import { keccak256, encodePacked } from "viem";

async function main() {
  const droneNames = await hre.viem.deployContract("DroneNames", []);

  const weapons = [
    { idx: 0, label: "Laser (Medium Mining Laser)" },
    { idx: 1, label: "Railgun (Linear Accelerator)" },
    { idx: 2, label: "MissileLauncher (Torpedo Launcher)" },
    { idx: 3, label: "PlasmaCannon (Mining Drill)" },
  ];

  for (const w of weapons) {
    console.log(`\n=== ${w.label} ===`);
    for (let i = 0; i < 15; i++) {
      const seed = keccak256(encodePacked(["uint256", "uint8"], [BigInt(i * 7919 + 12345), w.idx]));
      const name = await droneNames.read.getRandomDroneName([seed, w.idx]);
      console.log(name);
    }
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
