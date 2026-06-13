// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./Types.sol";
import "./IWorldID.sol";
import "./ByteHasher.sol";

/// @dev Minimal reader for the deployed GameResults contract. `getGameResult`
/// reverts with GameNotFound when no result has been recorded for the id.
interface IGameResultsReader {
    function getGameResult(uint _gameId) external view returns (GameResult memory);
}

/// @title Tournament
/// @notice Single-elimination tournaments for Void Tactics. One human (World ID)
///         per registration. Matches are played in the existing Game contract;
///         winners are read trustlessly from GameResults on the same chain.
contract Tournament is Ownable, ReentrancyGuard {
    using ByteHasher for bytes;

    enum TournamentState {
        Registration,
        Active,
        Complete,
        Cancelled
    }

    struct TournamentConfig {
        uint256 entryFee; // native wei; 0 == free entry
        uint32 minPlayers; // >= 2
        uint32 maxPlayers; // cap
        uint64 lastStartTime; // unix seconds; start / cancel gate
        // Fixed per-match game config, applied to every match's lobby:
        uint256 costLimit;
        uint256 turnTime;
        uint256 selectedMapId;
        uint256 maxScore;
    }

    struct Match {
        uint256 matchId;
        uint8 round; // 0 == first round
        address player1;
        address player2; // address(0) == bye / not-yet-determined
        address winner;
        uint256 gameId; // == lobbyId of the played game (0 until assigned)
        bytes32 walrusBlobId; // opaque match-record pointer
        bool resolved;
    }

    struct TournamentData {
        uint256 id;
        address creator;
        TournamentState state;
        TournamentConfig config;
        uint256 prizePool; // entry fees + sponsor contribution
        address sponsor; // single sponsor (address(0) if none)
        uint256 sponsorAmount;
        address[] registrants; // registration order == seed order
        mapping(address => bool) registered;
        mapping(address => uint32) seed; // 1-based registration order (0 == not registered)
        mapping(uint256 => bool) usedNullifiers;
        Match[] bracket; // flattened single-elim bracket, all slots pre-allocated
        uint32 bracketSize; // N (next power of 2 >= registrants)
        uint8 totalRounds; // log2(N)
        address champion;
        address runnerUp;
        bool prizesDistributed;
        mapping(address => uint256) winnings; // pull-payment balances
        mapping(address => bool) refunded;
    }

    // ---- Config ----
    IWorldID public worldId; // World ID router; mutable so it can be repointed
    uint256 public immutable groupId; // 1 for Orb (on-chain verification)
    IGameResultsReader public immutable gameResults;
    uint256 public externalNullifier; // hash(appId, action)
    address public feeRecipient;
    uint16 public constant PROTOCOL_FEE_BPS = 100; // 1.00%

    uint256 public tournamentCount;
    mapping(uint256 => TournamentData) internal tournaments;

    // ---- Events ----
    event TournamentCreated(
        uint256 indexed tournamentId,
        address indexed creator,
        uint256 entryFee,
        uint32 minPlayers,
        uint32 maxPlayers,
        uint64 lastStartTime
    );
    event SponsorAdded(uint256 indexed tournamentId, address indexed sponsor, uint256 amount);
    event Registered(uint256 indexed tournamentId, address indexed player, uint256 nullifierHash);
    event TournamentStarted(uint256 indexed tournamentId, uint8 totalRounds, uint256 matchCount);
    event MatchGameAssigned(uint256 indexed tournamentId, uint256 indexed matchId, uint256 gameId);
    event MatchResolved(uint256 indexed tournamentId, uint256 indexed matchId, address winner, bytes32 walrusBlobId);
    event NextRoundMatchCreated(uint256 indexed tournamentId, uint256 indexed matchId, uint8 round);
    event TournamentFinalized(uint256 indexed tournamentId, address champion, address runnerUp);
    event PrizeClaimed(uint256 indexed tournamentId, address indexed player, uint256 amount);
    event TournamentCancelled(uint256 indexed tournamentId);
    event Refunded(uint256 indexed tournamentId, address indexed player, uint256 amount);

    // ---- Errors ----
    error TournamentNotFound();
    error NotInRegistration();
    error RegistrationClosed();
    error AlreadyRegistered();
    error NullifierUsed();
    error WrongEntryFee();
    error RegistrationFull();
    error StartConditionsNotMet();
    error CancelConditionsNotMet();
    error NotActive();
    error NotCancelled();
    error MatchNotFound();
    error MatchAlreadyResolved();
    error MatchNotReady();
    error GameNotAssigned();
    error WinnerNotInMatch();
    error FinalNotResolved();
    error AlreadyFinalized();
    error NothingToClaim();
    error InvalidConfig();
    error SponsorAlreadySet();
    error NotCreator();
    error TransferFailed();

    constructor(
        address _worldId,
        uint256 _groupId,
        uint256 _externalNullifier,
        address _gameResults,
        address _feeRecipient
    ) Ownable(msg.sender) {
        worldId = IWorldID(_worldId);
        groupId = _groupId;
        externalNullifier = _externalNullifier;
        gameResults = IGameResultsReader(_gameResults);
        feeRecipient = _feeRecipient;
    }

    // ---- Owner config ----
    function setWorldId(address _worldId) external onlyOwner {
        worldId = IWorldID(_worldId);
    }

    function setExternalNullifier(uint256 _externalNullifier) external onlyOwner {
        externalNullifier = _externalNullifier;
    }

    function setFeeRecipient(address _feeRecipient) external onlyOwner {
        feeRecipient = _feeRecipient;
    }

    // ---- Creation & funding ----
    function createTournament(
        TournamentConfig calldata cfg
    ) external payable returns (uint256 tournamentId) {
        if (
            cfg.minPlayers < 2 ||
            cfg.maxPlayers < cfg.minPlayers ||
            cfg.lastStartTime <= block.timestamp
        ) revert InvalidConfig();

        tournamentId = ++tournamentCount;
        TournamentData storage t = tournaments[tournamentId];
        t.id = tournamentId;
        t.creator = msg.sender;
        t.state = TournamentState.Registration;
        t.config = cfg;

        if (msg.value > 0) {
            t.sponsor = msg.sender;
            t.sponsorAmount = msg.value;
            t.prizePool = msg.value;
        }

        emit TournamentCreated(
            tournamentId,
            msg.sender,
            cfg.entryFee,
            cfg.minPlayers,
            cfg.maxPlayers,
            cfg.lastStartTime
        );
    }

    function addSponsorPrize(uint256 tournamentId) external payable {
        TournamentData storage t = _get(tournamentId);
        if (
            t.state != TournamentState.Registration &&
            t.state != TournamentState.Active
        ) revert NotInRegistration();

        if (t.sponsor == address(0)) {
            t.sponsor = msg.sender;
        } else if (t.sponsor != msg.sender) {
            revert SponsorAlreadySet();
        }
        t.sponsorAmount += msg.value;
        t.prizePool += msg.value;
        emit SponsorAdded(tournamentId, msg.sender, msg.value);
    }

    // ---- Registration (World ID gate) ----
    function register(
        uint256 tournamentId,
        uint256 root,
        uint256 nullifierHash,
        uint256[8] calldata proof
    ) external payable {
        TournamentData storage t = _get(tournamentId);
        if (t.state != TournamentState.Registration) revert NotInRegistration();
        if (block.timestamp > t.config.lastStartTime) revert RegistrationClosed();
        if (t.registrants.length >= t.config.maxPlayers) revert RegistrationFull();
        if (msg.value != t.config.entryFee) revert WrongEntryFee();
        if (t.registered[msg.sender]) revert AlreadyRegistered();
        if (t.usedNullifiers[nullifierHash]) revert NullifierUsed();

        worldId.verifyProof(
            root,
            groupId,
            abi.encodePacked(msg.sender).hashToField(),
            nullifierHash,
            externalNullifier,
            proof
        );

        t.usedNullifiers[nullifierHash] = true;
        t.registered[msg.sender] = true;
        t.registrants.push(msg.sender);
        t.seed[msg.sender] = uint32(t.registrants.length);
        t.prizePool += msg.value;

        emit Registered(tournamentId, msg.sender, nullifierHash);
    }

    // ---- Start / cancel ----
    function start(uint256 tournamentId) external {
        TournamentData storage t = _get(tournamentId);
        if (t.state != TournamentState.Registration) revert NotInRegistration();

        uint256 n = t.registrants.length;
        bool atMax = n == t.config.maxPlayers;
        bool timeUp = block.timestamp > t.config.lastStartTime;
        if (!(atMax || (timeUp && n >= t.config.minPlayers)))
            revert StartConditionsNotMet();

        _buildBracket(t);
        t.state = TournamentState.Active;
        emit TournamentStarted(tournamentId, t.totalRounds, t.bracket.length);
    }

    function cancel(uint256 tournamentId) external {
        TournamentData storage t = _get(tournamentId);
        if (t.state != TournamentState.Registration) revert NotInRegistration();
        if (
            block.timestamp <= t.config.lastStartTime ||
            t.registrants.length >= t.config.minPlayers
        ) revert CancelConditionsNotMet();
        t.state = TournamentState.Cancelled;
        emit TournamentCancelled(tournamentId);
    }

    function claimRefund(uint256 tournamentId) external nonReentrant {
        TournamentData storage t = _get(tournamentId);
        if (t.state != TournamentState.Cancelled) revert NotCancelled();

        uint256 amount;
        if (t.registered[msg.sender] && !t.refunded[msg.sender]) {
            t.refunded[msg.sender] = true;
            amount += t.config.entryFee;
        }
        if (msg.sender == t.sponsor && t.sponsorAmount > 0) {
            amount += t.sponsorAmount;
            t.sponsorAmount = 0;
        }
        if (amount == 0) revert NothingToClaim();

        _send(msg.sender, amount);
        emit Refunded(tournamentId, msg.sender, amount);
    }

    // ---- Match wiring & results ----
    function assignMatchGame(
        uint256 tournamentId,
        uint256 matchId,
        uint256 gameId
    ) external {
        TournamentData storage t = _get(tournamentId);
        if (msg.sender != t.creator) revert NotCreator();
        if (t.state != TournamentState.Active) revert NotActive();
        if (matchId >= t.bracket.length) revert MatchNotFound();
        Match storage m = t.bracket[matchId];
        if (m.resolved) revert MatchAlreadyResolved();
        if (m.player1 == address(0) || m.player2 == address(0)) revert MatchNotReady();
        m.gameId = gameId;
        emit MatchGameAssigned(tournamentId, matchId, gameId);
    }

    /// @notice Resolve a match from the canonical on-chain game result. Permissionless:
    /// the winner is read from GameResults and validated against the match players.
    function recordResult(
        uint256 tournamentId,
        uint256 matchId,
        bytes32 walrusBlobId
    ) external {
        TournamentData storage t = _get(tournamentId);
        if (t.state != TournamentState.Active) revert NotActive();
        if (matchId >= t.bracket.length) revert MatchNotFound();
        Match storage m = t.bracket[matchId];
        if (m.resolved) revert MatchAlreadyResolved();
        if (m.gameId == 0) revert GameNotAssigned();

        // Reverts (GameNotFound) if the game result has not been recorded yet.
        GameResult memory gr = gameResults.getGameResult(m.gameId);
        bool ok = (gr.winner == m.player1 && gr.loser == m.player2) ||
            (gr.winner == m.player2 && gr.loser == m.player1);
        if (!ok) revert WinnerNotInMatch();

        _resolve(t, matchId, gr.winner, walrusBlobId);
    }

    /// @notice TEMPORARY: resolve a drawn game. A draw sets the game's winner to
    /// address(0) and is never written to GameResults, so it cannot flow through
    /// recordResult. As a stopgap the match is awarded to the player who registered
    /// first (lower seed) — deterministic, so the creator has no say in the outcome.
    /// Restricted to the creator because there is no on-chain "draw" flag in Game.
    function resolveDraw(
        uint256 tournamentId,
        uint256 matchId,
        bytes32 walrusBlobId
    ) external {
        TournamentData storage t = _get(tournamentId);
        if (msg.sender != t.creator) revert NotCreator();
        if (t.state != TournamentState.Active) revert NotActive();
        if (matchId >= t.bracket.length) revert MatchNotFound();
        Match storage m = t.bracket[matchId];
        if (m.resolved) revert MatchAlreadyResolved();
        if (m.player1 == address(0) || m.player2 == address(0)) revert MatchNotReady();

        address winner = t.seed[m.player1] <= t.seed[m.player2]
            ? m.player1
            : m.player2;
        _resolve(t, matchId, winner, walrusBlobId);
    }

    // ---- Finalize & claim ----
    function finalize(uint256 tournamentId) external {
        TournamentData storage t = _get(tournamentId);
        if (t.state != TournamentState.Active) revert NotActive();
        if (t.champion == address(0)) revert FinalNotResolved();
        if (t.prizesDistributed) revert AlreadyFinalized();

        uint256 pool = t.prizePool;
        uint256 fee = (pool * PROTOCOL_FEE_BPS) / 10000;
        uint256 remainder = pool - fee;
        uint256 second = (remainder * 40) / 100;
        uint256 first = remainder - second; // 60% + integer dust

        if (fee > 0) t.winnings[feeRecipient] += fee;
        t.winnings[t.champion] += first;
        t.winnings[t.runnerUp] += second;

        t.prizesDistributed = true;
        t.state = TournamentState.Complete;
        emit TournamentFinalized(tournamentId, t.champion, t.runnerUp);
    }

    function claim(uint256 tournamentId) external nonReentrant {
        TournamentData storage t = _get(tournamentId);
        uint256 amount = t.winnings[msg.sender];
        if (amount == 0) revert NothingToClaim();
        t.winnings[msg.sender] = 0;
        _send(msg.sender, amount);
        emit PrizeClaimed(tournamentId, msg.sender, amount);
    }

    // ---- Internal: bracket ----
    function _buildBracket(TournamentData storage t) internal {
        uint256 count = t.registrants.length;
        uint256 n = 2;
        uint8 rounds = 1;
        while (n < count) {
            n <<= 1;
            rounds++;
        }
        t.bracketSize = uint32(n);
        t.totalRounds = rounds;

        // Pre-allocate every match slot, round by round, tagging each with its round.
        uint256 matchId = 0;
        for (uint8 r = 0; r < rounds; r++) {
            uint256 sizeR = n >> (r + 1);
            for (uint256 i = 0; i < sizeR; i++) {
                Match memory m;
                m.matchId = matchId;
                m.round = r;
                t.bracket.push(m);
                matchId++;
            }
        }

        // Fill round-0 players using standard seeding so byes fall to top seeds.
        uint256[] memory order = _seedOrder(n);
        uint256 firstRoundMatches = n / 2;
        for (uint256 i = 0; i < firstRoundMatches; i++) {
            uint256 sA = order[2 * i];
            uint256 sB = order[2 * i + 1];
            t.bracket[i].player1 = sA <= count ? t.registrants[sA - 1] : address(0);
            t.bracket[i].player2 = sB <= count ? t.registrants[sB - 1] : address(0);
        }

        // Auto-advance byes (exactly one side empty; N is the next power of two so
        // there can never be two byes in one match).
        for (uint256 i = 0; i < firstRoundMatches; i++) {
            Match storage m = t.bracket[i];
            if (m.player1 == address(0) && m.player2 == address(0)) continue;
            if (m.player1 == address(0) || m.player2 == address(0)) {
                address w = m.player1 == address(0) ? m.player2 : m.player1;
                m.winner = w;
                m.resolved = true;
                _advance(t, i);
            }
        }
    }

    /// @dev Standard single-elimination seed order for a bracket of size `n`
    /// (power of two). Returns 1-indexed seed positions.
    function _seedOrder(uint256 n) internal pure returns (uint256[] memory) {
        uint256[] memory seeds = new uint256[](1);
        seeds[0] = 1;
        uint256 len = 1;
        while (len < n) {
            uint256[] memory next = new uint256[](len * 2);
            uint256 sum = len * 2 + 1;
            for (uint256 i = 0; i < len; i++) {
                next[2 * i] = seeds[i];
                next[2 * i + 1] = sum - seeds[i];
            }
            seeds = next;
            len *= 2;
        }
        return seeds;
    }

    function _resolve(
        TournamentData storage t,
        uint256 matchId,
        address winner,
        bytes32 walrusBlobId
    ) internal {
        Match storage m = t.bracket[matchId];
        m.winner = winner;
        m.walrusBlobId = walrusBlobId;
        m.resolved = true;
        emit MatchResolved(t.id, matchId, winner, walrusBlobId);
        _advance(t, matchId);
    }

    /// @dev Propagate a resolved match's winner into its parent slot, or record
    /// the champion/runner-up if it was the final.
    function _advance(TournamentData storage t, uint256 matchId) internal {
        Match storage m = t.bracket[matchId];
        uint8 r = m.round;
        if (r + 1 == t.totalRounds) {
            t.champion = m.winner;
            t.runnerUp = m.player1 == m.winner ? m.player2 : m.player1;
            return;
        }
        uint256 n = t.bracketSize;
        uint256 roundStart = n - (n >> r);
        uint256 idxInRound = matchId - roundStart;
        uint256 parentId = (n - (n >> (r + 1))) + idxInRound / 2;
        Match storage p = t.bracket[parentId];
        if (idxInRound % 2 == 0) {
            p.player1 = m.winner;
        } else {
            p.player2 = m.winner;
        }
        if (p.player1 != address(0) && p.player2 != address(0)) {
            emit NextRoundMatchCreated(t.id, parentId, p.round);
        }
    }

    // ---- Internal: helpers ----
    function _get(uint256 tournamentId) internal view returns (TournamentData storage t) {
        t = tournaments[tournamentId];
        if (t.id == 0) revert TournamentNotFound();
    }

    function _send(address to, uint256 amount) internal {
        (bool ok, ) = payable(to).call{value: amount}("");
        if (!ok) revert TransferFailed();
    }

    // ---- Views ----
    function getTournamentConfig(
        uint256 tournamentId
    ) external view returns (TournamentConfig memory) {
        return _get(tournamentId).config;
    }

    function getTournamentSummary(
        uint256 tournamentId
    )
        external
        view
        returns (
            TournamentState state,
            address creator,
            uint256 prizePool,
            uint256 registrantCount,
            uint8 totalRounds,
            address champion,
            address runnerUp
        )
    {
        TournamentData storage t = _get(tournamentId);
        return (
            t.state,
            t.creator,
            t.prizePool,
            t.registrants.length,
            t.totalRounds,
            t.champion,
            t.runnerUp
        );
    }

    function getRegistrants(
        uint256 tournamentId
    ) external view returns (address[] memory) {
        return _get(tournamentId).registrants;
    }

    function getMatch(
        uint256 tournamentId,
        uint256 matchId
    ) external view returns (Match memory) {
        TournamentData storage t = _get(tournamentId);
        if (matchId >= t.bracket.length) revert MatchNotFound();
        return t.bracket[matchId];
    }

    function getBracket(
        uint256 tournamentId
    ) external view returns (Match[] memory) {
        return _get(tournamentId).bracket;
    }

    function isRegistered(
        uint256 tournamentId,
        address player
    ) external view returns (bool) {
        return _get(tournamentId).registered[player];
    }

    function winningsOf(
        uint256 tournamentId,
        address player
    ) external view returns (uint256) {
        return _get(tournamentId).winnings[player];
    }
}
