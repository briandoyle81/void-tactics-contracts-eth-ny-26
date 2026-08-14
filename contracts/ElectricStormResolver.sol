// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";
import "./IEffectResolver.sol";
import "./IGameView.sol";
import "./IShipAttributes.sol";

// Electric Storm: an equipped Special dispatched via
// Game.specialResolvers[variant][slot], where `slot` is whichever faction
// slot this instance is registered at (set once at deploy time — see
// `slot` below). Self-centered AoE reactor damage against EVERY active
// ship within range — both sides, AND the caster itself (unlike
// FlakArrayResolver, which excludes the caster). targetShipId is unused
// (the 0 = "no target" convention, same as FlakArray). Reactor damage
// isn't reduced by armor/shields, matching EMPResolver's convention.
// Range/strength stay in the shared per-variant SpecialData table
// (IShipAttributes) rather than being owned by this contract, so factions
// can retune numbers via ShipAttributes.setVariantAttributes without
// redeploying this resolver.
contract ElectricStormResolver is IEffectResolver {
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

    // Bundled to keep resolveEffect's own local count low — legacy Solidity
    // codegen runs out of stack slots quickly otherwise (same reasoning as
    // FlakArrayResolver.FlakContext).
    struct StormContext {
        int16 actingRow;
        int16 actingCol;
        uint8 range;
        int8 strength;
    }

    function resolveEffect(
        uint gameId,
        uint /* shipId */,
        uint16 variant,
        uint /* targetShipId */,
        int16 actingRow,
        int16 actingCol
    ) external view returns (SpecialEffect[] memory effects) {
        StormContext memory ctx = StormContext({
            actingRow: actingRow,
            actingCol: actingCol,
            range: shipAttributes.getSpecialRange(slot, variant),
            strength: int8(shipAttributes.getSpecialStrength(slot, variant))
        });

        ShipPosition[] memory positions = game.getAllShipPositions(gameId);

        // Exact-size the result array (a zero-filled unused slot would be
        // misread downstream as a relocation to (0,0), since newRow must be
        // NO_RELOCATE on every real entry) — count in-range live ships
        // first, then fill. Deliberately includes the caster itself — no
        // self-exclusion check, unlike FlakArrayResolver's _inRange.
        uint count;
        for (uint i = 0; i < positions.length; i++) {
            if (_inRange(positions[i], ctx)) count++;
        }

        effects = new SpecialEffect[](count);
        uint idx;
        for (uint i = 0; i < positions.length; i++) {
            if (!_inRange(positions[i], ctx)) continue;
            effects[idx] = SpecialEffect({
                shipId: positions[i].shipId,
                hullDelta: 0,
                reactorTimerDelta: ctx.strength,
                newRow: NO_RELOCATE,
                newCol: 0,
                removalKind: 0
            });
            idx++;
        }
    }

    function _inRange(
        ShipPosition memory pos,
        StormContext memory ctx
    ) private pure returns (bool) {
        if (pos.status != 0) return false;
        return
            _manhattanDistance(
                ctx.actingRow,
                ctx.actingCol,
                pos.position.row,
                pos.position.col
            ) <= ctx.range;
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
