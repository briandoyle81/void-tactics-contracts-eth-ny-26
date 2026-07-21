// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Types.sol";
import "./Game.sol";
import "./IGameResults.sol";
import "./IGameOrchestrator.sol";

// PvP-specific orchestration split out of Game.sol: this is what Lobbies
// talks to for starting a match, and it owns human-forfeit mechanics
// (flee/timeout) and PvP leaderboard recording. Core combat/movement stays
// entirely in Game.sol, unmodified — this contract just drives it, exactly
// like a human wallet or any other authorized orchestrator would.
contract PvPMatch is Ownable, IGameOrchestrator {
    Game public game;
    IGameResults public gameResults;
    address public lobbiesAddress;

    error NotGame();
    error NotLobbiesContract();
    error TurnTimeoutNotReached();
    error NotInGame();
    error InvalidMove();

    constructor(address _game, address _gameResults) Ownable(msg.sender) {
        game = Game(_game);
        gameResults = IGameResults(_gameResults);
    }

    function setLobbiesAddress(address _lobbiesAddress) external onlyOwner {
        lobbiesAddress = _lobbiesAddress;
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
        }
    }
}
