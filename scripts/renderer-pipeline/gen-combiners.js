const fs = require("fs");
const path = require("path");
const { loadManifest } = require("./lib/manifest");

// Manifest-driven codegen for the 5 "combiner" contracts (RenderAftV2,
// RenderForeV2, RenderWeaponV2, RenderBodyV2, RenderSpecialV2) and the
// top-level ImageRendererV2, matching the exact shape of the existing
// variant-1 combiners in contracts/Renderers/*.sol and contracts/ImageRenderer.sol
// (same import set, same IRenderComponent/IReturnSVG interfaces, same
// if/else dispatch style) so the generated contracts read like hand-written
// siblings of the variant-1 pipeline, not a foreign codegen output.

function leafExists(manifest, contractName) {
  return fs.existsSync(path.join(manifest._outputDir, `${contractName}.sol`));
}

function header() {
  return (
    `// SPDX-License-Identifier: UNLICENSED\n` +
    `pragma solidity ^0.8.28;\n\n` +
    `import "../Types.sol";\n` +
    `import "../IRenderer.sol";\n\n`
  );
}

function genAft(manifest) {
  const leaves = manifest.categories.aft.leaves.filter((l) => leafExists(manifest, l.contractName));
  const name = manifest.categories.aft.combinerContract;
  const fields = leaves.map((l, i) => `    IReturnSVG public immutable render${i};`).join("\n");
  const assigns = leaves.map((l, i) => `        render${i} = IReturnSVG(renderers[${i}]);`).join("\n");
  const dispatch = leaves
    .map((l, i) => {
      if (i === leaves.length - 1) return `        } else {\n            return render${i}.render(ship);\n        }`;
      return `${i === 0 ? "        if" : "        } else if"} (ship.traits.speed == ${i}) {\n            return render${i}.render(ship);`;
    })
    .join("\n");

  return (
    header() +
    `contract ${name} is IRenderComponent {\n` +
    `${fields}\n\n` +
    `    constructor(address[] memory renderers) {\n` +
    `        require(renderers.length == ${leaves.length}, "Invalid renderers array in ${name}");\n` +
    `${assigns}\n` +
    `    }\n\n` +
    `    function render(Ship memory ship) external view override returns (string memory) {\n` +
    `${dispatch}\n` +
    `    }\n` +
    `}\n`
  );
}

function genFore(manifest) {
  const cat = manifest.categories.fore;
  const tiers = cat.leaves.filter((l) => !l.contractName.toLowerCase().includes("perfect") && leafExists(manifest, l.contractName));
  const perfectLeaf = cat.leaves.find((l) => l.contractName.toLowerCase().includes("perfect"));
  const hasPerfect = perfectLeaf && leafExists(manifest, perfectLeaf.contractName);
  const name = cat.combinerContract;

  const allLeaves = hasPerfect ? [...tiers, perfectLeaf] : tiers;
  const fields = allLeaves
    .map((l, i) => `    IReturnSVG public immutable render${i}; // ${l.contractName}`)
    .join("\n");
  const assigns = allLeaves.map((l, i) => `        render${i} = IReturnSVG(renderers[${i}]);`).join("\n");

  const perfectIdx = hasPerfect ? tiers.length : null;
  const perfectBranch = hasPerfect
    ? `        if (\n` +
      `            ship.traits.accuracy == 2 &&\n` +
      `            ship.traits.hull == 2 &&\n` +
      `            ship.traits.speed == 2 &&\n` +
      `            (ship.equipment.armor == Armor.Heavy ||\n` +
      `                ship.equipment.shields == Shields.Heavy)\n` +
      `        ) {\n` +
      `            return render${perfectIdx}.render(ship);\n` +
      `        }\n`
    : "";

  const tierDispatch = tiers
    .map((l, i) => {
      if (i === tiers.length - 1) return `        } else {\n            return render${i}.render(ship);\n        }`;
      return `${i === 0 ? "        if" : "        } else if"} (ship.traits.accuracy == ${i}) {\n            return render${i}.render(ship);`;
    })
    .join("\n");

  return (
    header() +
    `contract ${name} is IRenderComponent {\n` +
    `${fields}\n\n` +
    `    constructor(address[] memory renderers) {\n` +
    `        require(renderers.length == ${allLeaves.length}, "Invalid renderers array in ${name}");\n` +
    `${assigns}\n` +
    `    }\n\n` +
    `    function render(Ship memory ship) external view override returns (string memory) {\n` +
    `${perfectBranch}` +
    `${tierDispatch}\n` +
    `    }\n` +
    `}\n`
  );
}

