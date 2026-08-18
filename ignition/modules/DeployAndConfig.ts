// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseEther } from "viem";
import starterContent from "../data/singlePlayerStarterContent.json";

// Set to true only for a real production deploy. Every test fixture deploys
// this same module via hre.ignition.deploy(DeployModule), and steps gated
// behind this flag (e.g. transferring contract ownership away from the
// deployer) would break owner-gated test setup if they ran unconditionally
// — this is a plain build-time boolean (not an Ignition parameter) so gated
// m.call(...) invocations are simply never added to the deployment graph
// when false, rather than being skipped at execution time.
const PRODUCTION = false;

// Address allowed to mint ships from the Firebase Flow backend, with the same
// rights as ShipPurchaser.
const FIREBASE_FLOW_MINTER = "0x7f9dc2D68FF842EC79DA722B68E3ca7e5aa31CCb";

// Address allowed to create/edit preset maps (in addition to the owner). Lets
// map editing be done from a wallet other than the deployer/owner.
const MAP_EDITOR = "0x69a5B3aE8598fC5A5419eaa1f2A59Db2D052e346";

// groupId 1 == Orb (the only credential type supported for on-chain verification).
const TOURNAMENT_WORLD_ID_GROUP = 1n;

// externalNullifier = hashToField(abi.encodePacked(hashToField(appId), action)),
// matching what IDKit uses in the frontend. Computed from:
//   app_id = "app_b2739b54eb71ceb8c76380c60c20ce22"
//   action = "join-tournament"
// (see scripts/computeExternalNullifier.ts for the derivation). If the app_id or action
// changes, recompute and update this, or call Tournament.setExternalNullifier(...).
const TOURNAMENT_EXTERNAL_NULLIFIER =
  318078722027557965998987370672697888390534537434722412480399796468873891570n;

