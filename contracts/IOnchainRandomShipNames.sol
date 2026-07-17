// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IOnchainRandomShipNames {
    function getRandomShipName(
        bytes32 _seed
    ) external view returns (string memory);
}
