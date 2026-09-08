// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Minimal single-function view of DroneStorefront, used by Ships.sol to read
// a player's permanent free-ship bonus (droneCoreTier IS the bonus, 1 tier =
// +1 ship) without pulling in the rest of DroneStorefront's interface.
interface IDroneStorefront {
    function droneCoreTier(address _player) external view returns (uint8);
}
