// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Minimal single-function view of Lobbies, used by Ships.sol to tell an
// AI-owned ship from a player-owned one via the already-stored
// config.lobbyAddress — kept to one function to avoid pulling in the full
// Lobbies interface just for this check.
interface ILobbiesOrchestratorCheck {
    function isSinglePlayerOrchestrator(
        address _address
    ) external view returns (bool);
}
