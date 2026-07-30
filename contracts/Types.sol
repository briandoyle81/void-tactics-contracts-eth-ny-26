// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

enum MainWeapon {
    Laser,
    Railgun,
    MissileLauncher,
    PlasmaCannon,
    future1,
    future2,
    future3,
    future4
}

// Reduces Damage, Does not Provide Hitpoints
enum Armor {
    None,
    Light,
    Medium,
    Heavy,
    future1,
    future2,
    future3,
    future4
}

// Reduces Damage, Does not Provide Hitpoints
enum Shields {
    None,
    Light,
    Medium,
    Heavy,
    future1,
    future2,
    future3,
    future4
}

enum Special {
    None,
    EMP,
    RepairDrones,
    FlakArray,
    future1,
    future2,
    future3,
    future4
}

// Single-player AI behavior tag, assigned per AIShipConfig (AIEncounters.sol)
// and looked up per minted AI ship (SinglePlayerMatch.shipArchetype) to pick
// which ordered priority-list of rules takeAITurn applies to that ship.
enum Archetype {
    Grunt, // shoot what's in range, else close distance
    Aggressor, // prioritize kills over safety, closes distance hard
    Sniper, // shoots at range, retreats rather than engaging adjacent
    Support, // heals the weakest ally in range (RepairDrones), hangs back
    Turtle, // seeks/holds scoring tiles, fights only opportunistically
    Rammer // faction-1 only: hunts 0-HP enemies to Ram, else shoots
}

// Which game mode(s) a preset map is valid for. Enforced at the point a
// map gets attached to something a player can actually enter — NodeMap
// (campaign nodes, PvE) and Lobbies (createLobby/createLobbyForAddresses,
// PvP) — rather than in Maps.sol itself, which has no notion of lobbies or
// campaigns. Both means the map is valid in either context.
enum MapMode {
    PvP,
    PvE,
    Both
}

// Declarative outcome of a resolver-backed faction ability (see
// IFactionAbilityResolver), applied by Game.sol without re-validating
// anything — the resolver owns all pre-dispatch checks for its ability.
// One entry per affected ship; a resolver may return any number of these.
// newRow/newCol double as the "relocate" flag: type(int16).min (an
// unreachable grid coordinate) means "don't move this ship". Fewer, denser
// fields keep the external-call ABI decode/encode Game.sol pays for as
// small as possible — this struct crosses a contract boundary every time.
struct SpecialEffect {
    uint shipId;
    int16 hullDelta; // negative = damage, positive = heal; capped at maxHullPoints
    int8 reactorTimerDelta; // added to reactorCriticalTimer; still auto-removes at >=3
    int16 newRow; // type(int16).min = no relocation
    int16 newCol;
    uint8 removalKind; // 0 = none, 1 = retreat, 2 = destroy (mirrors _removeShipFromGame's retreat/destroy flag)
}

// Raw Traits Will Never Change
struct Traits {
    uint256 serialNumber; // Id for random number in commit reveal
    Colors colors;
    uint16 variant; // Which art to use for the ship
    uint8 accuracy;
    uint8 hull; // Hitpoints
    uint8 speed;
}

struct Colors {
    uint16 h1;
    uint8 s1;
    uint8 l1;
    uint16 h2;
    uint8 s2;
    uint8 l2;
    uint16 h3;
    uint8 s3;
    uint8 l3;
}

struct Equipment {
    MainWeapon mainWeapon;
    Armor armor;
    Shields shields;
    Special special;
}

// Attributes Change on Version
// Attributes will live in the game contract
struct Attributes {
    uint16 version; // Attributes version not cost version
    uint8 range;
    uint8 gunDamage;
    uint8 hullPoints;
    uint8 maxHullPoints;
    uint8 movement;
    uint8 damageReduction;
    uint8 reactorCriticalTimer;
    uint8[] statusEffects;
}

// Grid position structure
struct Position {
    int16 row;
    int16 col;
}

// Scoring position structure with point value
struct ScoringPosition {
    int16 row;
    int16 col;
    uint8 points; // Number of points available on this tile
    bool onlyOnce; // Whether this tile can only be claimed once
}

// Ship position on the grid (including status for replay/visualization)
// status: 0 = alive, 1 = destroyed, 2 = fled
struct ShipPosition {
    uint shipId;
    Position position;
    bool isCreator;
    uint8 status;
}

