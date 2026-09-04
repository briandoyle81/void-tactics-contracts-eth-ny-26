// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Types.sol";
import "./Game.sol";
import "./IGameResults.sol";
import "./IGameOrchestrator.sol";
import "./IWinEffect.sol";

// PvP-specific orchestration split out of Game.sol: this is what Lobbies
// talks to for starting a match, and it owns human-forfeit mechanics
// (flee/timeout) and PvP leaderboard recording. Core combat/movement stays
// entirely in Game.sol, unmodified — this contract just drives it, exactly
// like a human wallet or any other authorized orchestrator would.
contract PvPMatch is Ownable, IGameOrchestrator {
    Game public game;
    IGameResults public gameResults;
    address public lobbiesAddress;

    // Pluggable win effects (see IWinEffect.sol) — fires for the winner of
    // every non-draw PvP match, same mechanism roguelike combat nodes use
    // via RoguelikeNodeMap's per-node list. PvP has no curated per-instance
    // content the way roguelike nodes do, so this is one flat list rather
    // than per-map/per-lobby — empty by default (opt-in), same as a
    // roguelike node with nothing configured.
    // Private + explicit getter (not a bare public array) so callers get a
    // full-array read in one call, matching RoguelikeNodeMap.
    // getNodeWinEffects — a public array only auto-generates an index
    // accessor, not a length/full-array getter.
    address[] private winEffects;

    error NotGame();
    error NotLobbiesContract();
    error TurnTimeoutNotReached();
    error NotInGame();
    error InvalidMove();

    event WinEffectsSet(uint effectCount);
    event WinEffectFailed(
        address indexed player,
        uint indexed gameId,
        address indexed resolver
    );

    constructor(address _game, address _gameResults) Ownable(msg.sender) {
        game = Game(_game);
        gameResults = IGameResults(_gameResults);
    }

    function setLobbiesAddress(address _lobbiesAddress) external onlyOwner {
        lobbiesAddress = _lobbiesAddress;
    }

    /// @dev Full-replace the win-effect list, same "full replace, not
    /// add/remove" shape as RoguelikeNodeMap.setNodeWinEffects.
    function setWinEffects(address[] calldata _effects) external onlyOwner {
        winEffects = _effects;
        emit WinEffectsSet(_effects.length);
    }

    function getWinEffects() external view returns (address[] memory) {
        return winEffects;
    }

    function setGameAddress(address _game) external onlyOwner {
        game = Game(_game);
    }

    function setGameResultsAddress(address _gameResults) external onlyOwner {
        gameResults = IGameResults(_gameResults);
    }

    // Called by Lobbies once both sides' fleets are set; forwards straight
    // through to core Game.sol, which resolves the fleets and starts the
    // session. Same parameter shape Game.startGame always had.
    function startGame(
        uint _lobbyId,
        address _creator,
        address _joiner,
        uint _creatorFleetId,
        uint _joinerFleetId,
        bool _creatorGoesFirst,
        uint _turnTime,
        uint _selectedMapId,
        uint _maxScore
    ) external {
        if (msg.sender != lobbiesAddress) revert NotLobbiesContract();
        game.startGame(
            _lobbyId,
            _creator,
            _joiner,
            _creatorFleetId,
            _joinerFleetId,
            _creatorGoesFirst,
            _turnTime,
            _selectedMapId,
            _maxScore
        );
    }

    // Flee function - either player can end the game at any time
    function flee(uint _gameId) external {
        GameDataView memory g = game.getGame(_gameId);

        // Check if game has already ended (winner alone can't tell: a draw also
        // leaves winner == address(0), see GameMetadata.ended in Types.sol)
        if (g.metadata.ended) revert InvalidMove();

        // Must be either the creator or joiner
        if (msg.sender != g.metadata.creator && msg.sender != g.metadata.joiner)
            revert NotInGame();

        // Set the other player as the winner
        address winner = msg.sender == g.metadata.creator
            ? g.metadata.joiner
            : g.metadata.creator;
        game.forceEndSession(_gameId, winner, msg.sender);
    }

    // Force a loss when the current turn's player times out (only the other player can call this)
    function endGameOnTimeout(uint _gameId) external {
        GameDataView memory g = game.getGame(_gameId);

        if (block.timestamp <= g.turnState.turnStartTime + g.turnState.turnTime)
            revert TurnTimeoutNotReached();

        // Only the other player can force a timeout skip
        if (msg.sender == g.turnState.currentTurn) revert InvalidMove();

        // Must be either the creator or joiner
        if (msg.sender != g.metadata.creator && msg.sender != g.metadata.joiner)
            revert NotInGame();

        // End the game with the timed out player as the loser
        game.forceEndSession(_gameId, msg.sender, g.turnState.currentTurn);
    }

    // IGameOrchestrator: called by core Game.sol whenever a session this
    // contract started ends (win condition, forceEndSession, or a draw).
    function onGameEnded(
        uint _gameId,
        address _winner,
        address _loser
    ) external {
        if (msg.sender != address(game)) revert NotGame();
        // Only record non-draw results, matching Game._endGame's old guard
        if (_winner != address(0)) {
            gameResults.recordGameResult(_gameId, _winner, _loser);

            // Each call is individually try/catch'd — onGameEnded is
            // invoked by Game.sol as a bare external call with no
            // try/catch of its own (see Game.sol's _endGame), so an
            // unguarded revert here would fail the entire game-ending
            // transaction. Same reasoning as RoguelikeMatch.onGameEnded's
            // matching dispatch loop.
            for (uint i = 0; i < winEffects.length; i++) {
                try IWinEffect(winEffects[i]).onWin(_winner, _gameId) {} catch {
                    emit WinEffectFailed(_winner, _gameId, winEffects[i]);
                }
            }
        }
    }
}
