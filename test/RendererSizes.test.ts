import { expect } from "chai";
import fs from "fs";
import path from "path";

// Regression guard for the 24KB EIP-170 deployment cap (see CLAUDE.md: this
// check must never be bypassed). Variant 1's leaves already run close to
// this limit by design, and the renderer-pipeline automation under
// scripts/renderer-pipeline/ generates variant 2's leaves the same way, so
// this iterates every renderer contract -- both the hand-authored variant-1
// set and whatever variant-2 set exists -- rather than hardcoding either.
const CAP_BYTES = 24576;
const ARTIFACTS_ROOT = path.join(__dirname, "..", "artifacts", "contracts");

function deployedBytecodeSize(artifactJsonPath: string): number {
  const artifact = JSON.parse(fs.readFileSync(artifactJsonPath, "utf8"));
  return (artifact.deployedBytecode.length - 2) / 2;
}

function collectRendererArtifacts(): { name: string; artifactPath: string }[] {
  const found: { name: string; artifactPath: string }[] = [];

  // Per-piece leaf/combiner contracts live under contracts/Renderers* dirs.
  for (const entry of fs.readdirSync(ARTIFACTS_ROOT, { withFileTypes: true })) {
    if (!entry.isDirectory() || !entry.name.startsWith("Renderers")) continue;
    const dir = path.join(ARTIFACTS_ROOT, entry.name);
    for (const solDir of fs.readdirSync(dir)) {
      if (!solDir.endsWith(".sol")) continue;
      const contractName = solDir.replace(/\.sol$/, "");
      const artifactPath = path.join(dir, solDir, `${contractName}.json`);
      if (fs.existsSync(artifactPath)) {
        found.push({ name: `${entry.name}/${contractName}`, artifactPath });
      }
    }
  }

  // Top-level ImageRenderer* contracts (one per variant). Hardhat stores
  // each as a directory named after the source file, e.g.
  // artifacts/contracts/ImageRenderer.sol/ImageRenderer.json.
  for (const entry of fs.readdirSync(ARTIFACTS_ROOT, { withFileTypes: true })) {
    if (!entry.isDirectory() || !entry.name.match(/^ImageRenderer.*\.sol$/)) continue;
    const contractName = entry.name.replace(/\.sol$/, "");
    const artifactPath = path.join(ARTIFACTS_ROOT, entry.name, `${contractName}.json`);
    if (fs.existsSync(artifactPath)) {
      found.push({ name: contractName, artifactPath });
    }
  }

  return found;
}

describe("Renderer contract sizes stay under the EIP-170 cap", function () {
  const artifacts = collectRendererArtifacts();

  it("found at least the variant-1 renderer contracts to check", function () {
    expect(artifacts.length).to.be.greaterThan(20);
  });

  for (const { name, artifactPath } of artifacts) {
    it(`${name} deploys under ${CAP_BYTES} bytes`, function () {
      const size = deployedBytecodeSize(artifactPath);
      expect(size, `${name} is ${size} bytes`).to.be.at.most(CAP_BYTES);
    });
  }
});
