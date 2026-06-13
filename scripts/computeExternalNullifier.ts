import { encodePacked, keccak256 } from "viem";

// Computes the World ID `externalNullifier` for the Tournament contract, matching
// what IDKit derives in the frontend. Run with:
//   npx hardhat run scripts/computeExternalNullifier.ts
// Override the inputs via env:
//   APP_ID=app_xxx ACTION=join-tournament npx hardhat run scripts/computeExternalNullifier.ts
//
// Reference (World ID ByteHasher):
//   hashToField(bytes)   = uint256(keccak256(bytes)) >> 8
//   externalNullifier    = hashToField(abi.encodePacked(hashToField(appId), action))

const appId = process.env.APP_ID || "app_b2739b54eb71ceb8c76380c60c20ce22";
const action = process.env.ACTION || "join-tournament";

const hashToField = (hex: `0x${string}`) => BigInt(keccak256(hex)) >> 8n;

const step1 = hashToField(encodePacked(["string"], [appId]));
const ext = hashToField(encodePacked(["uint256", "string"], [step1, action]));

console.log("appId:", appId);
console.log("action:", action);
console.log("externalNullifier (uint256):", ext.toString());
console.log("externalNullifier (hex):    ", "0x" + ext.toString(16));
