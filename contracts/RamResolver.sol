// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";
import "./IFactionAbilityResolver.sol";

// Minimal read-only view of Game.sol this resolver needs — same pattern
// Tournament.sol already uses for its own local IGame, rather than
// importing the whole Game contract. getShipPosition (O(1), a single
// mapping read) rather than getGame/getAllShipPositions (which scans the
// entire grid) — this resolver only ever needs two specific ships.
interface IGameView {
    function getShipPosition(
        uint _gameId,
        uint _shipId
    ) external view returns (ShipPosition memory);
    function getShipAttributes(
        uint _gameId,
        uint _shipId
    ) external view returns (Attributes memory);
}

// Ram: the faction 1 innate ability. Every variant-1 ship has it regardless
// of loadout (dispatched via ActionType.FactionAbility, not tied to
// equipment.special). A variant-1 ship rams an enemy ship (within range)
// that's already at 0 HP, evicting it and taking its tile — the
// resolver-backed replacement for what used to be an automatic side effect
// of any ship's plain move. Owns every pre-dispatch check for Ram itself
// (Game.sol/SpecialEffectsLib trust its output completely, per
// IFactionAbilityResolver's contract); reachability is already gated to
// faction 1 by Game.factionAbilityResolvers[1] being the only mapping entry
// pointing here, so this contract doesn't re-check variant itself.
contract RamResolver is IFactionAbilityResolver {
    IGameView public game;
    address public owner;

    // Ram's own range, decoupled from the equipment.special/ShipAttributes
    // system entirely — this ability was never equipped, so it has no
    // reason to share that config table. Range 1 = adjacent-only, matching
    // the original ramming mechanic.
    uint8 public range = 1;

    error NotOwner();
    error InvalidRamTarget();
    error OutOfRange();

    constructor(address _game) {
        game = IGameView(_game);
        owner = msg.sender;
    }

    function setGameAddress(address _game) external {
        if (msg.sender != owner) revert NotOwner();
        game = IGameView(_game);
    }

    function setRange(uint8 _range) external {
        if (msg.sender != owner) revert NotOwner();
        range = _range;
    }

    function resolveFactionAbility(
        uint gameId,
        uint shipId,
        uint16 /* variant */,
        uint targetShipId,
        int16 actingRow,
        int16 actingCol
    ) external view returns (SpecialEffect[] memory effects) {
        ShipPosition memory acting = game.getShipPosition(gameId, shipId);
        ShipPosition memory target = game.getShipPosition(gameId, targetShipId);
        if (acting.shipId == 0 || target.shipId == 0) revert InvalidRamTarget();
        // Ram can only hit the opposing side
        if (acting.isCreator == target.isCreator) revert InvalidRamTarget();

        Attributes memory targetAttrs = game.getShipAttributes(gameId, targetShipId);
        if (targetAttrs.hullPoints != 0) revert InvalidRamTarget();

        if (
            _manhattanDistance(
                actingRow,
                actingCol,
                target.position.row,
                target.position.col
            ) > range
        ) {
            revert OutOfRange();
        }

        effects = new SpecialEffect[](2);
        // Victim: unconditional eviction (retreat, not destroy — mirrors the
        // old ramming code's _removeShipFromGame(..., true, victim)).
        effects[0] = SpecialEffect({
            shipId: targetShipId,
            hullDelta: 0,
            reactorTimerDelta: 0,
            newRow: 0,
            newCol: 0,
            removalKind: 1
        });
        // Rammer: +1 reactor timer (fixed, matching the original ramming
        // mechanic exactly) and relocate onto the victim's now-vacated tile.
        // If this ram is this ship's 3rd, the shared effect-application
        // logic destroys it before the relocate ever applies, same as before.
        effects[1] = SpecialEffect({
            shipId: shipId,
            hullDelta: 0,
            reactorTimerDelta: 1,
            newRow: target.position.row,
            newCol: target.position.col,
            removalKind: 0
        });
    }

    function _manhattanDistance(
        int16 r1,
        int16 c1,
        int16 r2,
        int16 c2
    ) private pure returns (uint8) {
        uint8 rowDiff = r1 > r2 ? uint8(uint16(r1 - r2)) : uint8(uint16(r2 - r1));
        uint8 colDiff = c1 > c2 ? uint8(uint16(c1 - c2)) : uint8(uint16(c2 - c1));
        return rowDiff + colDiff;
    }
}
