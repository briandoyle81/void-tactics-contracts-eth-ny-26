// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Types.sol";
import "./Maps.sol";

// Admin-curated single-player AI encounters: a reusable ship-loadout
// registry (AIShipConfig, not tied to any minted NFT) plus a per-preset-map
// row/col -> configId placement mapping, so different Maps.sol preset maps
// can have distinct AI fleets instead of SinglePlayerMatch's old hardcoded
// 3-ship/fixed-column template. Mirrors Maps.sol's own idioms throughout
// (owner-or-editor gate, sequential small-int ids, bounds-checked writes)
// deliberately, since it's conceptually an extension of the map-authoring
// workflow. Does not import Ships/IShips — SinglePlayerMatch (which already
// holds a Ships reference) stays the only thing that mints, keeping this
// contract's dependency footprint minimal.
contract AIEncounters is Ownable {
    // Reusable AI ship loadout template. traits.serialNumber/traits.colors
    // are always ignored downstream (Ships._mintShip regenerates
    // serialNumber; colors only affect rendering) — leave them zero.
    struct AIShipConfig {
        uint id;
        string name;
        Equipment equipment;
        Traits traits; // accuracy/hull/speed must be 0-2; variant must be > 0
        Archetype archetype; // drives SinglePlayerMatch's takeAITurn rules
    }

    Maps public maps;

    mapping(uint => AIShipConfig) public aiShipConfigs;
    uint public aiShipConfigCount;

    // Addresses allowed to create/edit AI configs and placements (in
    // addition to the owner) — same pattern as Maps.isMapEditor.
    mapping(address => bool) public isEncounterEditor;

    // presetMapId => row => col => configId (0 = empty cell). Placements are
    // only ever valid in the joiner-side column window Fleets.createFleet
    // already enforces for every joiner ship (Fleets.sol:78-85) — the AI is
    // always the joiner — so writes are bounds-checked against that window
    // directly, and reads only ever scan that window, not the full grid.
    mapping(uint => mapping(int16 => mapping(int16 => uint)))
        public mapPlacements;
    // presetMapId => count of currently-non-zero placement cells, kept in
    // sync by _setMapPlacementInternal so getMapPlacements/mapHasPlacements
    // and the MAX_PLACEMENTS_PER_MAP bound are both O(1)/exact-sized, no scan.
    mapping(uint => uint) public mapPlacementCount;

    int16 public constant GRID_HEIGHT = 11;
    // Mirrors Fleets.sol's joiner-side column window (Fleets.sol:81) —
    // duplicated rather than imported since Fleets.sol has no public
    // constant for it; keep in sync if that window ever changes.
    int16 public constant JOINER_COL_MIN = 13;
    int16 public constant JOINER_COL_MAX = 16;
    uint public constant MAX_PLACEMENTS_PER_MAP = 8;

    error NotEncounterEditor();
    error InvalidTier();
    error InvalidVariant();
    error ConfigNotFound();
    error MapNotFound();
    error InvalidPosition();
    error TooManyPlacements();
    error ArrayLengthMismatch();

    event EncounterEditorSet(address indexed editor, bool allowed);
    event AIShipConfigCreated(uint indexed configId);
    event AIShipConfigUpdated(uint indexed configId);
    event MapPlacementSet(
        uint indexed mapId,
        int16 row,
        int16 col,
        uint configId
    );

    constructor(address _maps) Ownable(msg.sender) {
        maps = Maps(_maps);
    }

    /// @dev Restricts to the owner or an allowed encounter editor.
    modifier onlyEncounterEditor() {
        if (msg.sender != owner() && !isEncounterEditor[msg.sender])
            revert NotEncounterEditor();
        _;
    }

    function setMapsAddress(address _maps) external onlyOwner {
        maps = Maps(_maps);
    }

    /**
     * @dev Grant or revoke encounter-editor rights (create/edit AI ship
     * configs and their map placements).
     * @param _editor The address to update
     * @param _allowed Whether the address may edit encounters
     */
    function setEncounterEditor(
        address _editor,
        bool _allowed
    ) external onlyOwner {
        isEncounterEditor[_editor] = _allowed;
        emit EncounterEditorSet(_editor, _allowed);
    }

    function createAIShipConfig(
        string calldata _name,
        Equipment calldata _equipment,
        Traits calldata _traits,
        Archetype _archetype
    ) external onlyEncounterEditor returns (uint configId) {
        _validateTraits(_traits);
        aiShipConfigCount++;
        configId = aiShipConfigCount;
        aiShipConfigs[configId] = AIShipConfig({
            id: configId,
            name: _name,
            equipment: _equipment,
            traits: _traits,
            archetype: _archetype
        });
        emit AIShipConfigCreated(configId);
    }

    function updateAIShipConfig(
        uint _configId,
        string calldata _name,
        Equipment calldata _equipment,
        Traits calldata _traits,
        Archetype _archetype
    ) external onlyEncounterEditor {
        if (_configId == 0 || _configId > aiShipConfigCount)
            revert ConfigNotFound();
        _validateTraits(_traits);
        aiShipConfigs[_configId] = AIShipConfig({
            id: _configId,
            name: _name,
            equipment: _equipment,
            traits: _traits,
            archetype: _archetype
        });
        emit AIShipConfigUpdated(_configId);
    }

    function _validateTraits(Traits calldata _traits) internal pure {
        if (_traits.accuracy > 2 || _traits.hull > 2 || _traits.speed > 2)
            revert InvalidTier();
        if (_traits.variant == 0) revert InvalidVariant();
    }

    function getAIShipConfig(
        uint _configId
    ) external view returns (AIShipConfig memory) {
        if (_configId == 0 || _configId > aiShipConfigCount)
            revert ConfigNotFound();
        return aiShipConfigs[_configId];
    }

    function getAllAIShipConfigs()
        external
        view
        returns (AIShipConfig[] memory configs)
    {
        configs = new AIShipConfig[](aiShipConfigCount);
        for (uint i = 0; i < aiShipConfigCount; i++) {
            configs[i] = aiShipConfigs[i + 1];
        }
    }

    /// @dev _configId == 0 clears the cell.
    function setMapPlacement(
        uint _mapId,
        int16 _row,
        int16 _col,
        uint _configId
    ) external onlyEncounterEditor {
        _setMapPlacementInternal(_mapId, _row, _col, _configId);
    }

    function setMapPlacements(
        uint _mapId,
        Position[] calldata _positions,
        uint[] calldata _configIds
    ) external onlyEncounterEditor {
        if (_positions.length != _configIds.length)
            revert ArrayLengthMismatch();
        for (uint i = 0; i < _positions.length; i++) {
            _setMapPlacementInternal(
                _mapId,
                _positions[i].row,
                _positions[i].col,
                _configIds[i]
            );
        }
    }

    function _setMapPlacementInternal(
        uint _mapId,
        int16 _row,
        int16 _col,
        uint _configId
    ) internal {
        if (!maps.mapExists(_mapId)) revert MapNotFound();
        if (
            _row < 0 ||
            _row >= GRID_HEIGHT ||
            _col < JOINER_COL_MIN ||
            _col > JOINER_COL_MAX
        ) revert InvalidPosition();
        if (_configId != 0 && _configId > aiShipConfigCount)
            revert ConfigNotFound();

        uint existing = mapPlacements[_mapId][_row][_col];
        if (existing == 0 && _configId != 0) {
            if (mapPlacementCount[_mapId] >= MAX_PLACEMENTS_PER_MAP)
                revert TooManyPlacements();
            mapPlacementCount[_mapId]++;
        } else if (existing != 0 && _configId == 0) {
            mapPlacementCount[_mapId]--;
        }

        mapPlacements[_mapId][_row][_col] = _configId;
        emit MapPlacementSet(_mapId, _row, _col, _configId);
    }

    function getMapPlacements(
        uint _mapId
    ) external view returns (Position[] memory positions, uint[] memory configIds) {
        uint count = mapPlacementCount[_mapId];
        positions = new Position[](count);
        configIds = new uint[](count);
        uint idx;
        for (int16 row = 0; row < GRID_HEIGHT; row++) {
            for (int16 col = JOINER_COL_MIN; col <= JOINER_COL_MAX; col++) {
                uint configId = mapPlacements[_mapId][row][col];
                if (configId != 0) {
                    positions[idx] = Position({row: row, col: col});
                    configIds[idx] = configId;
                    idx++;
                }
            }
        }
    }

    function mapHasPlacements(uint _mapId) external view returns (bool) {
        return mapPlacementCount[_mapId] > 0;
    }
}
