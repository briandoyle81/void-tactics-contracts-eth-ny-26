// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Ship} from "./Types.sol";

interface IRenderComponent {
    function render(Ship memory ship) external view returns (string memory);
}

interface IReturnSVG {
    function render(Ship memory ship) external view returns (string memory);
}

interface IRenderMetadata {
    function tokenURI(Ship memory ship) external view returns (string memory);
}

// Implemented by ImageRenderer (variant 1) and any per-variant equivalent
// (e.g. ImageRendererV2), so RenderMetadata can hold one per variant without
// depending on the concrete type of each -- letting a new variant's image
// renderer be wired in once its art pipeline exists, without touching this
// interface or the ones above.
interface IImageRenderer {
    function renderShip(Ship memory ship) external view returns (string memory);
}
