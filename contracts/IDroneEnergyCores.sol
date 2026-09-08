// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

interface IDroneEnergyCores {
    function mint(address _to, uint _amount) external;

    function transferFrom(
        address _from,
        address _to,
        uint _amount
    ) external returns (bool);

    function balanceOf(address _account) external view returns (uint);
}
