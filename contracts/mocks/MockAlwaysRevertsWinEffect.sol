// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../IWinEffect.sol";

// Test double for IWinEffect that always reverts — used to verify
// RoguelikeMatch/PvPMatch/Tournament's win-effect dispatch loops tolerate a
// broken resolver (try/catch'd, emits WinEffectFailed) instead of bricking
// the entire win, same intent as the game's other "one bad entry shouldn't
// take down the whole batch" mocks.
contract MockAlwaysRevertsWinEffect is IWinEffect {
    error AlwaysReverts();

    function onWin(address, uint) external pure override {
        revert AlwaysReverts();
    }
}
