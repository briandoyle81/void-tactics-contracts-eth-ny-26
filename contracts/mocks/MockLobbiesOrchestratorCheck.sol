// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../ILobbiesOrchestratorCheck.sol";

// Test double for ILobbiesOrchestratorCheck: an owner-settable "AI
// orchestrator" address, standing in for SinglePlayerMatch's identity check
// in ShipsRouter unit tests without needing to deploy the full contract.
contract MockLobbiesOrchestratorCheck is ILobbiesOrchestratorCheck {
    address public aiOrchestrator;

    function setAiOrchestrator(address _aiOrchestrator) external {
        aiOrchestrator = _aiOrchestrator;
    }

    function isSinglePlayerOrchestrator(
        address _address
    ) external view returns (bool) {
        return _address == aiOrchestrator;
    }
}