function genWeapon(manifest) {
  const cat = manifest.categories.weapon;
  const leaves = cat.leaves.filter((l) => leafExists(manifest, l.contractName));
  const name = cat.combinerContract;
  const fields = leaves.map((l, i) => `    IReturnSVG public immutable render${i}; // ${l.enumValue}`).join("\n");
  const assigns = leaves.map((l, i) => `        render${i} = IReturnSVG(renderers[${i}]);`).join("\n");
  const dispatch = leaves
    .map(
      (l, i) =>
        `        ${i === 0 ? "if" : "} else if"} (ship.equipment.mainWeapon == ${l.enumValue}) {\n            return render${i}.render(ship);`
    )
    .join("\n");

  return (
    header() +
    `contract ${name} is IRenderComponent {\n` +
    `${fields}\n\n` +
    `    constructor(address[] memory renderers) {\n` +
    `        require(renderers.length == ${leaves.length}, "Invalid renderers array in ${name}");\n` +
    `${assigns}\n` +
    `    }\n\n` +
    `    function render(Ship memory ship) external view override returns (string memory) {\n` +
    `${dispatch}\n` +
    `        }\n` +
    `        return "";\n` +
    `    }\n` +
    `}\n`
  );
}

function genBody(manifest) {
  const cat = manifest.categories.body;
  const base = cat.base;
  const shields = cat.shields.filter((l) => leafExists(manifest, l.contractName));
  const armor = cat.armor.filter((l) => leafExists(manifest, l.contractName));
  const name = cat.combinerContract;

  const all = [base, ...shields, ...armor];
  const fields = all
    .map((l, i) => `    IReturnSVG public immutable render${i}; // ${l.contractName}`)
    .join("\n");
  const assigns = all.map((l, i) => `        render${i} = IReturnSVG(renderers[${i}]);`).join("\n");

  const shieldOffset = 1;
  const armorOffset = 1 + shields.length;
  const shieldDispatch = shields
    .map(
      (l, i) =>
        `            ${i === 0 ? "if" : "} else if"} (ship.equipment.shields == ${l.enumValue}) {\n                return render${shieldOffset + i}.render(ship);`
    )
    .join("\n");
  const armorDispatch = armor
    .map(
      (l, i) =>
        `            ${i === 0 ? "if" : "} else if"} (ship.equipment.armor == ${l.enumValue}) {\n                return render${armorOffset + i}.render(ship);`
    )
    .join("\n");

  return (
    header() +
    `contract ${name} is IRenderComponent {\n` +
    `${fields}\n\n` +
    `    constructor(address[] memory renderers) {\n` +
    `        require(renderers.length == ${all.length}, "Invalid renderers array in ${name}");\n` +
    `${assigns}\n` +
    `    }\n\n` +
    `    function render(Ship memory ship) external view override returns (string memory) {\n` +
    `        if (\n` +
    `            ship.equipment.shields == Shields.None &&\n` +
    `            ship.equipment.armor == Armor.None\n` +
    `        ) {\n` +
    `            return render0.render(ship);\n` +
    `        }\n\n` +
    `        if (ship.equipment.shields != Shields.None) {\n` +
    `${shieldDispatch}\n` +
    `            }\n` +
    `        }\n\n` +
    `        if (ship.equipment.armor != Armor.None) {\n` +
    `${armorDispatch}\n` +
    `            }\n` +
    `        }\n\n` +
    `        return render0.render(ship);\n` +
    `    }\n` +
    `}\n`
  );
}

function genSpecial(manifest) {
  const cat = manifest.categories.special;
  const leaves = cat.leaves.filter((l) => leafExists(manifest, l.contractName));
  const name = cat.combinerContract;
  const fields = leaves.map((l, i) => `    IReturnSVG public immutable render${i}; // ${l.enumValue}`).join("\n");
  const assigns = leaves.map((l, i) => `        render${i} = IReturnSVG(renderers[${i}]);`).join("\n");
  const dispatch = leaves
    .map(
      (l, i) =>
        `        } else if (ship.equipment.special == ${l.enumValue}) {\n            return render${i}.render(ship);`
    )
    .join("\n");

  return (
    header() +
    `contract ${name} is IRenderComponent {\n` +
    `${fields}\n\n` +
    `    constructor(address[] memory renderers) {\n` +
    `        require(renderers.length == ${leaves.length}, "Invalid renderers array in ${name}");\n` +
    `${assigns}\n` +
    `    }\n\n` +
    `    function render(Ship memory ship) external view override returns (string memory) {\n` +
    `        if (ship.equipment.special == Special.None) {\n` +
    `            return "";\n` +
    `${dispatch}\n` +
    `        }\n` +
    `        return "";\n` +
    `    }\n` +
    `}\n`
  );
}

