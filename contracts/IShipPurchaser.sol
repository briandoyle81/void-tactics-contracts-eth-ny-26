// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IShipPurchaser {
    function tierPrices(uint _tier) external view returns (uint);
}
