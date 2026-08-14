// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";
import "./IEffectResolver.sol";
import "./IGameView.sol";
import "./IShipAttributes.sol";

// EMP: an equipped Special dispatched via
// Game.specialResolvers[variant][slot], where `slot` is whichever faction
// slot this instance is registered at (set once at deploy time — see
// `slot` below). Adds to an enemy ship's reactor critical timer within
// range; the shared SpecialEffectsLib._applyEffect path destroys the ship
// once that timer reaches 3, same as every other reactor-timer-driven
// removal. Range/strength stay in the shared per-variant SpecialData table
// (IShipAttributes) rather than being owned by this contract, so factions
// can retune numbers via ShipAttributes.setVariantAttributes without
// redeploying this resolver.
contract EMPResolver is IEffectResolver {
    int16 constant NO_RELOCATE = type(int16).min;

    IGameView public game;
    IShipAttributes public shipAttributes;
    address public owner;
    // Which faction slot (0-7) this instance is registered at — Special is
    // a per-faction local index, not a global identity, so this resolver
    // must be told its own slot rather than assuming one. The same
    // resolver contract can be redeployed with a different _slot if
    // another faction wants this exact behavior at a different slot.
    Special public immutable slot;

    error NotOwner();
    error TargetNotFound();
    error TargetNotEnemy();
    error OutOfRange();

    constructor(address _game, address _shipAttributes, Special _slot) {
        game = IGameView(_game);
        shipAttributes = IShipAttributes(_shipAttributes);
        owner = msg.sender;
        slot = _slot;
    }

    function setGameAddress(address _game) external {
        if (msg.sender != owner) revert NotOwner();
        game = IGameView(_game);
    }

    function setShipAttributesAddress(address _shipAttributes) external {
        if (msg.sender != owner) revert NotOwner();
        shipAttributes = IShipAttributes(_shipAttributes);
    }

    function resolveEffect(
        uint gameId,
        uint shipId,
        uint16 variant,
        uint targetShipId,
        int16 actingRow,
        int16 actingCol
    ) external view returns (SpecialEffect[] memory effects) {
        ShipPosition memory acting = game.getShipPosition(gameId, shipId);
        ShipPosition memory target = game.getShipPosition(gameId, targetShipId);
        if (acting.shipId == 0 || target.shipId == 0) revert TargetNotFound();
        // EMP can only target enemy ships.
        if (acting.isCreator == target.isCreator) revert TargetNotEnemy();

        uint8 range = shipAttributes.getSpecialRange(slot, variant);
        if (
            _manhattanDistance(
                actingRow,
                actingCol,
                target.position.row,
                target.position.col
            ) > range
        ) revert OutOfRange();

        uint8 strength = shipAttributes.getSpecialStrength(slot, variant);

        effects = new SpecialEffect[](1);
        effects[0] = SpecialEffect({
            shipId: targetShipId,
            hullDelta: 0,
            reactorTimerDelta: int8(uint8(strength)),
            newRow: NO_RELOCATE,
            newCol: 0,
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
