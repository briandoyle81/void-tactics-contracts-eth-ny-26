// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWinEffect.sol";

interface IShipsMinter {
    function createShips(
        address _to,
        uint _amount,
        uint16 _variant,
        uint8 _tier,
        bool _isFreeShip
    ) external;
}

// Pluggable win effect (see IWinEffect.sol): mints one free ship to the
// winning player, same createShips call FreeShipClaim.sol already uses
// for its own free-ship grants. Needs
// Ships.setIsAllowedToCreateShips(address(this), true) — deploy-time
// wiring, not this contract's concern.
//
// onWin is gated behind its own isAllowedToTrigger allowlist — see
// DECBonusWinEffect.sol's matching comment on why (assume hostile outside
// actors: without this gate, any address could call onWin directly and
// mint itself free ships with no match ever played).
contract ShipGrantWinEffect is Ownable, IWinEffect {
    IShipsMinter public ships;
    uint16 public shipVariant;
    uint8 public shipTier;

    mapping(address => bool) public isAllowedToTrigger;

    error NotAllowedToTrigger();

    event ShipConfigSet(uint16 variant, uint8 tier);
    event TriggerAllowedSet(address indexed caller, bool allowed);

    constructor(
        address _ships,
        uint16 _shipVariant,
        uint8 _shipTier
    ) Ownable(msg.sender) {
        ships = IShipsMinter(_ships);
        shipVariant = _shipVariant;
        shipTier = _shipTier;
    }

    modifier onlyAllowed() {
        if (!isAllowedToTrigger[msg.sender]) revert NotAllowedToTrigger();
        _;
    }

    function setIsAllowedToTrigger(
        address _caller,
        bool _allowed
    ) external onlyOwner {
        isAllowedToTrigger[_caller] = _allowed;
        emit TriggerAllowedSet(_caller, _allowed);
    }

    function setShipsAddress(address _ships) external onlyOwner {
        ships = IShipsMinter(_ships);
    }

    function setShipConfig(
        uint16 _shipVariant,
        uint8 _shipTier
    ) external onlyOwner {
        shipVariant = _shipVariant;
        shipTier = _shipTier;
        emit ShipConfigSet(_shipVariant, _shipTier);
    }

    function onWin(address _player, uint) external override onlyAllowed {
        ships.createShips(_player, 1, shipVariant, shipTier, true);
    }
}
