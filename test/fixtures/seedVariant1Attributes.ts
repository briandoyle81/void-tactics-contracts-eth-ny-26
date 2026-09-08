/**
 * Seeds variant 1's Costs + VariantAttributeData on a standalone-deployed
 * ShipAttributes contract (i.e. one deployed directly via
 * hre.viem.deployContract, bypassing the full Ignition DeployModule).
 *
 * ShipAttributes' constructor deliberately seeds no variant — every
 * variant, including 1, is unconfigured (fails loud) until setCosts/
 * setVariantAttributes are called, same as production deployment does via
 * ignition/modules/DeployAndConfig.ts's setCostsVariant1Call/
 * setVariant1AttributesCall. Mirrors those exact values so standalone unit
 * tests see the same defaults the real deploy produces.
 */
export async function seedVariant1Attributes(
  shipAttributes: any,
  ownerAccount: { address: `0x${string}` },
) {
  await shipAttributes.write.setCosts(
    [
      1,
      {
        version: 0,
        baseCost: 50,
        accuracy: [0, 10, 25],
        hull: [0, 10, 25],
        speed: [0, 10, 25],
        mainWeapon: [25, 30, 40, 40],
        armor: [0, 5, 10, 15],
        shields: [0, 10, 20, 30],
        special: [0, 10, 20, 15, 15, 20, 10, 0],
      },
    ],
    { account: ownerAccount },
  );

  await shipAttributes.write.setVariantAttributes(
    [
      {
        version: 1,
        variant: 1,
        baseHull: 100,
        baseSpeed: 3,
        foreAccuracy: [0, 25, 50],
        hull: [0, 10, 20],
        engineSpeeds: [0, 1, 2],
        guns: [
          { range: 3, damage: 50, movement: 0 }, // Laser
          { range: 6, damage: 40, movement: 0 }, // Railgun
          { range: 4, damage: 60, movement: -1 }, // MissileLauncher
          { range: 2, damage: 80, movement: 0 }, // PlasmaCannon
        ],
        armors: [
          { damageReduction: 0, movement: 1 }, // None
          { damageReduction: 15, movement: 0 }, // Light
          { damageReduction: 30, movement: -1 }, // Medium
          { damageReduction: 45, movement: -2 }, // Heavy
        ],
        shields: [
          { damageReduction: 0, movement: 1 }, // None
          { damageReduction: 15, movement: 1 }, // Light
          { damageReduction: 30, movement: 0 }, // Medium
          { damageReduction: 45, movement: -1 }, // Heavy
        ],
        specials: [
          { range: 0, strength: 0, movement: 0 }, // None
          { range: 1, strength: 1, movement: 0 }, // EMP
          { range: 3, strength: 40, movement: 0 }, // RepairDrones
          { range: 3, strength: 30, movement: 0 }, // FlakArray
          { range: 0, strength: 0, movement: 0 }, // ElectricStorm (inert for variant 1)
          { range: 0, strength: 0, movement: 0 }, // DroneSwarm (inert for variant 1)
          { range: 0, strength: 0, movement: 0 }, // AdditionalThruster (inert for variant 1)
          { range: 0, strength: 0, movement: 0 }, // future4
        ],
      },
    ],
    { account: ownerAccount },
  );
}
