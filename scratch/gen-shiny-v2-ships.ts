import hre from "hardhat";
import fs from "fs";
import { deployShipsFixture } from "../test/fixtures/deployShipsFixture";

async function main() {
  const { generateNewShip, imageRendererV2 } = await deployShipsFixture();

  const results: any[] = [];
  let id = 1n;
  let randomBase = 1000n;

  while (results.length < 20) {
    const ship: any = await generateNewShip.read.generateShip([
      id,
      id, // serialNumber, doesn't need to be unique for this sampling script
      randomBase,
      2, // variant 2
    ]);
    randomBase += 97n; // arbitrary stride so consecutive draws don't overlap

    if (ship.shipData.shiny) {
      const constructedShip = {
        ...ship,
        shipData: { ...ship.shipData, constructed: true },
      };
      const uri: string = await imageRendererV2.read.renderShip([
        constructedShip,
      ]);
      const svg = Buffer.from(
        uri.replace("data:image/svg+xml;base64,", ""),
        "base64",
      ).toString("utf8");

      results.push({
        id: id.toString(),
        name: ship.name,
        weapon: ship.equipment.mainWeapon,
        armor: ship.equipment.armor,
        shields: ship.equipment.shields,
        special: ship.equipment.special,
        accuracy: ship.traits.accuracy,
        hull: ship.traits.hull,
        speed: ship.traits.speed,
        shipsDestroyed: ship.shipData.shipsDestroyed,
        svg,
      });
      console.log(`[${results.length}/20] ${ship.name}`);
    }
    id += 1n;
  }

  fs.writeFileSync(
    "/private/tmp/claude-501/-Users-briandoyle-void-tactics-contracts-eth-ny-26/d7ff2b7d-7241-4f30-bec2-dc23879cebd3/scratchpad/shiny-v2-ships.json",
    JSON.stringify(results, null, 2),
  );
  console.log(`wrote ${results.length} shiny variant-2 ships`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
