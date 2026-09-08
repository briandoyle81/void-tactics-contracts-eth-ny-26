// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Implemented by ShatteredHiveMedalArt, referenced by ShatteredHiveMedal via
// an owner-settable address (not a constructor param) so the art can be
// swapped later without redeploying the medal contract itself — same
// swappable-renderer shape as IRenderMetadata/IImageRenderer. The medal has
// no traits/equipment to key art off of (see ShatteredHiveMedalArt.sol's
// header comment), so getSVG takes no arguments — every token renders the
// same image.
interface IShatteredHiveMedalArt {
    function getSVG() external pure returns (string memory);
}
