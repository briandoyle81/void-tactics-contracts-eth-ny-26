// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";

// Fixed-value stand-in for the two IShipAttributes functions
// DroneSwarmResolver/EMPResolver actually call — deliberately doesn't
// implement the rest of IShipAttributes, since Solidity doesn't require
// full interface compliance at the call site, only at the address cast.
contract MockShipAttributesSpecial {
    uint8 public range;
    uint8 public strength;

    constructor(uint8 _range, uint8 _strength) {
        range = _range;
        strength = _strength;
    }

    function getSpecialRange(
        Special /* _special */,
        uint16 /* _variant */
    ) external view returns (uint8) {
        return range;
    }

    function getSpecialStrength(
        Special /* _special */,
        uint16 /* _variant */
    ) external view returns (uint8) {
        return strength;
    }
}
