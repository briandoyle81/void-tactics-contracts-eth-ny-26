import hre from "hardhat";
import { keccak256, encodePacked } from "viem";
import fs from "fs";
import path from "path";

async function main() {
  const droneNames = await hre.viem.deployContract("DroneNames", []);

  const dataPath = path.join(__dirname, "..", "ignition", "data", "singlePlayerStarterContent.json");
  const data = JSON.parse(fs.readFileSync(dataPath, "utf8"));

  const originalConfigs = data.aiShipConfigs;
  const keyMap: Record<string, string> = {}; // old key -> new v2 key
  const newConfigs: any[] = [];
  const used = new Set<string>();

  for (const config of originalConfigs) {
    const newKey = `v2${config.key}`;
    keyMap[config.key] = newKey;

    let attempt = 0;
    let name = "";
    for (;;) {
      const seed = keccak256(
        encodePacked(["string", "uint256"], [newKey, BigInt(attempt)]),
      );
      name = await droneNames.read.getRandomDroneName([seed, config.equipment.mainWeapon]);
      if (!used.has(name)) break;
      attempt++;
    }
    used.add(name);

    // Support's heal now comes from variant 2's innate faction ability
    // (RepairResolver), not an equipped Special -- variant 1's "support*"
    // configs equip Special.Slot2 (RepairDrones); the variant-2 equivalents
    // equip nothing (their archetype alone routes them through
    // AIBehavior.decideSupport, which now checks myVariant == 2 for the
    // faction-ability heal instead of mySpecial == Special.Slot2).
    const equipment = { ...config.equipment, special: 0 };

    newConfigs.push({
      key: newKey,
      name,
      equipment,
      traits: { ...config.traits, variant: 2 },
      archetype: config.archetype,
    });

    console.log(`${config.key.padEnd(12)} -> ${newKey.padEnd(14)} ${name}`);
  }

  data.aiShipConfigs = [...originalConfigs, ...newConfigs];

  let replacedCount = 0;
  for (const placement of data.mapPlacements) {
    placement.configKeys = placement.configKeys.map((k: string) => {
      replacedCount++;
      return keyMap[k];
    });
  }

  fs.writeFileSync(dataPath, JSON.stringify(data, null, 2) + "\n");
  console.log(
    `\nAdded ${newConfigs.length} variant-2 configs; repointed ${replacedCount} mapPlacement configKey references across ${data.mapPlacements.length} maps.`,
  );
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
