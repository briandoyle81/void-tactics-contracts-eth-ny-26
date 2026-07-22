// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseEther } from "viem";

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

  // Mock for local/tests — Ignition + viem require a contract future, not a string address.
  const shipNames = m.contract("MockOnchainRandomShipNames");

  // For Flow testnet use
  // const shipNames = "0x9E433A07D283d56E8243EA25b7358521b1922df5";

  // For Ronin Saigon testnet use
  // const shipNames = "0x3866a81241Ec61414a3A7A99486f6652fFd0743C";

  // For XAI testnet use
  // const shipNames = "0xe7266c681ce3F8CD8853141139574F2CA70AA165";

  // For Base Sepolia testnet use
  // const shipNames = "0x2b6C2e73D7D8B9dd49aF848B7A19FF003ED0d779";

  // Deploy GenerateNewShip with ship names
  const generateNewShip = m.contract("GenerateNewShip", [shipNames]);

  // Deploy UniversalCredits token
  const universalCredits = m.contract("UniversalCredits");

  // Finally deploy Ships with all dependencies
  const ships = m.contract("Ships", [metadataRenderer]);

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
  m.call(ships, "setConfig", [
    game, // gameAddress
    lobbies, // lobbyAddress
    fleets, // fleetsAddress
    generateNewShip,
    randomManager,
    metadataRenderer,
    shipAttributes, // shipAttributes
    universalCredits, // universalCredits
  ]);

  // Set all addresses in Game contract (Fleets/Maps/ShipAttributes stay core
  // dependencies; Lobbies/GameResults moved to PvPMatch)
  m.call(game, "setAddresses", [maps, fleets, shipAttributes]);

  // Authorize PvPMatch and SinglePlayerMatch to start/force-end sessions on
  // core Game.sol
  m.call(game, "setIsAllowedToStartGames", [pvpMatch, true], {
    id: "AllowPvPMatchToStartGames",
  });
  m.call(game, "setIsAllowedToStartGames", [singlePlayerMatch, true], {
    id: "AllowSinglePlayerMatchToStartGames",
  });

  // Wire RamResolver in as the faction ability resolver for faction 1
  m.call(game, "setFactionAbilityResolver", [1, ramResolver]);

  // Set PvPMatch contract address in GameResults contract (PvPMatch now
  // records PvP results, not core Game.sol)
  m.call(gameResults, "setGameContract", [pvpMatch]);

  // Set Game address in Maps contract
  m.call(maps, "setGameAddress", [game]);

  // Allow the designated map editor wallet to create/edit preset maps
  m.call(maps, "setMapEditor", [MAP_EDITOR, true], {
    id: "AllowMapEditor",
  });

  // Reuse the same map-editor wallet as the AI-encounters content admin
  m.call(aiEncounters, "setEncounterEditor", [MAP_EDITOR, true], {
    id: "AllowAIEncounterEditor",
  });

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

  const rammerConfigCall = m.call(
    aiEncounters,
    "createAIShipConfig",
    [
      "AI Rammer",
      { mainWeapon: 3, armor: 3, shields: 0, special: 0 }, // PlasmaCannon, Heavy armor
      {
        serialNumber: 0n,
        colors: AI_SHIP_COLORS,
        variant: 1, // Rammer only attempts Ram when variant == 1 (faction 1)
        accuracy: 0,
        hull: 1,
        speed: 1,
      },
      5, // Archetype.Rammer
    ],
    { id: "CreateRammerAIShipConfig" },
  );
  const rammerConfigId = m.readEventArgument(
    rammerConfigCall,
    "AIShipConfigCreated",
    "configId",
    { emitter: aiEncounters, id: "ReadRammerConfigId" },
  );

  // Row-major placement across the joiner's allowed columns (13-16),
  // matching AIEncounters' placement constraints.
  m.call(
    aiEncounters,
    "setMapPlacements",
    [
      starterMapId,
      [
        { row: 0, col: 13 },
        { row: 0, col: 14 },
        { row: 0, col: 15 },
        { row: 0, col: 16 },
        { row: 1, col: 13 },
        { row: 1, col: 14 },
      ],
      [
        gruntConfigId,
        aggressorConfigId,
        sniperConfigId,
        supportConfigId,
        turtleConfigId,
        rammerConfigId,
      ],
    ],
    { id: "PlaceStarterAIFleet", after: [starterMapCall] },
  );

  // Set PvPMatch address in Lobbies contract
  m.call(lobbies, "setPvpMatchAddress", [pvpMatch]);

  // Set Lobbies address in PvPMatch contract
  m.call(pvpMatch, "setLobbiesAddress", [lobbies]);

  // Set SinglePlayerMatch address in Lobbies contract, and recognize it as a
  // single-player orchestrator (createFleet dispatches to it instead of
  // PvPMatch when a lobby's joiner is this address)
  m.call(lobbies, "setSinglePlayerMatchAddress", [singlePlayerMatch]);
  m.call(lobbies, "setIsSinglePlayerOrchestrator", [singlePlayerMatch, true], {
    id: "RecognizeSinglePlayerMatch",
  });

  // Allow SinglePlayerMatch to mint/construct its own fleet
  m.call(ships, "setIsAllowedToCreateShips", [singlePlayerMatch, true], {
    id: "AllowSinglePlayerMatchToCreateShips",
  });

  // Set Fleets address in Lobbies contract
  m.call(lobbies, "setFleetsAddress", [fleets]);

  // Set Maps address in Lobbies contract
  m.call(lobbies, "setMapsAddress", [maps]);

  // Set UniversalCredits address in Lobbies contract
  m.call(lobbies, "setUniversalCreditsAddress", [universalCredits]);

  // Set Lobbies address in Fleets contract
  m.call(fleets, "setLobbiesAddress", [lobbies]);

  // Set Game address in Fleets contract
  m.call(fleets, "setGameAddress", [game]);

  // Set ShipAttributes address in Fleets contract
  m.call(fleets, "setShipAttributes", [shipAttributes]);

  // Allow ShipPurchaser to create ships
  m.call(ships, "setIsAllowedToCreateShips", [shipPurchaser, true]);

  // Allow DroneYard to modify ships
  m.call(ships, "setIsAllowedToCreateShips", [droneYard, true], {
    id: "AllowDroneYardToModifyShips",
  });

  m.call(ships, "setIsAllowedToCreateShips", [tutorialClaim, true], {
    id: "AllowTutorialClaimToCreateShips",
  });

  // Allow the Firebase Flow backend minter to create ships (same as ShipPurchaser)
  m.call(ships, "setIsAllowedToCreateShips", [FIREBASE_FLOW_MINTER, true], {
    id: "AllowFirebaseFlowMinterToCreateShips",
  });

  m.call(gameResults, "setTutorialClaimContract", [tutorialClaim], {
    id: "SetTutorialClaimOnGameResults",
  });

  // Tutorial ships use trait variants 1–3; default maxVariant is 1
  m.call(ships, "setMaxVariant", [3], {
    id: "SetMaxVariantForTutorialShips",
  });

  // Enable minting for UniversalCredits
  m.call(universalCredits, "setMintIsActive", [true]);

  // Allow ShipPurchaser and Ships to mint UniversalCredits
  m.call(universalCredits, "setAuthorizedToMint", [shipPurchaser, true], {
    id: "AuthorizeShipPurchaserToMint",
  });
  m.call(universalCredits, "setAuthorizedToMint", [ships, true], {
    id: "AuthorizeShipsToMint",
  });

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
  //                     Tournament is deployed pointing at the real router.
  // Base Sepolia (chain 84532) testnet WorldIDRouter, verified against World ID docs.
  const worldId = m.contract("MockWorldID");
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
    ramResolver,
    aiEncounters,
  };
});

export default DeployModule;
