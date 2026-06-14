import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

// Firebase Flow backend minter — same address granted ship-creation rights.
const FIREBASE_FLOW_MINTER = "0x7f9dc2D68FF842EC79DA722B68E3ca7e5aa31CCb";

// Already-deployed GameResults addresses by chain. Supply the correct one for
// the target network via the GAME_RESULTS_ADDRESS env var, or add a hardcoded
// entry for your chain below.
const GAME_RESULTS_BY_CHAIN: Record<number, string> = {
  84532:      "0x1f341c690C5AaA61D06736AD67937385a76f1FE2", // Base Sepolia
  202601:     "", // Flow testnet — fill in if needed
  37714555429:"", // Ronin Saigon — fill in if needed
};

const GameBlobRegistryModule = buildModule("GameBlobRegistryModule", (m) => {
  const chainId = Number(process.env.CHAIN_ID ?? 84532);
  const defaultGameResults = GAME_RESULTS_BY_CHAIN[chainId] ?? "";

  const gameResultsAddress = m.getParameter(
    "gameResultsAddress",
    defaultGameResults as `0x${string}`
  );

  const authorizedWriter = m.getParameter(
    "authorizedWriter",
    FIREBASE_FLOW_MINTER as `0x${string}`
  );

  const gameBlobRegistry = m.contract("GameBlobRegistry", [
    gameResultsAddress,
    authorizedWriter,
  ]);

  return { gameBlobRegistry };
});

export default GameBlobRegistryModule;
