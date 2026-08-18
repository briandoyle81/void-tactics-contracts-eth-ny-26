import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import { parseEther, zeroAddress } from "viem";
import { deployShipsFixture } from "./fixtures/deployShipsFixture";
import { ShipTuple, tupleToShip } from "./types";

// Variant 2 (faction 2) has no art of its own yet -- see
// scripts/renderer-pipeline/ for the automation that will eventually
// generate a real ImageRendererV2 from a Photoshop source file. Until then,
// DeployAndConfig.ts wires variant 1's ImageRenderer in as a placeholder for
// both slots so tokenURI keeps working for variant-2 ships. These tests
// cover the wiring itself (RenderMetadata actually dispatches on
// ship.traits.variant, both slots are populated), not the art -- once real
// variant-2 art ships, the "placeholder" assertion below is expected to
// need updating.
describe("RenderMetadata variant dispatch", function () {
  async function mintVariantShip(fixture: any, variant: number) {
    const { ships, shatteredHiveMedal, randomManager, owner, user1 } = fixture;

    if (variant === 2) {
      await shatteredHiveMedal.write.ownerMint([user1.account.address], {
        account: owner.account,
      });
    }

    const countBefore = await ships.read.shipCount();

    await ships.write.purchaseWithFlow(
      [user1.account.address, 0n, user1.account.address, variant],
      { value: parseEther("4.99") },
    );

    const countAfter = await ships.read.shipCount();
    const firstNewId = countBefore + 1n;

    for (let id = firstNewId; id <= countAfter; id++) {
      const shipTuple = (await ships.read.ships([id])) as ShipTuple;
      const ship = tupleToShip(shipTuple);
      await randomManager.write.fulfillRandomRequest([ship.traits.serialNumber]);
    }

    await ships.write.constructAllMyShips({ account: user1.account });

    return firstNewId;
  }

  it("wires both a variant-1 and a variant-2 image renderer into RenderMetadata", async function () {
    const { metadataRenderer, imageRenderer } = await loadFixture(deployShipsFixture);

    const v1 = await metadataRenderer.read.imageRenderer();
    const v2 = await metadataRenderer.read.imageRendererV2();

    expect(v1.toLowerCase()).to.not.equal(zeroAddress);
    expect(v2.toLowerCase()).to.not.equal(zeroAddress);
    expect(v1.toLowerCase()).to.equal(imageRenderer.address.toLowerCase());

    // Documents today's placeholder: variant 2 has no art yet, so it reuses
    // variant 1's ImageRenderer rather than reverting on tokenURI.
    expect(v2.toLowerCase()).to.equal(imageRenderer.address.toLowerCase());
  });

  it("renders a valid SVG data URI for a variant-1 ship", async function () {
    const fixture = await loadFixture(deployShipsFixture);
    const { ships } = fixture;

    const id = await mintVariantShip(fixture, 1);
    const ship = tupleToShip((await ships.read.ships([id])) as ShipTuple);
    expect(ship.traits.variant).to.equal(1);

    const uri = await ships.read.tokenURI([id]);
    const json = JSON.parse(
      Buffer.from(uri.replace("data:application/json;base64,", ""), "base64").toString("utf8"),
    );
    expect(json.image).to.match(/^data:image\/svg\+xml;base64,/);

    const svg = Buffer.from(
      json.image.replace("data:image/svg+xml;base64,", ""),
      "base64",
    ).toString("utf8");
    expect(svg).to.match(/^<svg/);
    expect(svg).to.match(/<\/svg>$/);
  });

  it("renders a valid SVG data URI for a variant-2 ship via the wired-in imageRendererV2 path", async function () {
    const fixture = await loadFixture(deployShipsFixture);
    const { ships } = fixture;

    const id = await mintVariantShip(fixture, 2);
    const ship = tupleToShip((await ships.read.ships([id])) as ShipTuple);
    expect(ship.traits.variant).to.equal(2);

    const uri = await ships.read.tokenURI([id]);
    const json = JSON.parse(
      Buffer.from(uri.replace("data:application/json;base64,", ""), "base64").toString("utf8"),
    );
    expect(json.image).to.match(/^data:image\/svg\+xml;base64,/);

    const svg = Buffer.from(
      json.image.replace("data:image/svg+xml;base64,", ""),
      "base64",
    ).toString("utf8");
    expect(svg).to.match(/^<svg/);
    expect(svg).to.match(/<\/svg>$/);
  });
});
