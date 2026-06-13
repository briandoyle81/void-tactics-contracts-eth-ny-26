// Tournament deployment module. Composes the full game deployment via
// `useModule` and adds the World ID router (mock for local/tests) and the
// Tournament contract on top.
//
// This is kept separate from DeployModule so that adding the Tournament/World ID
// deployments does not change DeployModule's deployment transaction sequence —
// the existing game tests rely on that sequence for deterministic ship-trait
// randomness (Hardhat's block.prevrandao).

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import DeployModule from "./DeployAndConfig";

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

const DeployTournamentModule = buildModule("DeployTournamentModule", (m) => {
  const base = m.useModule(DeployModule);

  // World ID router. Toggle between the two lines below (same pattern as
  // `shipNames` in DeployAndConfig):
  //   - Local / tests: deploy the mock (no real proofs available).
  //   - Real network:  comment the mock, uncomment the router address so the
  //                     Tournament is deployed pointing at the real router.
  // Base Sepolia (chain 84532) testnet WorldIDRouter, verified against World ID docs.
  const worldId = m.contract("MockWorldID");
  // const worldId = "0x42FF98C4E85212a5D31358ACbFe76a621b50fC02";

  // Tournament reads canonical results from GameResults on the same chain.
  // feeRecipient is the deployer (account 0); change via setFeeRecipient if needed.
  const tournament = m.contract("Tournament", [
    worldId,
    TOURNAMENT_WORLD_ID_GROUP,
    TOURNAMENT_EXTERNAL_NULLIFIER,
    base.gameResults,
    m.getAccount(0), // feeRecipient (protocol fee sink) == deployer
  ]);

  return { ...base, worldId, tournament };
});

export default DeployTournamentModule;