// Game metadata - basic game identification and players
struct GameMetadata {
    uint gameId;
    uint lobbyId;
    address creator;
    address joiner;
    uint creatorFleetId;
    uint joinerFleetId;
    bool creatorGoesFirst;
    uint startedAt;
    address winner; // Winner of the game (zero address if game is not over OR if it was a draw)
    // True once _endGame has run. winner alone can't distinguish "not over" from
    // "ended in a draw" (both leave winner == address(0)), so this is the one
    // source of truth for "has this game ended." Packs into winner's storage
    // slot (address is 20 bytes, bool is 1), so this costs no extra slot.
    bool ended;
    // The contract that called startGame for this session (e.g. PvPMatch).
    // Only this address may call forceEndSession, and it's who Game.sol
    // calls back into (via IGameOrchestrator.onGameEnded) when the session
    // ends, so each game mode can decide what "ended" means for it without
    // core Game.sol needing to know about leaderboards/results contracts.
    address orchestrator;
}

// Game turn state - turn and timing related data
struct GameTurnState {
    address currentTurn;
    uint turnTime; // Time limit per turn in seconds
    uint turnStartTime; // When current turn started
    uint currentRound;
}

// Game grid dimensions
struct GameGridDimensions {
    int16 gridWidth;
    int16 gridHeight;
}

struct GameData {
    GameMetadata metadata;
    GameTurnState turnState;
    GameGridDimensions gridDimensions;
    uint maxScore; // Maximum score needed to win the game
    uint creatorScore; // Current score of the creator player
    uint joinerScore; // Current score of the joiner player
    LastMove lastMove; // Most recent move in the game
    // Keep all mappings in GameData
    mapping(uint => Attributes) shipAttributes; // shipId => attributes
    // Grid state - grid[row][column] = shipId (0 if empty)
    mapping(int16 row => mapping(int16 column => uint shipId)) grid;
    // Board position and status for each ship (status: 0 = alive, 1 = destroyed, 2 = fled)
    mapping(uint => ShipPosition) shipPositions; // shipId => position + status
    // Kill-credit tracking: target shipId => shipId of its last damager, scoped per
    // game (was a top-level Game.sol mapping shared across all games; a ship id
    // reused in a later game would inherit a stale entry from an earlier one).
    mapping(uint => uint) lastDamage;
    EnumerableSet.UintSet shipMovedThisRound; // movedShipIds in current round
    EnumerableSet.UintSet shipsWithZeroHP; // shipIds with 0 hull points
    // Store active ship IDs for each player to avoid repeated fleet calls
    mapping(address => EnumerableSet.UintSet) playerActiveShipIds; // player => shipIds
    // Round completion: use counts at round start so destroyed/retreated ships don't shrink the threshold
    uint[] goneShipIds; // shipIds that have been destroyed or retreated this round
    uint totalActiveShipsAtRoundStart; // set at start of each round
    uint shipsRemovedThisRound; // destroyed or retreated this round (incremented in _removeShipFromGame)
}

struct GameDataView {
    GameMetadata metadata;
    GameTurnState turnState;
    GameGridDimensions gridDimensions;
    uint maxScore; // Maximum score needed to win the game
    uint creatorScore; // Current score of the creator player
    uint joinerScore; // Current score of the joiner player
    LastMove lastMove; // Most recent move in the game
    // Ship data arrays
    uint[] shipIds;
    Attributes[] shipAttributes; // Combined array of all ship attributes indexed by ship ID
    ShipPosition[] shipPositions; // All ship positions on the grid
    // Active ship IDs for each player
    uint[] creatorActiveShipIds;
    uint[] joinerActiveShipIds;
    // Ships that have moved this round
    uint[] creatorMovedShipIds; // Creator ships that have moved this round
    uint[] joinerMovedShipIds; // Joiner ships that have moved this round
}

struct Ship {
    string name;
    uint id;
    Equipment equipment;
    Traits traits;
    ShipData shipData;
    address owner;
}

struct ShipData {
    uint32 shipsDestroyed; // +1 for Frigate, +2 for Destroyer, +3 for Cruiser, +4 for Battleship
    uint16 costsVersion;
    uint16 cost;
    uint16 modified; // 0 = false, anything else = true
    bool shiny;
    bool constructed;
    bool inFleet;
    bool isFreeShip;
    uint timestampDestroyed;
}