const DeployModule = buildModule("DeployModule", (m) => {
  // Deploy helper contracts first
  const randomManager = m.contract("RandomManager");

  // Deploy all sub-renderers
  const renderSpecial1 = m.contract("RenderSpecial1");
  const renderSpecial2 = m.contract("RenderSpecial2");
  const renderSpecial3 = m.contract("RenderSpecial3");

  const renderAft0 = m.contract("RenderAft0");
  const renderAft1 = m.contract("RenderAft1");
  const renderAft2 = m.contract("RenderAft2");

  const renderWeapon1 = m.contract("RenderWeapon1");
  const renderWeapon2 = m.contract("RenderWeapon2");
  const renderWeapon3 = m.contract("RenderWeapon3");
  const renderWeapon4 = m.contract("RenderWeapon4");

  const renderFore0 = m.contract("RenderFore0");
  const renderFore1 = m.contract("RenderFore1");
  const renderFore2 = m.contract("RenderFore2");
  const renderForePerfect = m.contract("RenderForePerfect");
  const renderShield1 = m.contract("RenderShield1");
  const renderShield2 = m.contract("RenderShield2");
  const renderShield3 = m.contract("RenderShield3");

  const renderArmor1 = m.contract("RenderArmor1");
  const renderArmor2 = m.contract("RenderArmor2");
  const renderArmor3 = m.contract("RenderArmor3");

  const renderBaseBody = m.contract("RenderBaseBody");

  // Deploy main renderers that combine sub-renderers
  const renderSpecial = m.contract("RenderSpecial", [
    [renderSpecial1, renderSpecial2, renderSpecial3],
  ]);

  const renderAft = m.contract("RenderAft", [
    [renderAft0, renderAft1, renderAft2],
  ]);

  const renderWeapon = m.contract("RenderWeapon", [
    [renderWeapon1, renderWeapon2, renderWeapon3, renderWeapon4],
  ]);

  const renderBody = m.contract("RenderBody", [
    [
      renderBaseBody,
      renderShield1,
      renderShield2,
      renderShield3,
      renderArmor1,
      renderArmor2,
      renderArmor3,
    ],
  ]);

  const renderFore = m.contract("RenderFore", [
    [renderFore0, renderFore1, renderFore2, renderForePerfect],
  ]);

  // Deploy ImageRenderer with all main renderers
  const imageRenderer = m.contract("ImageRenderer", [
    renderSpecial,
    renderAft,
    renderWeapon,
    renderBody,
    renderFore,
  ]);

  // Deploy variant 2 (faction 2)'s own renderer set, generated from the real
  // variant-2-pixel.psd by scripts/renderer-pipeline/ (manifest.variant2.json
  // -> check-sizes.js -> gen-combiners.js). Same shape as variant 1's
  // sub-renderer/combiner/ImageRenderer deploy above, just against
  // contracts/RenderersV2 and ImageRendererV2.sol.
  const renderSpecial4V2 = m.contract("RenderSpecial4V2");
  const renderSpecial5V2 = m.contract("RenderSpecial5V2");
  const renderSpecial6V2 = m.contract("RenderSpecial6V2");

  const renderAft0V2 = m.contract("RenderAft0V2");
  const renderAft1V2 = m.contract("RenderAft1V2");
  const renderAft2V2 = m.contract("RenderAft2V2");

  const renderWeapon1V2 = m.contract("RenderWeapon1V2");
  const renderWeapon2V2 = m.contract("RenderWeapon2V2");
  const renderWeapon3V2 = m.contract("RenderWeapon3V2");
  const renderWeapon4V2 = m.contract("RenderWeapon4V2");

  const renderFore0V2 = m.contract("RenderFore0V2");
  const renderFore1V2 = m.contract("RenderFore1V2");
  const renderFore2V2 = m.contract("RenderFore2V2");
  const renderForePerfectV2 = m.contract("RenderForePerfectV2");
  const renderShield1V2 = m.contract("RenderShield1V2");
  const renderShield2V2 = m.contract("RenderShield2V2");
  const renderShield3V2 = m.contract("RenderShield3V2");

  const renderArmor1V2 = m.contract("RenderArmor1V2");
  const renderArmor2V2 = m.contract("RenderArmor2V2");
  const renderArmor3V2 = m.contract("RenderArmor3V2");

  const renderBaseBodyV2 = m.contract("RenderBaseBodyV2");

  const renderSpecialV2 = m.contract("RenderSpecialV2", [
    [renderSpecial4V2, renderSpecial5V2, renderSpecial6V2],
  ]);

  const renderAftV2 = m.contract("RenderAftV2", [
    [renderAft0V2, renderAft1V2, renderAft2V2],
  ]);

  const renderWeaponV2 = m.contract("RenderWeaponV2", [
    [renderWeapon1V2, renderWeapon2V2, renderWeapon3V2, renderWeapon4V2],
  ]);

  const renderBodyV2 = m.contract("RenderBodyV2", [
    [
      renderBaseBodyV2,
      renderShield1V2,
      renderShield2V2,
      renderShield3V2,
      renderArmor1V2,
      renderArmor2V2,
      renderArmor3V2,
    ],
  ]);

  const renderForeV2 = m.contract("RenderForeV2", [
    [renderFore0V2, renderFore1V2, renderFore2V2, renderForePerfectV2],
  ]);

  const imageRendererV2 = m.contract("ImageRendererV2", [
    renderSpecialV2,
    renderAftV2,
    renderWeaponV2,
    renderBodyV2,
    renderForeV2,
  ]);

  // Deploy MetadataRenderer with both factions' image renderers.
  const metadataRenderer = m.contract("RenderMetadata", [
    imageRenderer,
    imageRendererV2,
  ]);

  let shipNames: any;
  if (!PRODUCTION) {
    // Mock for local/tests — Ignition + viem require a contract future, not a string address.
    shipNames = m.contract("MockOnchainRandomShipNames");
  } else {
    // For Flow testnet use
    // shipNames = "0x9E433A07D283d56E8243EA25b7358521b1922df5";

    // For Ronin Saigon testnet use
    // shipNames = "0x3866a81241Ec61414a3A7A99486f6652fFd0743C";

    // For XAI testnet use
    // shipNames = "0xe7266c681ce3F8CD8853141139574F2CA70AA165";

    // For Base Sepolia testnet use
    shipNames = "0x2b6C2e73D7D8B9dd49aF848B7A19FF003ED0d779";
  }

  // DroneNames (variant-2's own deterministic name generator, distinct from
  // variant 1's real-world-style shipNames) is fully self-contained --
  // pure, no owner-configurable state -- so unlike shipNames it's always
  // deployed directly rather than pointed at an external address.
  const droneNames = m.contract("DroneNames");

  // Deploy GenerateNewShip with ship names
  const generateNewShip = m.contract("GenerateNewShip", [
    shipNames,
    droneNames,
  ]);

  // Deploy UniversalCredits token
  const universalCredits = m.contract("UniversalCredits");

  // Deploy DroneEnergyCores ("DEC"): freely transferable ERC20 reward token
  // minted when a player destroys an AI-owned ship
  // (Ships.setTimestampDestroyed via DestroyRewardLib), instead of UTC. Not
  // soulbound on purpose — see DroneEnergyCores.sol's header comment.
  const droneEnergyCores = m.contract("DroneEnergyCores");

  // Deploy DroneStorefront: where players turn in DEC for a permanent
  // free-ship claim bonus (see DroneStorefront.turnInCores).
  const droneStorefront = m.contract("DroneStorefront", [droneEnergyCores]);

  // Deploy DestroyRewardLib: decides UTC vs DEC for a kill reward, split
  // out for bytecode headroom (same reasoning as SpecialEffectsLib below)
  // — linked into ShipsRouter at deploy time, since that's the only
  // contract that can see both ships' owners regardless of whether they're
  // human (Ships.sol) or AI (AIShips.sol).
  const destroyRewardLib = m.library("DestroyRewardLib");

  // Finally deploy Ships with all dependencies
  const ships = m.contract("Ships", [metadataRenderer]);

  // Generic per-variant purchase gate registry (variant -> required NFT,
  // address(0) == ungated). Ships.sol calls into this unconditionally and
  // stays ignorant of which variants are gated or on what — future gated
  // variants (e.g. a third faction with its own campaign medal) only need
  // a setRequiredNft call here, not a Ships.sol change. Wired to require
  // the Shattered Hive Campaign medal for variant 2 further below, once
  // that medal contract (and the campaign's final node id) exist.
  const variantPurchaseGate = m.contract("VariantPurchaseGate");

  // Deploy AIShips: non-NFT, poolable store for single-player AI ships,
  // sitting behind ShipsRouter below instead of Ships.sol. AI ships are
  // never owned/traded by players, so this has no ERC-721/mint machinery —
  // allocateShip reuses a slot released by a previously-finished match when
  // one is available (see ShipsRouter/AIShips.sol header comments).
  const aiShips = m.contract("AIShips");

  // Deploy ShipAttributes contract (constructor arg stays Ships.sol's own
  // address; repointed at ShipsRouter below once it's deployed, since
  // single-player fleet-attribute lookups need to resolve both human and
  // AI ship ids)
  const shipAttributes = m.contract("ShipAttributes", [ships]);

  const setAiShipsShipAttributesCall = m.call(
    aiShips,
    "setShipAttributesAddress",
    [shipAttributes],
  );

  // Deploy ShipsRouter: the facade Game.sol/Fleets.sol/ShipAttributes talk
  // to instead of Ships.sol directly, so a single shipId space can resolve
  // against both Ships.sol (human) and AIShips.sol (AI) — see the
  // contract's header comment.
  const shipsRouter = m.contract(
    "ShipsRouter",
    [ships, aiShips, universalCredits, droneEnergyCores],
    { libraries: { DestroyRewardLib: destroyRewardLib } },
  );

  const setAiShipsRouterCall = m.call(aiShips, "setRouter", [shipsRouter]);

  const setShipAttributesShipsAddressCall = m.call(
    shipAttributes,
    "setShipsAddress",
    [shipsRouter],
  );

  // Deploy ShipPurchaser
  const shipPurchaser = m.contract("ShipPurchaser", [ships, universalCredits]);

  // Deploy DroneYard
  const droneYard = m.contract("DroneYard", [
    ships,
    universalCredits,
    shipPurchaser,
    shipNames,
  ]);

  // Deploy Maps contract
  const maps = m.contract("Maps");

  // Deploy AIEncounters: admin-curated single-player AI ship configs +
  // per-preset-map row/col placements, consumed by SinglePlayerMatch to
  // build the AI's fleet instead of a hardcoded template.
  const aiEncounters = m.contract("AIEncounters", [maps]);

  // Deploy NodeMap: admin-curated campaign graph for vs-AI matches — each
  // node curates its own map/costLimit/turnTime/maxScore/creatorGoesFirst,
  // with ANY-of prerequisite unlock semantics so branches/shortcuts are
  // possible. Entry point is SinglePlayerMatch.startNodeMatch; no Lobbies
  // involved.
  const nodeMap = m.contract("NodeMap", [maps]);

  // Deploy GameResults contract
  const gameResults = m.contract("GameResults");

  // Deploy SpecialEffectsLib: resolver-backed special dispatch + the
  // RepairDrones/EMP/FlakArray arithmetic, split out of Game.sol purely for
  // bytecode headroom (see the library's header comment). Linked into Game
  // at deploy time.
  const specialEffectsLib = m.library("SpecialEffectsLib");

  // Deploy Game contract with ShipAttributes. `ships` arg points at
  // ShipsRouter (not Ships.sol directly) so shipId resolution covers both
  // human and AI ships — Game.sol itself needs no source changes for this,
  // since it was already IShips-typed.
  const game = m.contract("Game", [shipsRouter, shipAttributes], {
    libraries: { SpecialEffectsLib: specialEffectsLib },
  });

  // Deploy Fleets contract, also pointed at ShipsRouter for the same reason
  const fleets = m.contract("Fleets", [shipsRouter]);

  // Deploy Lobbies contract
  const lobbies = m.contract("Lobbies", [ships]);

  // Deploy PvPMatch: the PvP-specific orchestration split out of Game.sol
  // (human forfeit/timeout, PvP leaderboard recording). Core Game.sol stays
  // mode-agnostic; this is what Lobbies talks to for starting/ending matches.
  const pvpMatch = m.contract("PvPMatch", [game, gameResults]);

  // Deploy SinglePlayerMatch: plays single-player matches as an on-chain AI
  // opponent, entered via NodeMap's campaign graph (startNodeMatch) — no
  // Lobbies involved. `lobbies` is kept as a legacy constructor arg only
  // (see the contract's header comment). First arg is AIShips.sol, not
  // Ships.sol — this contract's AI fleets are allocated from AIShips' pool.
  const singlePlayerMatch = m.contract("SinglePlayerMatch", [
    aiShips,
    lobbies,
    game,
    aiEncounters,
    maps,
    shipAttributes,
    nodeMap,
    fleets,
  ]);

  const tutorialClaim = m.contract("TutorialClaim", [ships, gameResults]);

  // Deploy FreeShipClaim: the recurring (28-day) free-ship claim, split out
  // of Ships.sol entirely (no bytecode headroom left there) — mints through
  // Ships' existing isAllowedToCreateShips allowlist, same as
  // DroneYard/ShipPurchaser/TutorialClaim.
  const freeShipClaim = m.contract("FreeShipClaim", [ships]);

  // Deploy RamResolver: the faction 1 innate ability (traits.variant == 1),
  // resolver-backed per IEffectResolver and dispatched via
  // ActionType.FactionAbility rather than the old
  // automatic-side-effect-of-movement ramming mechanic.
  const ramResolver = m.contract("RamResolver", [game]);

  // Deploy the equipped-Special resolvers: EMP/RepairDrones/FlakArray are
  // dispatched via Game.specialResolvers[variant][slot] (IEffectResolver),
  // the same resolver-backed pattern as RamResolver above, migrated off
  // their old hardcoded Game.sol/SpecialEffectsLib.sol branches so future
  // factions can add their own equipped Special without spending Game.sol
  // bytecode. Each reads range/strength from the shared per-variant
  // SpecialData table via shipAttributes, so numbers stay retunable via
  // ShipAttributes.setVariantAttributes without redeploying a resolver.
  // Special is a per-faction local slot (0-7), not a global identity, so
  // each resolver is told its own slot at deploy time (third constructor
  // arg) — these three happen to be faction 1's slots 1/2/3.
  const empResolver = m.contract("EMPResolver", [game, shipAttributes, 1]);
  const repairDronesResolver = m.contract("RepairDronesResolver", [
    game,
    shipAttributes,
    2,
  ]);
  const flakArrayResolver = m.contract("FlakArrayResolver", [
    game,
    shipAttributes,
    3,
  ]);

  // Faction 2's equipped-Special resolvers: Electric Storm and Drone Swarm,
  // deployed the same way as faction 1's EMP/RepairDrones/FlakArray above —
  // faction 2's slots 4/5. Additional Thruster (the third variant-2
  // special, slot 6) is deliberately never registered as a resolver — it's
  // a pure passive movement bonus (SpecialData.movement), so
  // Game.specialResolvers[2][Slot6] staying unset is what makes trying to
  // *use* it as an action revert.
  const electricStormResolver = m.contract("ElectricStormResolver", [
    game,
    shipAttributes,
    4,
  ]);
  const droneSwarmResolver = m.contract("DroneSwarmResolver", [
    game,
    shipAttributes,
    5,
  ]);

  // Set all config values in a single call. gameAddress/fleetsAddress are
  // ShipsRouter's address, not Game.sol's/Fleets.sol's directly — Game.sol
  // and Fleets.sol now call ShipsRouter instead of Ships.sol, so Ships.sol
  // only ever gets called BY the router post-migration, and must whitelist
  // it accordingly (see markDestroyed/recordKill/setInFleet's auth checks).
  const setShipsConfigCall = m.call(ships, "setConfig", [
    shipsRouter, // gameAddress
    singlePlayerMatch, // lobbyAddress — DestroyRewardLib uses this purely to
    // identify the AI orchestrator address for kill-reward routing (UTC vs
    // DEC); see Ships.sol's comment on this param and
    // SinglePlayerMatch.isSinglePlayerOrchestrator.
    shipsRouter, // fleetsAddress
    generateNewShip,
    randomManager,
    metadataRenderer,
    shipAttributes, // shipAttributes
    universalCredits, // universalCredits
    droneEnergyCores, // droneEnergyCores
    variantPurchaseGate, // purchaseGate
  ]);

  // ShipsRouter's own auth config: gameAddress/fleetsAddress gate its
  // setTimestampDestroyed/setInFleet the same way Ships.sol used to gate
  // them directly against Game.sol/Fleets.sol. lobbyAddress feeds
  // DestroyRewardLib the same way it did when called from inside Ships.sol.
  const setShipsRouterGameAddressCall = m.call(shipsRouter, "setGameAddress", [
    game,
  ]);
  const setShipsRouterFleetsAddressCall = m.call(
    shipsRouter,
    "setFleetsAddress",
    [fleets],
  );
  const setShipsRouterLobbyAddressCall = m.call(
    shipsRouter,
    "setLobbyAddress",
    [singlePlayerMatch],
  );

  // Set all addresses in Game contract (Fleets/Maps/ShipAttributes stay core
  // dependencies; Lobbies/GameResults moved to PvPMatch). `ships` here is
  // redundant with the constructor arg today, but folding it into this
  // existing bulk setter (rather than a new standalone function) is what
  // lets a future ShipsRouter be swapped in later without spending scarce
  // Game.sol bytecode on a dedicated setter — see AI_SHIP_ID_OFFSET's
  // comment in AIShips.sol for why that matters.
  const setGameAddressesCall = m.call(game, "setAddresses", [
    maps,
    fleets,
    shipAttributes,
    shipsRouter,
  ]);

  // Authorize PvPMatch and SinglePlayerMatch to start/force-end sessions on
  // core Game.sol
  const allowPvPMatchToStartGamesCall = m.call(
    game,
    "setIsAllowedToStartGames",
    [pvpMatch, true],
    { id: "AllowPvPMatchToStartGames" },
  );
  const allowSinglePlayerMatchToStartGamesCall = m.call(
    game,
    "setIsAllowedToStartGames",
    [singlePlayerMatch, true],
    { id: "AllowSinglePlayerMatchToStartGames" },
  );

  // Wire RamResolver in as the faction ability resolver for faction 1
  const setFactionAbilityResolverCall = m.call(
    game,
    "setFactionAbilityResolver",
    [1, ramResolver],
  );

  // Wire the equipped-Special resolvers in — keyed by (variant, slot), since
  // Special is a per-faction local slot (0-7), not a global identity.
  // Faction 1: Slot1=EMP, Slot2=RepairDrones, Slot3=FlakArray. Faction 2:
  // Slot4=ElectricStorm, Slot5=DroneSwarm, Slot6=AdditionalThruster (no
  // resolver — passive-only), Slot7=unused.
  const setEMPResolverCall = m.call(game, "setSpecialResolver", [
    1,
    1,
    empResolver,
  ], { id: "SetEMPResolver" });
  const setRepairDronesResolverCall = m.call(game, "setSpecialResolver", [
    1,
    2,
    repairDronesResolver,
  ], { id: "SetRepairDronesResolver" });
  const setFlakArrayResolverCall = m.call(game, "setSpecialResolver", [
    1,
    3,
    flakArrayResolver,
  ], { id: "SetFlakArrayResolver" });
  const setElectricStormResolverCall = m.call(game, "setSpecialResolver", [
    2,
    4,
    electricStormResolver,
  ], { id: "SetElectricStormResolver" });
  const setDroneSwarmResolverCall = m.call(game, "setSpecialResolver", [
    2,
    5,
    droneSwarmResolver,
  ], { id: "SetDroneSwarmResolver" });

  // Display names for each faction's real specials — RenderMetadata.
  // specialNames, keyed by (variant, slot) since a slot's meaning (and so
  // its name) is per-faction. Slot 0 (None) needs no entry — RenderMetadata
  // hardcodes "No Special" for it universally. Unset (variant, slot) pairs
  // (e.g. faction 1's slots 4-7, faction 2's slots 1-3/6/7) fall back to
  // "Unknown" — those slots are either inert or unused for that faction.
  const setEMPNameCall = m.call(metadataRenderer, "setSpecialName", [
    1,
    1,
    "EMP",
  ], { id: "SetEMPName" });
  const setRepairDronesNameCall = m.call(metadataRenderer, "setSpecialName", [
    1,
    2,
    "Repair Drones",
  ], { id: "SetRepairDronesName" });
  const setFlakArrayNameCall = m.call(metadataRenderer, "setSpecialName", [
    1,
    3,
    "Flak Array",
  ], { id: "SetFlakArrayName" });
  const setElectricStormNameCall = m.call(metadataRenderer, "setSpecialName", [
    2,
    4,
    "Lightening Field",
  ], { id: "SetElectricStormName" });
  const setDroneSwarmNameCall = m.call(metadataRenderer, "setSpecialName", [
    2,
    5,
    "Attack Drones",
  ], { id: "SetDroneSwarmName" });
  const setAdditionalThrusterNameCall = m.call(
    metadataRenderer,
    "setSpecialName",
    [2, 6, "Aux Engine"],
    { id: "SetAdditionalThrusterName" },
  );

  // Costs and attributes are both per-variant (ShipAttributes.
  // costsByVariant / VariantAttributeData.{baseHull,baseSpeed,guns,armors,
  // shields}) — each variant needs its own setCosts + setVariantAttributes
  // call, and neither is seeded in the constructor: every variant,
  // including 1, is unconfigured (fails loud) until these calls run. This
  // IS variant 1's and variant 2's data, not an override of some default —
  // edit the numbers here directly to rebalance either faction. Variant 1
  // and variant 2 each have their own fully separate set of consts below
  // (deliberately not shared) so they can be given different initial
  // values independently.

  // ---- Variant 1 ----
  // Costs.special is indexed by the raw Special enum value — covers
  // None/EMP/RepairDrones/FlakArray plus the three variant-2-only specials
  // (ElectricStorm/DroneSwarm/AdditionalThruster). Point-costs currently
  // match variant 2's numbers exactly (same values, independently editable
  // consts) — retune either side's array on its own anytime.
  const variant1SpecialCosts = [0, 10, 20, 15, 15, 20, 10, 0];
  const variant1Guns = [
    { range: 3, damage: 50, movement: 0 }, // Laser
    { range: 6, damage: 40, movement: 0 }, // Railgun
    { range: 4, damage: 60, movement: -1 }, // MissileLauncher
    { range: 2, damage: 80, movement: 0 }, // PlasmaCannon
  ];
  const variant1Armors = [
    { damageReduction: 0, movement: 1 }, // None
    { damageReduction: 15, movement: 0 }, // Light
    { damageReduction: 30, movement: -1 }, // Medium
    { damageReduction: 45, movement: -2 }, // Heavy
  ];
  const variant1Shields = [
    { damageReduction: 0, movement: 1 }, // None
    { damageReduction: 15, movement: 1 }, // Light
    { damageReduction: 30, movement: 0 }, // Medium
    { damageReduction: 45, movement: -1 }, // Heavy
  ];

  const setCostsVariant1Call = m.call(
    shipAttributes,
    "setCosts",
    [
      1, // variant
      {
        version: 0, // ignored by setCosts, which always computes version+1 itself
        baseCost: 50,
        accuracy: [0, 10, 25],
        hull: [0, 10, 25],
        speed: [0, 10, 25],
        mainWeapon: [25, 30, 40, 40],
        armor: [0, 5, 10, 15],
        shields: [0, 10, 20, 30],
        special: variant1SpecialCosts,
      },
    ],
    { id: "SetCostsVariant1" },
  );

  const setVariant1AttributesCall = m.call(
    shipAttributes,
    "setVariantAttributes",
    [
      {
        version: 1,
        variant: 1,
        baseHull: 100,
        baseSpeed: 3,
        foreAccuracy: [0, 25, 50],
        hull: [0, 10, 20],
        engineSpeeds: [0, 1, 2],
        guns: variant1Guns,
        armors: variant1Armors,
        shields: variant1Shields,
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
    { id: "SetVariant1Attributes" },
  );

  // ---- Variant 2 ----
  // Point-costs for its own three specials (ElectricStorm/DroneSwarm/
  // AdditionalThruster) are placeholders (loosely mirroring FlakArray/EMP/
  // a cheap passive tier) — retune anytime via another setCosts call.
  const variant2SpecialCosts = [0, 10, 20, 15, 15, 20, 10, 0];
  const variant2Guns = [
    { range: 3, damage: 50, movement: 0 }, // Laser
    { range: 6, damage: 40, movement: 0 }, // Railgun
    { range: 4, damage: 60, movement: -1 }, // MissileLauncher
    { range: 2, damage: 80, movement: 0 }, // PlasmaCannon
  ];
  const variant2Armors = [
    { damageReduction: 0, movement: 1 }, // None
    { damageReduction: 15, movement: 0 }, // Light
    { damageReduction: 30, movement: -1 }, // Medium
    { damageReduction: 45, movement: -2 }, // Heavy
  ];
  const variant2Shields = [
    { damageReduction: 0, movement: 1 }, // None
    { damageReduction: 15, movement: 1 }, // Light
    { damageReduction: 30, movement: 0 }, // Medium
    { damageReduction: 45, movement: -1 }, // Heavy
  ];

  const setCostsVariant2Call = m.call(
    shipAttributes,
    "setCosts",
    [
      2, // variant
      {
        version: 0,
        baseCost: 50,
        accuracy: [0, 10, 25],
        hull: [0, 10, 25],
        speed: [0, 10, 25],
        mainWeapon: [25, 30, 40, 40],
        armor: [0, 5, 10, 15],
        shields: [0, 10, 20, 30],
        special: variant2SpecialCosts,
      },
    ],
    { id: "SetCostsVariant2" },
  );

  const setVariant2AttributesCall = m.call(
    shipAttributes,
    "setVariantAttributes",
    [
      {
        version: 1,
        variant: 2,
        baseHull: 100,
        baseSpeed: 3,
        foreAccuracy: [0, 25, 50],
        hull: [0, 10, 20],
        engineSpeeds: [0, 1, 2],
        guns: variant2Guns,
        armors: variant2Armors,
        shields: variant2Shields,
        specials: [
          { range: 0, strength: 0, movement: 0 }, // None
          { range: 0, strength: 0, movement: 0 }, // EMP (inert for variant 2)
          { range: 0, strength: 0, movement: 0 }, // RepairDrones (inert for variant 2)
          { range: 0, strength: 0, movement: 0 }, // FlakArray (inert for variant 2)
          { range: 2, strength: 1, movement: 0 }, // ElectricStorm
          { range: 5, strength: 40, movement: 0 }, // DroneSwarm
          { range: 0, strength: 0, movement: 3 }, // AdditionalThruster
          { range: 0, strength: 0, movement: 0 }, // future4
        ],
      },
    ],
    { id: "SetVariant2Attributes" },
  );

  // Set PvPMatch contract address in GameResults contract (PvPMatch now
  // records PvP results, not core Game.sol)
  const setGameResultsGameContractCall = m.call(
    gameResults,
    "setGameContract",
    [pvpMatch],
  );

  // Set Game address in Maps contract
  const setMapsGameAddressCall = m.call(maps, "setGameAddress", [game]);

  // Allow the designated map editor wallet to create/edit preset maps
  const allowMapEditorCall = m.call(maps, "setMapEditor", [MAP_EDITOR, true], {
    id: "AllowMapEditor",
  });

  // Reuse the same map-editor wallet as the AI-encounters content admin
  const allowAIEncounterEditorCall = m.call(
    aiEncounters,
    "setEncounterEditor",
    [MAP_EDITOR, true],
    { id: "AllowAIEncounterEditor" },
  );

  // Reuse the same map-editor wallet as the campaign-node graph admin
  const allowNodeEditorCall = m.call(
    nodeMap,
    "setNodeEditor",
    [MAP_EDITOR, true],
    { id: "AllowNodeEditor" },
  );

  // Let SinglePlayerMatch record node completions on a human win
  const allowSinglePlayerMatchToCompleteNodesCall = m.call(
    nodeMap,
    "setIsAllowedToCompleteNodes",
    [singlePlayerMatch, true],
    { id: "AllowSinglePlayerMatchToCompleteNodes" },
  );

  // --- Starter single-player content --------------------------------------
  // Neither preset maps nor AIEncounters ship configs are otherwise seeded
  // anywhere — both are meant to be curated post-deploy by the MAP_EDITOR
  // wallet via the permission calls just above. Without at least one of
  // each, a fresh deployment has zero maps and zero AI configs, so
  // single-player is unusable (setupAIFleet always reverts with
  // NoAIPlacementsConfigured) until someone manually creates content. The
  // actual content (maps, AI ship configs, placements, campaign nodes)
  // lives in ignition/data/singlePlayerStarterContent.json so it can be
  // edited without touching this file; this block just walks that data and
  // issues the same calls the old hardcoded version did. MAP_EDITOR can
  // still add/replace maps and configs post-deploy — this isn't exclusive
  // of that.
  //
  // No AI Rammer config in the JSON: the AI has no decision path for
  // Archetype.Rammer (SinglePlayerMatch._decideMove falls through to the
  // default engage-or-approach logic for it, same as any unhandled
  // archetype) — player-controlled Rammer ships and RamResolver are
  // unaffected.

  // createPresetScoringMap/createFullPresetMap rather than the overloaded
  // createPresetMap: Hardhat Ignition can't disambiguate an overload whose
  // signature contains a struct/tuple array (its function-name validator
  // rejects the nested parens before it ever reaches ABI resolution), and
  // there's nothing to disambiguate here anyway since each of these is the
  // only function with that name.
  //
  // Neither call emits its new id and neither is a view function, so
  // there's no event/staticCall to read an id from — but each map's id is
  // safe to compute as its 1-indexed position in the JSON array, since
  // these are the only map-creation calls in this module, mapCount starts
  // at 0 on a fresh Maps deployment, and each call is forced (via `after`)
  // to run strictly after the previous one so they can't land out of order.
  // Types.sol's MapMode enum, mirrored here so the JSON can use readable
  // strings instead of magic numbers — keep in sync if MapMode changes.
  const MAP_MODE: Record<string, number> = { PvP: 0, PvE: 1, Both: 2 };

  const mapCalls: Record<string, ReturnType<typeof m.call>> = {};
  const mapIds: Record<string, bigint> = {};
  starterContent.maps.forEach((map, i) => {
    const mapId = BigInt(i + 1);
    const previousMapCall =
      i > 0 ? mapCalls[starterContent.maps[i - 1].key] : undefined;
    const mode = MAP_MODE[map.mode];
    const call =
      map.type === "scoring"
        ? m.call(maps, "createPresetScoringMap", [map.scoringTiles, mode], {
            id: `Create${map.key[0].toUpperCase()}${map.key.slice(1)}Map`,
            ...(previousMapCall ? { after: [previousMapCall] } : {}),
          })
        : m.call(
            maps,
            "createFullPresetMap",
            [map.blockedTiles ?? [], map.scoringTiles, mode],
            {
              id: `Create${map.key[0].toUpperCase()}${map.key.slice(1)}Map`,
              ...(previousMapCall ? { after: [previousMapCall] } : {}),
            },
          );
    mapCalls[map.key] = call;
    mapIds[map.key] = mapId;
  });

  const aiConfigCalls: ReturnType<typeof m.call>[] = [];
  const aiConfigIds: Record<
    string,
    ReturnType<typeof m.readEventArgument>
  > = {};
  for (const config of starterContent.aiShipConfigs) {
    const capitalizedKey = `${config.key[0].toUpperCase()}${config.key.slice(1)}`;
    const call = m.call(
      aiEncounters,
      "createAIShipConfig",
      [
        config.name,
        config.equipment,
        {
          serialNumber: 0n,
          colors: starterContent.aiShipColors,
          ...config.traits,
        },
        config.archetype,
      ],
      { id: `Create${capitalizedKey}AIShipConfig` },
    );
    aiConfigCalls.push(call);
    aiConfigIds[config.key] = m.readEventArgument(
      call,
      "AIShipConfigCreated",
      "configId",
      { emitter: aiEncounters, id: `Read${capitalizedKey}ConfigId` },
    );
  }

  // Default cap is 8; the hardest campaign nodes (asteroidField,
  // warlordsRedoubt, gauntlet, bastion) need up to 14 ships to actually
  // reach their enemyThreat target within the available config levels
  // (I-V), so raise the live knob once here before placing any fleet.
  const setMaxPlacementsPerMapCall = m.call(
    aiEncounters,
    "setMaxPlacementsPerMap",
    [14n],
  );

  const placementCalls: ReturnType<typeof m.call>[] = [];
  for (const placement of starterContent.mapPlacements) {
    const capitalizedKey = `${placement.mapKey[0].toUpperCase()}${placement.mapKey.slice(1)}`;
    placementCalls.push(
      m.call(
        aiEncounters,
        "setMapPlacements",
        [
          mapIds[placement.mapKey],
          placement.positions,
          placement.configKeys.map((k) => aiConfigIds[k]),
        ],
        {
          id: `Place${capitalizedKey}AIFleet`,
          after: [mapCalls[placement.mapKey], setMaxPlacementsPerMapCall],
        },
      ),
    );
  }

  // Campaigns are just a grouping label for nodes (see NodeMap.sol's
  // header comment) — created first, in JSON order, so nodes below can
  // reference their campaign's id. campaignId is 1-indexed position, same
  // "no event to read" reasoning as maps/nodes elsewhere in this file.
  const campaignCalls: Record<string, ReturnType<typeof m.call>> = {};
  const campaignIds: Record<string, bigint> = {};
  starterContent.campaigns.forEach((campaign, i) => {
    const capitalizedKey = `${campaign.key[0].toUpperCase()}${campaign.key.slice(1)}`;
    // Chained to the previous campaign call for the same reason node
    // creation is below: keeps the "id is array position" guess trustworthy
    // even though createCampaign calls have no other dependency between
    // them that would otherwise force this order.
    const previousCampaignCall =
      i > 0 ? campaignCalls[starterContent.campaigns[i - 1].key] : undefined;
    const call = m.call(nodeMap, "createCampaign", [], {
      id: `Create${capitalizedKey}Campaign`,
      ...(previousCampaignCall ? { after: [previousCampaignCall] } : {}),
    });
    campaignCalls[campaign.key] = call;
    campaignIds[campaign.key] = BigInt(i + 1);
  });

  // Seeds the campaign graph so the frontend has a real unlock graph out of
  // the box: nodes are created in the JSON's order, each node's id is its
  // 1-indexed position (same "no event to read" reasoning as the maps
  // above), and "prerequisites" references other nodes by key, which
  // requires the JSON to list a node after everything it depends on (same
  // requirement the old hardcoded version had). MAP_EDITOR can add more
  // nodes/branches afterward via NodeMap.createNode/addPrerequisite.
  // costLimit/turnTime/maxScore are curated here rather than player-chosen
  // — see NodeMap.sol's header comment for why.
  // The "id is 1-indexed array position" trick only holds if createNode
  // calls actually execute on-chain in that same order. With branching
  // (a dead end and a shortcut both hanging off an early node, as below),
  // Ignition is otherwise free to interleave independent branches' calls
  // however its scheduler likes — confirmed this by deploying a 30-node
  // graph and finding two adjacent branches' node ids swapped relative to
  // array position. Forcing every node to also depend on the previous
  // node in array order (same trick already used for maps below) makes
  // execution strictly sequential regardless of the *logical* prerequisite
  // graph, so the array-position id guess stays trustworthy.
  const nodeCalls: Record<string, ReturnType<typeof m.call>> = {};
  const nodeIds: Record<string, bigint> = {};
  starterContent.campaignNodes.forEach((node, i) => {
    const capitalizedKey = `${node.key[0].toUpperCase()}${node.key.slice(1)}`;
    const prerequisiteIds = node.prerequisites.map((k) => nodeIds[k]);
    const previousNodeCall =
      i > 0 ? nodeCalls[starterContent.campaignNodes[i - 1].key] : undefined;
    const call = m.call(
      nodeMap,
      "createNode",
      [
        campaignIds[node.campaignKey],
        mapIds[node.mapKey],
        prerequisiteIds,
        node.costLimit,
        node.turnTime,
        node.maxScore,
        node.creatorGoesFirst,
        node.enemyThreat,
      ],
      {
        id: `Create${capitalizedKey}`,
        after: [
          campaignCalls[node.campaignKey],
          mapCalls[node.mapKey],
          ...node.prerequisites.map((k) => nodeCalls[k]),
          ...(previousNodeCall ? [previousNodeCall] : []),
        ],
      },
    );
    nodeCalls[node.key] = call;
    nodeIds[node.key] = BigInt(i + 1);
  });

  // Shattered Hive Campaign medal: soulbound, awarded via player-initiated
  // claimMedal() once the campaign's true final node (f06 — the end of the
  // reconverged m/s/f storyline, not d06's dead-end branch; see
  // singlePlayerStarterContent.json) has been completed. Deployed after the
  // node-seeding loop above so nodeIds["f06"] is populated; the constructor
  // arg is just a JS-side number by this point (createNode's own `after`
  // chaining is what makes nodeIds trustworthy in the first place), but the
  // deploy is still ordered after f06's own createNode call for good measure.
  const shatteredHiveMedal = m.contract(
    "ShatteredHiveMedal",
    [nodeMap, nodeIds["f06"]],
    { after: [nodeCalls["f06"]] },
  );

  // Gate variant-2 purchases on holding the medal.
  const setVariant2GateCall = m.call(variantPurchaseGate, "setRequiredNft", [
    2,
    shatteredHiveMedal,
  ]);

  // Set PvPMatch address in Lobbies contract
  const setLobbiesPvpMatchAddressCall = m.call(lobbies, "setPvpMatchAddress", [
    pvpMatch,
  ]);

  // Set Lobbies address in PvPMatch contract
  const setPvpMatchLobbiesAddressCall = m.call(pvpMatch, "setLobbiesAddress", [
    lobbies,
  ]);

  // Allow SinglePlayerMatch to allocate AI ships from AIShips' pool (it no
  // longer touches Ships.sol at all — its fleets live entirely in AIShips)
  const allowSinglePlayerMatchToCreateAIShipsCall = m.call(
    aiShips,
    "setIsAllowedToCreateShips",
    [singlePlayerMatch, true],
    { id: "AllowSinglePlayerMatchToCreateAIShips" },
  );

  // Set Fleets address in Lobbies contract
  const setLobbiesFleetsAddressCall = m.call(lobbies, "setFleetsAddress", [
    fleets,
  ]);

  // Set Maps address in Lobbies contract
  const setLobbiesMapsAddressCall = m.call(lobbies, "setMapsAddress", [maps]);

  // Set UniversalCredits address in Lobbies contract
  const setLobbiesUniversalCreditsAddressCall = m.call(
    lobbies,
    "setUniversalCreditsAddress",
    [universalCredits],
  );

  // Authorize Lobbies (PvP) and SinglePlayerMatch (vs-AI node matches) to
  // create/clear fleets
  const allowLobbiesToManageFleetsCall = m.call(
    fleets,
    "setIsAllowedToManageFleets",
    [lobbies, true],
    { id: "AllowLobbiesToManageFleets" },
  );
  const allowSinglePlayerMatchToManageFleetsCall = m.call(
    fleets,
    "setIsAllowedToManageFleets",
    [singlePlayerMatch, true],
    { id: "AllowSinglePlayerMatchToManageFleets" },
  );

  // Set Game address in Fleets contract
  const setFleetsGameAddressCall = m.call(fleets, "setGameAddress", [game]);

  // Set ShipAttributes address in Fleets contract
  const setFleetsShipAttributesCall = m.call(fleets, "setShipAttributes", [
    shipAttributes,
  ]);

  // Allow ShipPurchaser to create ships
  const allowShipPurchaserToCreateShipsCall = m.call(
    ships,
    "setIsAllowedToCreateShips",
    [shipPurchaser, true],
  );

  // Allow DroneYard to modify ships
  const allowDroneYardToModifyShipsCall = m.call(
    ships,
    "setIsAllowedToCreateShips",
    [droneYard, true],
    { id: "AllowDroneYardToModifyShips" },
  );

  const allowTutorialClaimToCreateShipsCall = m.call(
    ships,
    "setIsAllowedToCreateShips",
    [tutorialClaim, true],
    { id: "AllowTutorialClaimToCreateShips" },
  );

  // Allow the Firebase Flow backend minter to create ships (same as ShipPurchaser)
  const allowFirebaseFlowMinterToCreateShipsCall = m.call(
    ships,
    "setIsAllowedToCreateShips",
    [FIREBASE_FLOW_MINTER, true],
    { id: "AllowFirebaseFlowMinterToCreateShips" },
  );

  const setTutorialClaimOnGameResultsCall = m.call(
    gameResults,
    "setTutorialClaimContract",
    [tutorialClaim],
    { id: "SetTutorialClaimOnGameResults" },
  );

  // Only 2 variants exist: variant 1 (default/tutorial faction) and
  // variant 2 (the new faction); default maxVariant is 1
  const setMaxVariantForTutorialShipsCall = m.call(
    ships,
    "setMaxVariant",
    [2],
    {
      id: "SetMaxVariantForTutorialShips",
    },
  );

  // Enable minting for UniversalCredits
  const setMintIsActiveCall = m.call(universalCredits, "setMintIsActive", [
    true,
  ]);

  // Allow ShipPurchaser and Ships to mint UniversalCredits (Ships still
  // mints UTC directly for shipBreaker, unrelated to destroy rewards)
  const authorizeShipPurchaserToMintCall = m.call(
    universalCredits,
    "setAuthorizedToMint",
    [shipPurchaser, true],
    { id: "AuthorizeShipPurchaserToMint" },
  );
  const authorizeShipsToMintCall = m.call(
    universalCredits,
    "setAuthorizedToMint",
    [ships, true],
    { id: "AuthorizeShipsToMint" },
  );
  // ShipsRouter now performs the DestroyRewardLib call itself (it's the
  // only place that can see both ships' owners regardless of which backing
  // contract holds them), so it — not Ships.sol — needs UTC minting rights
  // for the AI-destroys-human reward direction.
  const authorizeShipsRouterToMintUtcCall = m.call(
    universalCredits,
    "setAuthorizedToMint",
    [shipsRouter, true],
    { id: "AuthorizeShipsRouterToMintUtc" },
  );

  // Enable minting for DroneEnergyCores and allow ShipsRouter (via
  // DestroyRewardLib, now called from the router instead of Ships.sol) to
  // mint it
  const setDecMintIsActiveCall = m.call(droneEnergyCores, "setMintIsActive", [
    true,
  ]);
  const authorizeShipsRouterToMintDecCall = m.call(
    droneEnergyCores,
    "setAuthorizedToMint",
    [shipsRouter, true],
    { id: "AuthorizeShipsRouterToMintDec" },
  );

  // FreeShipClaim.claimFreeShips reads a player's bonus directly from
  // DroneStorefront.droneCoreTier (1 tier = +1 ship).
  const setFreeShipClaimDroneStorefrontCall = m.call(
    freeShipClaim,
    "setDroneStorefront",
    [droneStorefront],
  );

  // FreeShipClaim mints through Ships' existing authorized-minter allowlist,
  // same as DroneYard/ShipPurchaser/TutorialClaim.
  const allowFreeShipClaimToCreateShipsCall = m.call(
    ships,
    "setIsAllowedToCreateShips",
    [freeShipClaim, true],
    { id: "AllowFreeShipClaimToCreateShips" },
  );

  // Seed the drone-core turn-in tier ladder: cumulative cost to reach tier N
  // grants +N to a player's permanent free-ship bonus (see
  // DroneStorefront.turnInCores / FreeShipClaim.claimFreeShips). Costs ramp
  // ~1.76x per tier so tier 1 is reachable in a handful of AI kills while
  // the top tier takes a very long time to earn — tune via addTier
  // post-deploy. DEC is a freely transferable ERC20 (not soulbound), so a
  // player can also just buy cores from someone else's grind instead of
  // earning them directly — see DroneEnergyCores.sol.
  const droneCoreTierCosts = [10, 20, 30, 55, 95, 170, 300, 525, 925, 1625];
  const addTierCalls: ReturnType<typeof m.call>[] = [];
  droneCoreTierCosts.forEach((cost, index) => {
    const previousAddTierCall =
      index > 0 ? addTierCalls[index - 1] : undefined;
    const call = m.call(droneStorefront, "addTier", [cost], {
      id: `AddDroneCoreTier${index + 1}`,
      ...(previousAddTierCall ? { after: [previousAddTierCall] } : {}),
    });
    addTierCalls.push(call);
  });

  // Let SinglePlayerMatch withdraw the UTC it accumulates whenever the AI
  // (owner of its own ships) destroys a human ship — DestroyRewardLib only
  // pays DEC for the reverse case (a player destroying an AI ship).
  const setSinglePlayerMatchUniversalCreditsAddressCall = m.call(
    singlePlayerMatch,
    "setUniversalCreditsAddress",
    [universalCredits],
  );

  // WARNING: This works for deploying but breaks the tests for some reason.
  // Purchase tier 4 for the deployer
  // m.call(
  //   ships,
  //   "purchaseWithFlow",
  //   [
  //     "0x69a5B3aE8598fC5A5419eaa1f2A59Db2D052e346",
  //     4,
  //     "0x69a5B3aE8598fC5A5419eaa1f2A59Db2D052e346",
  //   ],
  //   { value: parseEther("99.99") }
  // );

  // m.call(ships, "constructAllMyShips");

  // Set the tiers for different chains

  // const tierUSDPrices = [4.99, 9.99, 19.99, 34.99, 49.99];
  // const tierSHIPS = [5, 11, 22, 40, 60];

  // // Base

  // const TOKEN_PRICE_USD = 3000;

  // // Calculate the price in native token (wei) for each tier.
  // // Each tierUSDPrice is the desired total USD value for the tier.
  // // Given 1 native token = TOKEN_PRICE_USD, priceInNative = usdPrice / TOKEN_PRICE_USD.
  // const tierPrices = tierUSDPrices.map((usdPrice) =>
  //   parseEther((usdPrice / TOKEN_PRICE_USD).toString()),
  // );

  // // Set the tiers for different chains
  // m.call(ships, "setTiers", [tierSHIPS, tierPrices]);

  // RONIN SAIGON - Reduce price due to testnet token scarcity
  // const tierDefaultPrices = [4.99, 9.99, 19.99, 34.99, 49.99];
  // const tierSHIPS = [5, 11, 22, 40, 60];

  // // Divide prices by 1000 for lower prices for testing to save tokens
  // const tierPrices = tierDefaultPrices.map((price) => price / 1000);

  // // Set the tiers for different chains
  // m.call(ships, "setPurchaseInfo", [tierSHIPS, tierPrices]);

  // World ID router. Toggle between the two lines below (same pattern as
  // `shipNames` above):
  //   - Local / tests: deploy the mock (no real proofs available).
  //   - Real network:  comment the mock, uncomment the router address so the
  let worldId: any;
  //                     Tournament is deployed pointing at the real router.
  // Base Sepolia (chain 84532) testnet WorldIDRouter, verified against World ID docs.
  if (!PRODUCTION) {
    worldId = m.contract("MockWorldID");
  } else {
    worldId = "0x42FF98C4E85212a5D31358ACbFe76a621b50fC02";
  }
  // const worldId = "0x42FF98C4E85212a5D31358ACbFe76a621b50fC02";

  const tournament = m.contract("Tournament", [
    worldId,
    TOURNAMENT_WORLD_ID_GROUP,
    TOURNAMENT_EXTERNAL_NULLIFIER,
    gameResults,
    game,
    m.getAccount(0), // feeRecipient (protocol fee sink) == deployer
  ]);

  // Deploy GameBlobRegistry — stores Walrus blobId per player per completed game
  const gameBlobRegistry = m.contract("GameBlobRegistry", [
    gameResults,
    FIREBASE_FLOW_MINTER,
  ]);

  if (PRODUCTION) {
    // --- Ownership handover ------------------------------------------------
    // Every Ownable contract above defaults to Ownable(msg.sender) — the
    // deployer. As the very last step of a real deploy, transfer owner() on
    // all of them to the designated production wallet (reusing MAP_EDITOR's
    // address). Ignition does not guarantee execution order between
    // independent calls on the same contract — only real dependency edges do
    // (see PlaceStarterAIFleet's `after` above) — so each transferOwnership
    // call explicitly depends on every owner-gated call already made against
    // that contract, guaranteeing it lands after all of them instead of
    // racing in the same batch.
    //
    // Note: RamResolver has its own hand-rolled owner (not OpenZeppelin's
    // Ownable) and has no setOwner/transferOwnership function at all, so it
    // can't be included here — its ownership isn't transferable in the
    // contract as written.
    m.call(ships, "transferOwnership", [MAP_EDITOR], {
      id: "TransferShipsOwnership",
      after: [
        setShipsConfigCall,
        allowShipPurchaserToCreateShipsCall,
        allowDroneYardToModifyShipsCall,
        allowTutorialClaimToCreateShipsCall,
        allowFirebaseFlowMinterToCreateShipsCall,
        setMaxVariantForTutorialShipsCall,
        allowFreeShipClaimToCreateShipsCall,
      ],
    });

    m.call(aiShips, "transferOwnership", [MAP_EDITOR], {
      id: "TransferAIShipsOwnership",
      after: [
        setAiShipsShipAttributesCall,
        setAiShipsRouterCall,
        allowSinglePlayerMatchToCreateAIShipsCall,
      ],
    });

    m.call(shipsRouter, "transferOwnership", [MAP_EDITOR], {
      id: "TransferShipsRouterOwnership",
      after: [
        setShipsRouterGameAddressCall,
        setShipsRouterFleetsAddressCall,
        setShipsRouterLobbyAddressCall,
      ],
    });

    m.call(shipAttributes, "transferOwnership", [MAP_EDITOR], {
      id: "TransferShipAttributesOwnership",
      after: [
        setShipAttributesShipsAddressCall,
        setCostsVariant1Call,
        setCostsVariant2Call,
        setVariant1AttributesCall,
        setVariant2AttributesCall,
      ],
    });

    m.call(metadataRenderer, "transferOwnership", [MAP_EDITOR], {
      id: "TransferMetadataRendererOwnership",
      after: [
        setEMPNameCall,
        setRepairDronesNameCall,
        setFlakArrayNameCall,
        setElectricStormNameCall,
        setDroneSwarmNameCall,
        setAdditionalThrusterNameCall,
      ],
    });

    m.call(shipPurchaser, "transferOwnership", [MAP_EDITOR], {
      id: "TransferShipPurchaserOwnership",
    });

    m.call(droneYard, "transferOwnership", [MAP_EDITOR], {
      id: "TransferDroneYardOwnership",
    });

    m.call(maps, "transferOwnership", [MAP_EDITOR], {
      id: "TransferMapsOwnership",
      after: [
        setMapsGameAddressCall,
        allowMapEditorCall,
        ...Object.values(mapCalls),
      ],
    });

    m.call(aiEncounters, "transferOwnership", [MAP_EDITOR], {
      id: "TransferAIEncountersOwnership",
      after: [allowAIEncounterEditorCall, ...aiConfigCalls, ...placementCalls],
    });

    m.call(gameResults, "transferOwnership", [MAP_EDITOR], {
      id: "TransferGameResultsOwnership",
      after: [
        setGameResultsGameContractCall,
        setTutorialClaimOnGameResultsCall,
      ],
    });

    m.call(game, "transferOwnership", [MAP_EDITOR], {
      id: "TransferGameOwnership",
      after: [
        setGameAddressesCall,
        allowPvPMatchToStartGamesCall,
        allowSinglePlayerMatchToStartGamesCall,
        setFactionAbilityResolverCall,
        setEMPResolverCall,
        setRepairDronesResolverCall,
        setFlakArrayResolverCall,
        setElectricStormResolverCall,
        setDroneSwarmResolverCall,
      ],
    });

    m.call(fleets, "transferOwnership", [MAP_EDITOR], {
      id: "TransferFleetsOwnership",
      after: [
        allowLobbiesToManageFleetsCall,
        allowSinglePlayerMatchToManageFleetsCall,
        setFleetsGameAddressCall,
        setFleetsShipAttributesCall,
      ],
    });

    m.call(lobbies, "transferOwnership", [MAP_EDITOR], {
      id: "TransferLobbiesOwnership",
      after: [
        setLobbiesPvpMatchAddressCall,
        setLobbiesFleetsAddressCall,
        setLobbiesMapsAddressCall,
        setLobbiesUniversalCreditsAddressCall,
      ],
    });

    m.call(pvpMatch, "transferOwnership", [MAP_EDITOR], {
      id: "TransferPvPMatchOwnership",
      after: [setPvpMatchLobbiesAddressCall],
    });

    m.call(singlePlayerMatch, "transferOwnership", [MAP_EDITOR], {
      id: "TransferSinglePlayerMatchOwnership",
      after: [setSinglePlayerMatchUniversalCreditsAddressCall],
    });

    m.call(nodeMap, "transferOwnership", [MAP_EDITOR], {
      id: "TransferNodeMapOwnership",
      after: [
        allowNodeEditorCall,
        allowSinglePlayerMatchToCompleteNodesCall,
        ...Object.values(nodeCalls),
      ],
    });

    m.call(variantPurchaseGate, "transferOwnership", [MAP_EDITOR], {
      id: "TransferVariantPurchaseGateOwnership",
      after: [setVariant2GateCall],
    });

    m.call(shatteredHiveMedal, "transferOwnership", [MAP_EDITOR], {
      id: "TransferShatteredHiveMedalOwnership",
    });

    m.call(universalCredits, "transferOwnership", [MAP_EDITOR], {
      id: "TransferUniversalCreditsOwnership",
      after: [
        setMintIsActiveCall,
        authorizeShipPurchaserToMintCall,
        authorizeShipsToMintCall,
        authorizeShipsRouterToMintUtcCall,
      ],
    });

    m.call(droneEnergyCores, "transferOwnership", [MAP_EDITOR], {
      id: "TransferDroneEnergyCoresOwnership",
      after: [setDecMintIsActiveCall, authorizeShipsRouterToMintDecCall],
    });

    m.call(droneStorefront, "transferOwnership", [MAP_EDITOR], {
      id: "TransferDroneStorefrontOwnership",
      after: [...addTierCalls],
    });

    m.call(tournament, "transferOwnership", [MAP_EDITOR], {
      id: "TransferTournamentOwnership",
    });

    m.call(gameBlobRegistry, "transferOwnership", [MAP_EDITOR], {
      id: "TransferGameBlobRegistryOwnership",
    });
  }

  return {
    randomManager,
    renderSpecial1,
    renderSpecial2,
    renderSpecial3,
    renderAft0,
    renderAft1,
    renderAft2,
    renderWeapon1,
    renderWeapon2,
    renderWeapon3,
    renderWeapon4,
    renderShield1,
    renderShield2,
    renderShield3,
    renderArmor1,
    renderArmor2,
    renderArmor3,
    renderFore0,
    renderFore1,
    renderFore2,
    renderForePerfect,
    renderSpecial,
    renderAft,
    renderWeapon,
    renderBody,
    renderFore,
    imageRenderer,
    renderSpecial4V2,
    renderSpecial5V2,
    renderSpecial6V2,
    renderAft0V2,
    renderAft1V2,
    renderAft2V2,
    renderWeapon1V2,
    renderWeapon2V2,
    renderWeapon3V2,
    renderWeapon4V2,
    renderFore0V2,
    renderFore1V2,
    renderFore2V2,
    renderForePerfectV2,
    renderShield1V2,
    renderShield2V2,
    renderShield3V2,
    renderArmor1V2,
    renderArmor2V2,
    renderArmor3V2,
    renderBaseBodyV2,
    renderSpecialV2,
    renderAftV2,
    renderWeaponV2,
    renderBodyV2,
    renderForeV2,
    imageRendererV2,
    metadataRenderer,
    shipNames,
    droneNames,
    generateNewShip,
    ships,
    aiShips,
    shipsRouter,
    shipAttributes,
    universalCredits,
    droneEnergyCores,
    droneStorefront,
    shipPurchaser,
    droneYard,
    maps,
    gameResults,
    game,
    pvpMatch,
    singlePlayerMatch,
    fleets,
    lobbies,
    nodeMap,
    variantPurchaseGate,
    shatteredHiveMedal,
    tutorialClaim,
    freeShipClaim,
    worldId,
    tournament,
    gameBlobRegistry,
    specialEffectsLib,
    destroyRewardLib,
    ramResolver,
    empResolver,
    repairDronesResolver,
    flakArrayResolver,
    electricStormResolver,
    droneSwarmResolver,
    aiEncounters,
  };
});

export default DeployModule;