function genImageRenderer(manifest, imageRendererName, combinerImportDir) {
  const combiners = [
    manifest.categories.special.combinerContract,
    manifest.categories.aft.combinerContract,
    manifest.categories.weapon.combinerContract,
    manifest.categories.body.combinerContract,
    manifest.categories.fore.combinerContract,
  ];
  const [special, aft, weapon, body, fore] = combiners;

  return (
    `// SPDX-License-Identifier: UNLICENSED\n` +
    `pragma solidity ^0.8.28;\n\n` +
    `import "./Types.sol";\n` +
    `import "./IRenderer.sol";\n` +
    `import "./${combinerImportDir}/${special}.sol";\n` +
    `import "./${combinerImportDir}/${aft}.sol";\n` +
    `import "./${combinerImportDir}/${weapon}.sol";\n` +
    `import "./${combinerImportDir}/${body}.sol";\n` +
    `import "./${combinerImportDir}/${fore}.sol";\n` +
    `import "@openzeppelin/contracts/utils/Strings.sol";\n` +
    `import "@openzeppelin/contracts/utils/Base64.sol";\n\n` +
    `contract ${imageRendererName} is IImageRenderer {\n` +
    `    using Strings for string;\n\n` +
    `    string private constant BASE_SVG =\n` +
    `        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" width="256" height="256">';\n` +
    `    string private constant SVG_END = "</svg>";\n\n` +
    `    string private constant UNCONSTRUCTED_IMAGE =\n` +
    `        "ipfs://bafkreibc3fdrdsw4l7zy4wjrgalvfhg6kfd3wmijwefny3nxj5244x2tr4";\n` +
    `    string private constant DESTROYED_IMAGE =\n` +
    `        "ipfs://bafkreige3z6iopsmgyzefidhydbaikpipxwrstqzuylw2y2c4rvwnn6yvm";\n\n` +
    `    IRenderComponent public immutable renderSpecial;\n` +
    `    IRenderComponent public immutable renderAft;\n` +
    `    IRenderComponent public immutable renderWeapon;\n` +
    `    IRenderComponent public immutable renderBody;\n` +
    `    IRenderComponent public immutable renderFore;\n\n` +
    `    constructor(\n` +
    `        address _renderSpecial,\n` +
    `        address _renderAft,\n` +
    `        address _renderWeapon,\n` +
    `        address _renderBody,\n` +
    `        address _renderFore\n` +
    `    ) {\n` +
    `        renderSpecial = IRenderComponent(_renderSpecial);\n` +
    `        renderAft = IRenderComponent(_renderAft);\n` +
    `        renderWeapon = IRenderComponent(_renderWeapon);\n` +
    `        renderBody = IRenderComponent(_renderBody);\n` +
    `        renderFore = IRenderComponent(_renderFore);\n` +
    `    }\n\n` +
    `    function renderShip(Ship memory ship) public view override returns (string memory) {\n` +
    `        if (ship.shipData.timestampDestroyed > 0) {\n` +
    `            return DESTROYED_IMAGE;\n` +
    `        } else if (!ship.shipData.constructed) {\n` +
    `            return UNCONSTRUCTED_IMAGE;\n` +
    `        }\n\n` +
    `        string memory svg = BASE_SVG;\n` +
    `        svg = string.concat(svg, renderSpecial.render(ship));\n` +
    `        svg = string.concat(svg, renderAft.render(ship));\n` +
    `        svg = string.concat(svg, renderWeapon.render(ship));\n` +
    `        svg = string.concat(svg, renderBody.render(ship));\n` +
    `        svg = string.concat(svg, renderFore.render(ship));\n` +
    `        svg = string.concat(svg, SVG_END);\n\n` +
    `        string memory base64Svg = Base64.encode(bytes(svg));\n` +
    `        return\n` +
    `            string(abi.encodePacked("data:image/svg+xml;base64,", base64Svg));\n` +
    `    }\n` +
    `}\n`
  );
}

function genAll(manifestPath, { imageRendererName = "ImageRendererV2", imageRendererDir } = {}) {
  const manifest = loadManifest(manifestPath);
  fs.mkdirSync(manifest._outputDir, { recursive: true });

  const written = [];
  const combiners = {
    [manifest.categories.aft.combinerContract]: genAft(manifest),
    [manifest.categories.fore.combinerContract]: genFore(manifest),
    [manifest.categories.weapon.combinerContract]: genWeapon(manifest),
    [manifest.categories.body.combinerContract]: genBody(manifest),
    [manifest.categories.special.combinerContract]: genSpecial(manifest),
  };
  for (const [name, src] of Object.entries(combiners)) {
    const outPath = path.join(manifest._outputDir, `${name}.sol`);
    fs.writeFileSync(outPath, src);
    written.push(outPath);
    console.log(`[gen-combiners] wrote ${outPath}`);
  }

  const imgDir = imageRendererDir || path.join(manifest._repoRoot, "contracts");
  const combinerImportDir = path.relative(path.join(manifest._repoRoot, "contracts"), manifest._outputDir);
  const imgSrc = genImageRenderer(manifest, imageRendererName, combinerImportDir);
  const imgPath = path.join(imgDir, `${imageRendererName}.sol`);
  fs.writeFileSync(imgPath, imgSrc);
  written.push(imgPath);
  console.log(`[gen-combiners] wrote ${imgPath}`);

  return written;
}

function main() {
  const manifestPath = process.argv[2];
  const imageRendererName = process.argv[3];
  if (!manifestPath) {
    console.error("Usage: node gen-combiners.js <manifest.json> [imageRendererName]");
    process.exit(1);
  }
  genAll(manifestPath, imageRendererName ? { imageRendererName } : {});
}

if (require.main === module) {
  main();
}

module.exports = { genAll };
