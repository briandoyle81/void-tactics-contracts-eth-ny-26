// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./IUniversalCredits.sol";
import "./IDroneEnergyCores.sol";
import "./ILobbiesOrchestratorCheck.sol";

// Decides which token rewards a ship kill in — external (not internal) so
// its bytecode is deployed separately instead of inlined into Ships.sol,
// which has almost no size headroom left (same reasoning as
// SpecialEffectsLib being split out of Game.sol).
library DestroyRewardLib {
    function payDestroyReward(
        address _lobbyAddress,
        address _destroyedShipOwner,
        address _destroyerOwner,
        uint _reward,
        IUniversalCredits _universalCredits,
        IDroneEnergyCores _droneEnergyCores
    ) external {
        // DEC (soulbound) when the destroyed ship was AI-owned — a player
        // beating the single-player AI — otherwise UTC as before.
        if (
            ILobbiesOrchestratorCheck(_lobbyAddress).isSinglePlayerOrchestrator(
                _destroyedShipOwner
            )
        ) {
            _droneEnergyCores.mint(_destroyerOwner, _reward);
        } else {
            _universalCredits.mint(_destroyerOwner, _reward);
        }
    }
}
