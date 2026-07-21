// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Implemented by whichever contract calls Game.startGame(...) for a given
// session (e.g. PvPMatch). Game.sol calls back into this on every session end
// (including draws) instead of assuming a specific results/leaderboard
// contract, so different game modes can each decide what "ended" means for
// them.
interface IGameOrchestrator {
    function onGameEnded(uint gameId, address winner, address loser) external;
}
