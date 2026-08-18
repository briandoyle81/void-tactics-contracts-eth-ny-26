const fs = require("fs");
const path = require("path");

function processFile(filePath, utilsImport) {
  console.log(`Processing ${filePath}...`);

  const content = fs.readFileSync(filePath, "utf8");

  // Find the constant declaration and contract name
  const constantRegex = /string\s+private\s+constant\s+(\w+)\s*=\s*'([^']+)'/;
  const contractRegex = /contract\s+(\w+)/;
  const match = content.match(constantRegex);
  const contractMatch = content.match(contractRegex);

  if (!match || !contractMatch) {
    console.log("No SVG constant or contract found in file");
    return;
  }

  const [_, constantName, svgString] = match;
  const [__, contractName] = contractMatch;

  // First pass: Split the string by HSL colors and collect the parts
  const hslRegex = /hsl\([^)]+\)/g;
  const parts = svgString.split(hslRegex);

  // Second pass: Collect all HSL colors
  const colors = [];
  let hslMatch;
  while ((hslMatch = hslRegex.exec(svgString)) !== null) {
    colors.push(hslMatch[0]);
  }

  // Generate the new content
  let newContent =
    "// SPDX-License-Identifier: UNLICENSED\npragma solidity ^0.8.28;\n\n";

  // Add imports if they exist
  const importRegex = /import\s+[^;]+;/g;
  const imports = content.match(importRegex);
  if (imports) {
    newContent += imports.join("\n") + "\n";
  }

  // Add RenderUtils import
  newContent += `import "${utilsImport}";\n\n`;

  // Add the contract declaration
  newContent += `contract ${contractName} {\n`;

  // Add the parts
  parts.forEach((part, index) => {
    newContent += `    string private constant PART_${
      index + 1
    } = '${part}';\n`;
  });

  // Add the colors
  colors.forEach((color, index) => {
    newContent += `    string private constant COLOR_${
      index + 1
    } = '${color}';\n`;
  });

  // Add the render function with chunked concatenation and shiny handling
  newContent +=
    "\n    function render(Ship memory ship) external pure returns (string memory) {\n";

  // Create an array of all parts and colors in order
  let allParts = [];
  for (let i = 0; i < parts.length; i++) {
    allParts.push(`PART_${i + 1}`);
    if (i < colors.length) {
      // Add color with shiny check
      allParts.push(
        `ship.shipData.shiny ? blendHSL(ship.traits.colors.h1, ship.traits.colors.s1, ship.traits.colors.l1, COLOR_${
          i + 1
        }) : COLOR_${i + 1}`
      );
    }
  }

  // Fold allParts into a single running `result` accumulator, 7 new items
  // per string.concat call (plus `result` itself as the 8th argument once
  // it exists). Reusing one named local -- rather than a distinct variable
  // per chunk -- keeps this correct no matter how many parts a piece needs:
  // a fixed top-level string.concat(chunk1..chunkN) over many chunk
  // variables (or many simultaneously-live named locals from any chunking
  // scheme) blows Solidity's stack once N gets large, which a piece with
  // 100+ traced path fragments hits in practice. A single reassigned
  // accumulator only ever has one named local alive.
  const GROUP_SIZE = 7;
  let started = false;
  for (let i = 0; i < allParts.length; i += GROUP_SIZE) {
    const group = allParts.slice(i, i + GROUP_SIZE);
    const args = started ? ["result", ...group] : group;
    newContent += `        ${started ? "result" : "string memory result"} = string.concat(\n`;
    newContent += args.map((part) => `            ${part}`).join(",\n");
    newContent += "\n        );\n";
    started = true;
  }

  newContent += "        return result;\n";
  newContent += "    }\n}\n";

  // Write the new content back to the file
  fs.writeFileSync(filePath, newContent);
  console.log(`Updated ${filePath}`);
}

function main() {
  const utilsImportArg = process.argv.find((a) => a.startsWith("--utilsImport="));
  const utilsImport = utilsImportArg
    ? utilsImportArg.slice("--utilsImport=".length)
    : "./RenderUtils.sol";

  const fileArg = process.argv.find((a) => a.startsWith("--file="));
  if (fileArg) {
    const filePath = path.resolve(fileArg.slice("--file=".length));
    const backupPath = `${filePath}.original`;
    fs.copyFileSync(filePath, backupPath);
    console.log(`Created backup at ${backupPath}`);
    processFile(filePath, utilsImport);
    console.log("SVG string splitting complete!");
    return;
  }

  const dirArg = process.argv.find((a) => a.startsWith("--dir="));
  const renderersDir = dirArg
    ? path.resolve(dirArg.slice("--dir=".length))
    : path.join(__dirname, "../contracts/Renderers");
  const backupDir = dirArg
    ? `${renderersDir}_original`
    : path.join(__dirname, "/../Renderers_original");

  // Create backup directory if it doesn't exist
  if (!fs.existsSync(backupDir)) {
    fs.mkdirSync(backupDir, { recursive: true });
  }

  // Get all .sol files
  const files = fs
    .readdirSync(renderersDir)
    .filter((file) => file.endsWith(".sol"));

  console.log(`Found ${files.length} Solidity files to process`);

  // Process each file
  files.forEach((file) => {
    const filePath = path.join(renderersDir, file);
    const backupPath = path.join(backupDir, file);

    // Create backup before processing
    fs.copyFileSync(filePath, backupPath);
    console.log(`Created backup at ${backupPath}`);

    // Process the file
    processFile(filePath, utilsImport);
  });

  console.log("SVG string splitting complete!");
}

main();
