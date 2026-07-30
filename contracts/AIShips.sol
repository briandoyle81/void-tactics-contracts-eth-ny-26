// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Types.sol";
import "./IShipAttributes.sol";
import "./IAIShips.sol";

// Non-NFT store for single-player AI ships, sitting behind ShipsRouter.
// AI ships are never owned or traded by players, so there's no ERC-721
// here — just Ship structs keyed by id, backed by a self-expanding
// free-list pool instead of minting a fresh token every match: allocateShip
// reuses a released slot when one is available (growing slotCount only when
// the pool is empty), and releaseShips returns a game's full AI roster to
// the pool once, at game end (see SinglePlayerMatch.onGameEnded) — never
// per-ship-destroyed mid-match, so a slot is never touched while its game
// is still resolving.
//
// Ids are offset into a range disjoint from Ships.sol's own id space so
// ShipsRouter can tell, from the numeric id alone, which backing contract
// to call. 2**40 (~1.1T) is comfortably past any realistic Ships.sol
// token-id count while staying ~8,192x under Number.MAX_SAFE_INTEGER
// (2**53-1) — frontend code that treats ids as JS numbers (rather than
// bigint) needs this to stay exact; a symbolic value like 2**128 (this
// used before) silently breaks that.
contract AIShips is Ownable, IAIShips {
    uint public constant AI_SHIP_ID_OFFSET = 2 ** 40;

    mapping(uint => Ship) private ships; // keyed by LOCAL id, 1-indexed
    uint public slotCount;
    uint[] public freeSlots;

    address public router;
    mapping(address => bool) public isAllowedToCreateShips;
    IShipAttributes public shipAttributes;

    error NotAuthorized(address);

    constructor() Ownable(msg.sender) {}

    function setRouter(address _router) external onlyOwner {
        router = _router;
    }

    function setShipAttributesAddress(
        address _shipAttributes
    ) external onlyOwner {
        shipAttributes = IShipAttributes(_shipAttributes);
    }

    function setIsAllowedToCreateShips(
        address _address,
        bool _isAllowed
    ) external onlyOwner {
        isAllowedToCreateShips[_address] = _isAllowed;
    }

    function freeSlotCount() external view returns (uint) {
        return freeSlots.length;
    }

    function allocateShip(
        address _to,
        Ship calldata _template
    ) external returns (uint globalId) {
        if (!isAllowedToCreateShips[msg.sender]) revert NotAuthorized(msg.sender);

        uint localId;
        uint freeCount = freeSlots.length;
        if (freeCount > 0) {
            localId = freeSlots[freeCount - 1];
            freeSlots.pop();
        } else {
            slotCount++;
            localId = slotCount;
        }
        globalId = localId + AI_SHIP_ID_OFFSET;

        // Every field is overwritten unconditionally so a reused slot is
        // indistinguishable from a fresh one — a previous occupant's kill
        // count or destroyed flag must never leak into the next allocation
        // (ShipAttributes derives a rank bonus from shipsDestroyed).
        Ship storage ship = ships[localId];
        ship.name = _template.name;
        ship.id = globalId;
        ship.equipment = _template.equipment;
        ship.traits = _template.traits;
        ship.traits.serialNumber = 0; // AI ships never go through constructShip
        ship.owner = _to;

        ship.shipData.shipsDestroyed = 0;
        ship.shipData.modified = 0; // never customized via DroneYard
        ship.shipData.shiny = false;
        ship.shipData.constructed = true;
        ship.shipData.inFleet = false;
        ship.shipData.isFreeShip = false;
        ship.shipData.timestampDestroyed = 0;
        // Recomputed live every allocation — Fleets.createFleet reverts on
        // a stale costsVersion, so a remembered value from a prior
        // occupant's allocation is not safe to reuse.
        ship.shipData.costsVersion = shipAttributes.getCurrentCostsVersion();
        ship.shipData.cost = shipAttributes.calculateShipCost(ship);
    }

    function releaseShips(uint[] calldata _shipIds) external {
        if (!isAllowedToCreateShips[msg.sender]) revert NotAuthorized(msg.sender);
        for (uint i = 0; i < _shipIds.length; i++) {
            freeSlots.push(_shipIds[i] - AI_SHIP_ID_OFFSET);
        }
    }

    function getShip(uint _id) external view returns (Ship memory) {
        return ships[_id - AI_SHIP_ID_OFFSET];
    }

    function isShipDestroyed(uint _id) external view returns (bool) {
        return ships[_id - AI_SHIP_ID_OFFSET].shipData.timestampDestroyed != 0;
    }

    function markDestroyed(uint _id) external returns (address ownerOut) {
        if (msg.sender != router) revert NotAuthorized(msg.sender);
        Ship storage ship = ships[_id - AI_SHIP_ID_OFFSET];
        ship.shipData.timestampDestroyed = block.timestamp;
        return ship.owner;
    }

    function recordKill(uint _destroyerId) external returns (address ownerOut) {
        if (msg.sender != router) revert NotAuthorized(msg.sender);
        Ship storage ship = ships[_destroyerId - AI_SHIP_ID_OFFSET];
        ship.shipData.shipsDestroyed++;
        return ship.owner;
    }

    function setInFleet(uint _id, bool _inFleet) external {
        if (msg.sender != router) revert NotAuthorized(msg.sender);
        ships[_id - AI_SHIP_ID_OFFSET].shipData.inFleet = _inFleet;
    }
}
