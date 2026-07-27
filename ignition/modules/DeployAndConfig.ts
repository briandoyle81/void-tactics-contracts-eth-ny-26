// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseEther } from "viem";

// Set to true only for a real production deploy. Every test fixture deploys
// this same module via hre.ignition.deploy(DeployModule), and steps gated
// behind this flag (e.g. transferring contract ownership away from the
// deployer) would break owner-gated test setup if they ran unconditionally
// — this is a plain build-time boolean (not an Ignition parameter) so gated
// m.call(...) invocations are simply never added to the deployment graph
// when false, rather than being skipped at execution time.
const PRODUCTION = true;

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

// Cosmetic only (no validation on colors) — reused across every starter AI
// ship config below so they're not each repeating all nine fields.
const AI_SHIP_COLORS = {
  h1: 0,
  s1: 0,
  l1: 0,
  h2: 0,
  s2: 0,
  l2: 0,
  h3: 0,
  s3: 0,
  l3: 0,
};

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

  // Deploy MetadataRenderer with ImageRenderer
  const metadataRenderer = m.contract("RenderMetadata", [imageRenderer]);

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

  // Deploy GenerateNewShip with ship names
  const generateNewShip = m.contract("GenerateNewShip", [shipNames]);

  // Deploy UniversalCredits token
  const universalCredits = m.contract("UniversalCredits");

  // Deploy DroneEnergyCores ("DEC"): soulbound reward token minted when a
  // player destroys an AI-owned ship (Ships.setTimestampDestroyed via
  // DestroyRewardLib), instead of UTC.
  const droneEnergyCores = m.contract("DroneEnergyCores");

  // Deploy DroneStorefront: stub — does nothing yet beyond existing as
  // DEC's transferExemptAddress, so DEC has somewhere to be spent later
  // instead of being fully soulbound.
  const droneStorefront = m.contract("DroneStorefront", [droneEnergyCores]);

  // Deploy DestroyRewardLib: decides UTC vs DEC for a kill reward, split
  // out of Ships.sol purely for bytecode headroom (same reasoning as
  // SpecialEffectsLib below) — linked into Ships at deploy time.
  const destroyRewardLib = m.library("DestroyRewardLib");

  // Finally deploy Ships with all dependencies
  const ships = m.contract("Ships", [metadataRenderer], {
    libraries: { DestroyRewardLib: destroyRewardLib },
  });

  // Deploy ShipAttributes contract
  const shipAttributes = m.contract("ShipAttributes", [ships]);

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

  // Deploy GameResults contract
  const gameResults = m.contract("GameResults");

  // Deploy SpecialEffectsLib: resolver-backed special dispatch + the
  // RepairDrones/EMP/FlakArray arithmetic, split out of Game.sol purely for
  // bytecode headroom (see the library's header comment). Linked into Game
  // at deploy time.
  const specialEffectsLib = m.library("SpecialEffectsLib");

  // Deploy Game contract with ShipAttributes
  const game = m.contract("Game", [ships, shipAttributes], {
    libraries: { SpecialEffectsLib: specialEffectsLib },
  });

  // Deploy Fleets contract
  const fleets = m.contract("Fleets", [ships]);

  // Deploy Lobbies contract
  const lobbies = m.contract("Lobbies", [ships]);

  // Deploy PvPMatch: the PvP-specific orchestration split out of Game.sol
  // (human forfeit/timeout, PvP leaderboard recording). Core Game.sol stays
  // mode-agnostic; this is what Lobbies talks to for starting/ending matches.
  const pvpMatch = m.contract("PvPMatch", [game, gameResults]);

  // Deploy SinglePlayerMatch: plays single-player matches as an on-chain AI
  // opponent, through the exact same Lobbies flow as a human joiner.
  const singlePlayerMatch = m.contract("SinglePlayerMatch", [
    ships,
    lobbies,
    game,
    aiEncounters,
    maps,
    shipAttributes,
  ]);

  const tutorialClaim = m.contract("TutorialClaim", [ships, gameResults]);

  // Deploy RamResolver: the faction 1 innate ability (traits.variant == 1),
  // resolver-backed per IFactionAbilityResolver and dispatched via
  // ActionType.FactionAbility rather than the old
  // automatic-side-effect-of-movement ramming mechanic.
  const ramResolver = m.contract("RamResolver", [game]);

  // Set all config values in a single call
  const setShipsConfigCall = m.call(ships, "setConfig", [
    game, // gameAddress
    lobbies, // lobbyAddress
    fleets, // fleetsAddress
    generateNewShip,
    randomManager,
    metadataRenderer,
    shipAttributes, // shipAttributes
    universalCredits, // universalCredits
    droneEnergyCores, // droneEnergyCores
  ]);

  // Set all addresses in Game contract (Fleets/Maps/ShipAttributes stay core
  // dependencies; Lobbies/GameResults moved to PvPMatch)
  const setGameAddressesCall = m.call(game, "setAddresses", [
    maps,
    fleets,
    shipAttributes,
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

  // --- Starter single-player content ------------------------------------
  // Neither preset maps nor AIEncounters ship configs are otherwise seeded
  // anywhere — both are meant to be curated post-deploy by the MAP_EDITOR
  // wallet via the permission calls just above. Without at least one of
  // each, a fresh deployment has zero maps and zero AI configs, so
  // single-player is unusable (setupAIFleet always reverts with
  // NoAIPlacementsConfigured) until someone manually creates content. This
  // seeds just enough for single-player to work out of the box: one small
  // preset map with a scoring tile, and one AI ship config per behavior
  // archetype placed on it. MAP_EDITOR can still add/replace maps and
  // configs afterward — this isn't exclusive of that.
  // createPresetScoringMap rather than the overloaded createPresetMap:
  // Hardhat Ignition can't disambiguate an overload whose signature
  // contains a struct/tuple array (its function-name validator rejects the
  // nested parens before it ever reaches ABI resolution), and there's
  // nothing to disambiguate here anyway since createPresetScoringMap is the
  // only function with that name — it creates a map with no blocked tiles,
  // which is exactly what's wanted.
  const starterMapCall = m.call(
    maps,
    "createPresetScoringMap",
    [[{ row: 5, col: 8, points: 5, onlyOnce: false }]], // gives Turtle a real objective
    { id: "CreateStarterSinglePlayerMap" },
  );
  // createPresetScoringMap doesn't emit its new id and isn't a view
  // function, so there's no event/staticCall to read it from — but it's
  // safe to hardcode as 1 since this is the only map-creation call in this
  // module and mapCount always starts at 0 on a fresh Maps deployment.
  const starterMapId = 1n;

  const gruntConfigCall = m.call(
    aiEncounters,
    "createAIShipConfig",
    [
      "AI Grunt",
      { mainWeapon: 0, armor: 0, shields: 0, special: 0 }, // Laser, unarmored
      {
        serialNumber: 0n,
        colors: AI_SHIP_COLORS,
        variant: 1,
        accuracy: 0,
        hull: 0,
        speed: 0,
      },
      0, // Archetype.Grunt
    ],
    { id: "CreateGruntAIShipConfig" },
  );
  const gruntConfigId = m.readEventArgument(
    gruntConfigCall,
    "AIShipConfigCreated",
    "configId",
    { emitter: aiEncounters, id: "ReadGruntConfigId" },
  );

  const aggressorConfigCall = m.call(
    aiEncounters,
    "createAIShipConfig",
    [
      "AI Aggressor",
      { mainWeapon: 2, armor: 1, shields: 0, special: 0 }, // MissileLauncher, Light armor
      {
        serialNumber: 0n,
        colors: AI_SHIP_COLORS,
        variant: 1,
        accuracy: 0,
        hull: 1,
        speed: 1,
      },
      1, // Archetype.Aggressor
    ],
    { id: "CreateAggressorAIShipConfig" },
  );
  const aggressorConfigId = m.readEventArgument(
    aggressorConfigCall,
    "AIShipConfigCreated",
    "configId",
    { emitter: aiEncounters, id: "ReadAggressorConfigId" },
  );

  const sniperConfigCall = m.call(
    aiEncounters,
    "createAIShipConfig",
    [
      "AI Sniper",
      { mainWeapon: 1, armor: 0, shields: 0, special: 0 }, // Railgun (longest range)
      {
        serialNumber: 0n,
        colors: AI_SHIP_COLORS,
        variant: 1,
        accuracy: 1,
        hull: 0,
        speed: 0,
      },
      2, // Archetype.Sniper
    ],
    { id: "CreateSniperAIShipConfig" },
  );
  const sniperConfigId = m.readEventArgument(
    sniperConfigCall,
    "AIShipConfigCreated",
    "configId",
    { emitter: aiEncounters, id: "ReadSniperConfigId" },
  );

  const supportConfigCall = m.call(
    aiEncounters,
    "createAIShipConfig",
    [
      "AI Support",
      { mainWeapon: 0, armor: 0, shields: 1, special: 2 }, // Laser, Light shields, RepairDrones
      {
        serialNumber: 0n,
        colors: AI_SHIP_COLORS,
        variant: 1,
        accuracy: 0,
        hull: 0,
        speed: 0,
      },
      3, // Archetype.Support
    ],
    { id: "CreateSupportAIShipConfig" },
  );
  const supportConfigId = m.readEventArgument(
    supportConfigCall,
    "AIShipConfigCreated",
    "configId",
    { emitter: aiEncounters, id: "ReadSupportConfigId" },
  );

  const turtleConfigCall = m.call(
    aiEncounters,
    "createAIShipConfig",
    [
      "AI Turtle",
      { mainWeapon: 0, armor: 1, shields: 0, special: 0 }, // Laser, Light armor
      {
        serialNumber: 0n,
        colors: AI_SHIP_COLORS,
        variant: 1,
        accuracy: 0,
        hull: 1,
        speed: 0,
      },
      4, // Archetype.Turtle
    ],
    { id: "CreateTurtleAIShipConfig" },
  );
  const turtleConfigId = m.readEventArgument(
    turtleConfigCall,
    "AIShipConfigCreated",
    "configId",
    { emitter: aiEncounters, id: "ReadTurtleConfigId" },
  );

  // No AI Rammer config: the AI has no decision path for Archetype.Rammer
  // (SinglePlayerMatch._decideMove falls through to the default
  // engage-or-approach logic for it, same as any unhandled archetype) —
  // player-controlled Rammer ships and RamResolver are unaffected.

  // Clustered vertically at column 13 — the leftmost (closest to the
  // human's side, columns 0-3) column in the joiner's legal 13-16 window —
  // centered exactly on the grid's vertical middle (row 5 of 0-10) across
  // these five rows, so the AI fleet spawns as close as possible to the
  // human rather than spread across the top of its zone.
  const placeStarterAIFleetCall = m.call(
    aiEncounters,
    "setMapPlacements",
    [
      starterMapId,
      [
        { row: 3, col: 13 },
        { row: 4, col: 13 },
        { row: 5, col: 13 },
        { row: 6, col: 13 },
        { row: 7, col: 13 },
      ],
      [
        gruntConfigId,
        aggressorConfigId,
        sniperConfigId,
        supportConfigId,
        turtleConfigId,
      ],
    ],
    { id: "PlaceStarterAIFleet", after: [starterMapCall] },
  );

  // --- Second starter map (nebula field) ----------------------------------
  // A second default single-player map, laid out with blocked "nebula"
  // tiles and five scoring tiles. createFullPresetMap (not the overloaded
  // createPresetMap) for the same Ignition-disambiguation reason
  // createPresetScoringMap exists above — see Maps.sol's comment on it.
  const nebulaMapCall = m.call(
    maps,
    "createFullPresetMap",
    [
      [
        { row: 0, col: 1 },
        { row: 0, col: 2 },
        { row: 0, col: 3 },
        { row: 0, col: 13 },
        { row: 0, col: 14 },
        { row: 0, col: 15 },
        { row: 0, col: 16 },
        { row: 1, col: 1 },
        { row: 1, col: 2 },
        { row: 1, col: 13 },
        { row: 1, col: 14 },
        { row: 1, col: 15 },
        { row: 1, col: 16 },
        { row: 2, col: 1 },
        { row: 2, col: 2 },
        { row: 2, col: 13 },
        { row: 2, col: 14 },
        { row: 2, col: 15 },
        { row: 3, col: 2 },
        { row: 3, col: 8 },
        { row: 3, col: 9 },
        { row: 3, col: 11 },
        { row: 3, col: 12 },
        { row: 3, col: 13 },
        { row: 4, col: 2 },
        { row: 4, col: 9 },
        { row: 6, col: 7 },
        { row: 6, col: 14 },
        { row: 7, col: 3 },
        { row: 7, col: 4 },
        { row: 7, col: 5 },
        { row: 7, col: 7 },
        { row: 7, col: 8 },
        { row: 7, col: 14 },
        { row: 8, col: 1 },
        { row: 8, col: 2 },
        { row: 8, col: 3 },
        { row: 8, col: 14 },
        { row: 8, col: 15 },
        { row: 9, col: 0 },
        { row: 9, col: 1 },
        { row: 9, col: 2 },
        { row: 9, col: 3 },
        { row: 9, col: 14 },
        { row: 9, col: 15 },
        { row: 10, col: 0 },
        { row: 10, col: 1 },
        { row: 10, col: 2 },
        { row: 10, col: 3 },
        { row: 10, col: 13 },
        { row: 10, col: 14 },
        { row: 10, col: 15 },
      ],
      [
        { row: 0, col: 9, points: 10, onlyOnce: false },
        { row: 1, col: 3, points: 10, onlyOnce: false },
        { row: 5, col: 8, points: 10, onlyOnce: false },
        { row: 9, col: 13, points: 10, onlyOnce: false },
        { row: 10, col: 7, points: 10, onlyOnce: false },
      ],
    ],
    // Ignition doesn't guarantee execution order between independent calls
    // (see the leaveLobby/timeoutJoiner comments elsewhere in this repo for
    // the same lesson) — force this after starterMapCall so mapCount is
    // deterministically 1 (starter) then 2 (nebula), matching nebulaMapId
    // below. Without this, the two calls could execute in either order and
    // swap which map ends up as id 1 vs 2.
    { id: "CreateNebulaSinglePlayerMap", after: [starterMapCall] },
  );
  // Same reasoning as starterMapId: no event/staticCall to read the new id
  // from, but this is the second map-creation call in the module against a
  // fresh Maps deployment, so mapCount is 2 once this executes.
  const nebulaMapId = 2n;

  // Clustered the same way as the starter map's fleet: column 13 is
  // nebula-blocked at rows 0-3 and 10 on this map (see the blocked list
  // above), so rows 4-8 — the best-centered 5-row window inside the only
  // fully-open band (4-9) at that column — is used instead of the starter
  // map's exactly-centered 3-7.
  const placeNebulaAIFleetCall = m.call(
    aiEncounters,
    "setMapPlacements",
    [
      nebulaMapId,
      [
        { row: 4, col: 13 },
        { row: 5, col: 13 },
        { row: 6, col: 13 },
        { row: 7, col: 13 },
        { row: 8, col: 13 },
      ],
      [
        gruntConfigId,
        aggressorConfigId,
        sniperConfigId,
        supportConfigId,
        turtleConfigId,
      ],
    ],
    { id: "PlaceNebulaAIFleet", after: [nebulaMapCall] },
  );

  // Set PvPMatch address in Lobbies contract
  const setLobbiesPvpMatchAddressCall = m.call(lobbies, "setPvpMatchAddress", [
    pvpMatch,
  ]);

  // Set Lobbies address in PvPMatch contract
  const setPvpMatchLobbiesAddressCall = m.call(pvpMatch, "setLobbiesAddress", [
    lobbies,
  ]);

  // Set SinglePlayerMatch address in Lobbies contract, and recognize it as a
  // single-player orchestrator (createFleet dispatches to it instead of
  // PvPMatch when a lobby's joiner is this address)
  const setLobbiesSinglePlayerMatchAddressCall = m.call(
    lobbies,
    "setSinglePlayerMatchAddress",
    [singlePlayerMatch],
  );
  const recognizeSinglePlayerMatchCall = m.call(
    lobbies,
    "setIsSinglePlayerOrchestrator",
    [singlePlayerMatch, true],
    { id: "RecognizeSinglePlayerMatch" },
  );

  // Allow SinglePlayerMatch to mint/construct its own fleet
  const allowSinglePlayerMatchToCreateShipsCall = m.call(
    ships,
    "setIsAllowedToCreateShips",
    [singlePlayerMatch, true],
    { id: "AllowSinglePlayerMatchToCreateShips" },
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

  // Set Lobbies address in Fleets contract
  const setFleetsLobbiesAddressCall = m.call(fleets, "setLobbiesAddress", [
    lobbies,
  ]);

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

  // Tutorial ships use trait variants 1–3; default maxVariant is 1
  const setMaxVariantForTutorialShipsCall = m.call(
    ships,
    "setMaxVariant",
    [3],
    {
      id: "SetMaxVariantForTutorialShips",
    },
  );

  // Enable minting for UniversalCredits
  const setMintIsActiveCall = m.call(universalCredits, "setMintIsActive", [
    true,
  ]);

  // Allow ShipPurchaser and Ships to mint UniversalCredits
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

  // Enable minting for DroneEnergyCores and allow Ships (via
  // DestroyRewardLib) to mint it
  const setDecMintIsActiveCall = m.call(droneEnergyCores, "setMintIsActive", [
    true,
  ]);
  const authorizeShipsToMintDecCall = m.call(
    droneEnergyCores,
    "setAuthorizedToMint",
    [ships, true],
    { id: "AuthorizeShipsToMintDec" },
  );

  // DEC is soulbound except to/from this address — makes it spendable at
  // DroneStorefront (a stub for now) instead of fully unspendable.
  const setDecTransferExemptAddressCall = m.call(
    droneEnergyCores,
    "setTransferExemptAddress",
    [droneStorefront],
  );

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
        allowSinglePlayerMatchToCreateShipsCall,
        allowShipPurchaserToCreateShipsCall,
        allowDroneYardToModifyShipsCall,
        allowTutorialClaimToCreateShipsCall,
        allowFirebaseFlowMinterToCreateShipsCall,
        setMaxVariantForTutorialShipsCall,
      ],
    });

    m.call(shipAttributes, "transferOwnership", [MAP_EDITOR], {
      id: "TransferShipAttributesOwnership",
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
        starterMapCall,
        nebulaMapCall,
      ],
    });

    m.call(aiEncounters, "transferOwnership", [MAP_EDITOR], {
      id: "TransferAIEncountersOwnership",
      after: [
        allowAIEncounterEditorCall,
        gruntConfigCall,
        aggressorConfigCall,
        sniperConfigCall,
        supportConfigCall,
        turtleConfigCall,
        placeStarterAIFleetCall,
        placeNebulaAIFleetCall,
      ],
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
      ],
    });

    m.call(fleets, "transferOwnership", [MAP_EDITOR], {
      id: "TransferFleetsOwnership",
      after: [
        setFleetsLobbiesAddressCall,
        setFleetsGameAddressCall,
        setFleetsShipAttributesCall,
      ],
    });

    m.call(lobbies, "transferOwnership", [MAP_EDITOR], {
      id: "TransferLobbiesOwnership",
      after: [
        setLobbiesPvpMatchAddressCall,
        setLobbiesSinglePlayerMatchAddressCall,
        recognizeSinglePlayerMatchCall,
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

    m.call(universalCredits, "transferOwnership", [MAP_EDITOR], {
      id: "TransferUniversalCreditsOwnership",
      after: [
        setMintIsActiveCall,
        authorizeShipPurchaserToMintCall,
        authorizeShipsToMintCall,
      ],
    });

    m.call(droneEnergyCores, "transferOwnership", [MAP_EDITOR], {
      id: "TransferDroneEnergyCoresOwnership",
      after: [
        setDecMintIsActiveCall,
        authorizeShipsToMintDecCall,
        setDecTransferExemptAddressCall,
      ],
    });

    m.call(droneStorefront, "transferOwnership", [MAP_EDITOR], {
      id: "TransferDroneStorefrontOwnership",
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
    metadataRenderer,
    shipNames,
    generateNewShip,
    ships,
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
    tutorialClaim,
    worldId,
    tournament,
    gameBlobRegistry,
    specialEffectsLib,
    destroyRewardLib,
    ramResolver,
    aiEncounters,
  };
});

export default DeployModule;
