// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";

interface IDroneNames {
    function getRandomDroneName(
        bytes32 _seed,
        MainWeapon _weapon
    ) external pure returns (string memory);
}
