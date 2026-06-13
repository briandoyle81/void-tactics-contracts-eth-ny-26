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

// World ID config. groupId 1 == Orb. The external nullifier is hash(appId,
// action); placeholder for local/tests.
const TOURNAMENT_WORLD_ID_GROUP = 1n;
const TOURNAMENT_EXTERNAL_NULLIFIER = 12345n;

const DeployTournamentModule = buildModule("DeployTournamentModule", (m) => {
  const base = m.useModule(DeployModule);

  // World ID router — mock for local/tests.
  const worldId = m.contract("MockWorldID");

  // For Base Sepolia testnet use the real World ID router instead, e.g.:
  // const worldId = "0x469449f251692e0779667583026b5a1e99512157";

  // Tournament reads canonical results from GameResults on the same chain.
  const tournament = m.contract("Tournament", [
    worldId,
    TOURNAMENT_WORLD_ID_GROUP,
    TOURNAMENT_EXTERNAL_NULLIFIER,
    base.gameResults,
    m.getAccount(4), // feeRecipient (protocol fee sink)
  ]);

  return { ...base, worldId, tournament };
});

export default DeployTournamentModule;
