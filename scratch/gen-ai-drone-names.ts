import hre from "hardhat";
import { keccak256, encodePacked } from "viem";
import fs from "fs";
import path from "path";

async function main() {
  const droneNames = await hre.viem.deployContract("DroneNames", []);

  const dataPath = path.join(__dirname, "..", "ignition", "data", "singlePlayerStarterContent.json");
  const data = JSON.parse(fs.readFileSync(dataPath, "utf8"));

  const used = new Set<string>();

  for (const config of data.aiShipConfigs) {
    let attempt = 0;
    let name = "";
    for (;;) {
      const seed = keccak256(
        encodePacked(["string", "uint256"], [config.key, BigInt(attempt)]),
      );
      name = await droneNames.read.getRandomDroneName([seed, config.equipment.mainWeapon]);
      if (!used.has(name)) break;
      attempt++;
    }
    used.add(name);
    console.log(`${config.key.padEnd(12)} ${config.name.padEnd(16)} -> ${name}`);
    config.name = name;
  }

  fs.writeFileSync(dataPath, JSON.stringify(data, null, 2) + "\n");
  console.log(`\nWrote ${data.aiShipConfigs.length} updated names to ${dataPath}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