struct Costs {
    uint16 version;
    uint8 baseCost;
    uint8[] accuracy;
    uint8[] hull;
    uint8[] speed;
    // Items are uint8[4]
    uint8[] mainWeapon;
    uint8[] armor;
    uint8[] shields;
    uint8[] special;
    uint8[] variant; // indexed by traits.variant
}

// Be VERY CAREFUL giving negative movement!
// It can result in ships that can't move

// We don't need historical versions because this is just used to calculate
// attributes, which are done at the start of the game and stay the same

struct GunData {
    uint8 range;
    uint8 damage;
    int8 movement;
}

struct ArmorData {
    uint8 damageReduction;
    int8 movement;
}

struct ShieldData {
    uint8 damageReduction;
    int8 movement;
}

struct SpecialData {
    uint8 range;
    uint8 strength;
    int8 movement;
}

// Per-variant hull-piece bonuses (bridge/hull/engine) and per-variant special
// effects. Nested in a mapping (not an array) inside AttributesVersion since
// AttributesVersion only ever lives in storage (never copied to memory), so a
// mapping field is safe here.
struct VariantAttributeData {
    uint8[] foreAccuracy; // "bridge": indexed by traits.accuracy tier (0-2)
    uint8[] hull; // indexed by traits.hull tier (0-2)
    uint8[] engineSpeeds; // "engine": indexed by traits.speed tier (0-2)
    SpecialData[] specials; // indexed by Special enum (0-7)
}

struct AttributesVersion {
    uint16 version;
    uint8 baseHull;
    uint8 baseSpeed;
    GunData[] guns;
    ArmorData[] armors;
    ShieldData[] shields;
    mapping(uint16 => VariantAttributeData) variantData; // keyed by traits.variant
}

enum LobbyStatus {
    Open, // Lobby is open for joining
    FleetSelection, // Both players have joined, selecting fleets
    InGame // Game has started
}

// Basic lobby identification and ownership
struct LobbyBasic {
    uint id;
    address creator;
    uint costLimit;
    uint createdAt;
}

// Player and fleet information
struct LobbyPlayers {
    address joiner;
    address reservedJoiner; // Address of player this lobby is reserved for (if any)
    uint creatorFleetId;
    uint joinerFleetId;
    uint joinedAt;
    uint joinerFleetSetAt;
}

// Game configuration settings
struct LobbyGameConfig {
    bool creatorGoesFirst;
    uint turnTime; // Time in seconds for each turn
    uint selectedMapId; // ID of the preset map to use for this game
    uint maxScore; // Maximum score needed to win the game
}

// Lobby state and status
struct LobbyState {
    LobbyStatus status;
    uint gameStartedAt;
}

// Main lobby struct composed of smaller components
struct Lobby {
    LobbyBasic basic;
    LobbyPlayers players;
    LobbyGameConfig gameConfig;
    LobbyState state;
}

struct Fleet {
    uint id;
    uint lobbyId;
    address owner;
    uint[] shipIds;
    Position[] startingPositions;
    uint totalCost;
    bool isComplete;
}

struct PlayerLobbyState {
    uint activeLobbyId;
    uint activeLobbiesCount; // Track number of active lobbies
    bool hasActiveLobby;
    uint kickCount;
    uint lastKickTime;
}

enum ActionType {
    Pass,
    Shoot,
    Retreat,
    Assist,
    Special,
    // Innate to every ship of a given faction (traits.variant), independent
    // of loadout — unlike Special, which requires equipping a specific
    // equipment.special slot. Dispatched by faction, not by an equipped item.
    FactionAbility
}

// Last move information stored in game data
struct LastMove {
    uint shipId;
    int16 oldRow;
    int16 oldCol;
    int16 newRow;
    int16 newCol;
    ActionType actionType;
    uint targetShipId;
    uint timestamp; // When the move was made
}

// Player statistics for tracking wins and losses
struct PlayerStats {
    uint wins;
    uint losses;
    uint totalGames;
}

// Game result structure for tracking individual game outcomes
struct GameResult {
    uint gameId;
    address winner;
    address loser;
    uint timestamp;
}
