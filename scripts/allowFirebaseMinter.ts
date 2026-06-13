import fs from "fs";
import path from "path";
import hre from "hardhat";
import { getAddress, isAddress } from "viem";

// Grants (or revokes) ship-minting rights for the Firebase Flow backend minter
// by calling `setIsAllowedToCreateShips(minter, allowed)` on an existing Ships
// deployment. Run from the Ships contract owner wallet.
//
// Usage:
//   npx hardhat run scripts/allowFirebaseMinter.ts --network base-sepolia
//   npx hardhat run scripts/allowFirebaseMinter.ts --network flow-testnet
//   npx hardhat run scripts/allowFirebaseMinter.ts --network ronin-saigon
//   npx hardhat run scripts/allowFirebaseMinter.ts --network xai-testnet
//
// Configuration via environment variables:
//   SHIPS_ADDRESS  Ships contract address. If omitted, the script reads it from
//                  ignition/deployments/chain-<id>/deployed_addresses.json.
//   MINTER_ADDRESS Address to authorize. Defaults to the Firebase Flow minter.
//   ALLOWED        "true" (default) to grant, "false" to revoke.

const DEFAULT_MINTER = "0x7f9dc2D68FF842EC79DA722B68E3ca7e5aa31CCb";

function resolveShipsAddress(chainId: number): `0x${string}` {
  const fromEnv = process.env.SHIPS_ADDRESS;
  if (fromEnv) {
    if (!isAddress(fromEnv)) {
      throw new Error(`SHIPS_ADDRESS is not a valid address: ${fromEnv}`);
    }
    return getAddress(fromEnv);
  }

  const addressesPath = path.join(
    __dirname,
    "..",
    "ignition",
    "deployments",
    `chain-${chainId}`,
    "deployed_addresses.json"
  );
  if (!fs.existsSync(addressesPath)) {
    throw new Error(
      `No SHIPS_ADDRESS provided and no deployment found at ${addressesPath}. ` +
        `Set SHIPS_ADDRESS=0x... to target an existing deployment.`
    );
  }
  const addresses = JSON.parse(fs.readFileSync(addressesPath, "utf8"));
  const shipsAddress = addresses["DeployModule#Ships"];
  if (!shipsAddress) {
    throw new Error(`Ships address missing in ${addressesPath}`);
  }
  return getAddress(shipsAddress);
}

async function main() {
  const minterRaw = process.env.MINTER_ADDRESS || DEFAULT_MINTER;
  if (!isAddress(minterRaw)) {
    throw new Error(`MINTER_ADDRESS is not a valid address: ${minterRaw}`);
  }
  const minter = getAddress(minterRaw);
  const allowed = (process.env.ALLOWED ?? "true").toLowerCase() !== "false";

  const publicClient = await hre.viem.getPublicClient();
  const [wallet] = await hre.viem.getWalletClients();
  const chainId = await publicClient.getChainId();
  const shipsAddress = resolveShipsAddress(chainId);

  const abi = (await hre.artifacts.readArtifact("Ships")).abi as any;

  console.log("setIsAllowedToCreateShips:", {
    chainId,
    ships: shipsAddress,
    minter,
    allowed,
    sender: wallet.account.address,
  });

  // Sanity check: only the owner can call this.
  try {
    const owner = (await publicClient.readContract({
      address: shipsAddress,
      abi,
      functionName: "owner",
      args: [],
    })) as `0x${string}`;
    if (getAddress(owner) !== getAddress(wallet.account.address)) {
      console.warn(
        `WARNING: sender ${wallet.account.address} is not the Ships owner (${owner}). ` +
          `The transaction will revert unless you control the owner wallet.`
      );
    }
  } catch {
    // owner() is expected to exist; ignore read failures and let the write surface errors.
  }

  // Skip if already in the desired state.
  const current = (await publicClient.readContract({
    address: shipsAddress,
    abi,
    functionName: "isAllowedToCreateShips",
    args: [minter],
  })) as boolean;
  if (current === allowed) {
    console.log(`Already set to allowed=${allowed}; nothing to do.`);
    return;
  }

  const { request } = await publicClient.simulateContract({
    address: shipsAddress,
    abi,
    functionName: "setIsAllowedToCreateShips",
    args: [minter, allowed],
    account: wallet.account,
  });
  const hash = await wallet.writeContract(request);
  console.log("Submitted tx:", hash);

  const receipt = await publicClient.waitForTransactionReceipt({ hash });
  console.log("Mined in block:", receipt.blockNumber, "status:", receipt.status);

  if (receipt.status !== "success") {
    throw new Error(`Transaction reverted: ${hash}`);
  }

  // The mined tx is the source of truth. Public RPC endpoints are often
  // load-balanced, so an immediate read can hit a replica that hasn't caught up
  // to the receipt's block yet and return stale state. Retry a few times before
  // giving up, and downgrade a persistent mismatch to a warning.
  let after = false;
  for (let attempt = 0; attempt < 6; attempt++) {
    // Pause before each read (including the first): the mined block needs a
    // moment to propagate across load-balanced RPC replicas.
    await new Promise((r) => setTimeout(r, 3000));
    after = (await publicClient.readContract({
      address: shipsAddress,
      abi,
      functionName: "isAllowedToCreateShips",
      args: [minter],
      blockTag: "latest",
    })) as boolean;
    if (after === allowed) break;
  }

  if (after === allowed) {
    console.log(`OK: isAllowedToCreateShips(${minter}) == ${after}`);
  } else {
    console.warn(
      `WARNING: read-back still shows isAllowedToCreateShips(${minter}) == ${after}, ` +
        `expected ${allowed}. The tx (${hash}) was mined successfully, so this is most ` +
        `likely RPC replica lag. Verify directly, e.g.:\n` +
        `  cast call ${shipsAddress} "isAllowedToCreateShips(address)(bool)" ${minter} --rpc-url <rpc>`
    );
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
