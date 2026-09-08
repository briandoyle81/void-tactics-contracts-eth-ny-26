// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWinEffect.sol";

interface IMintableDEC {
    function mint(address _to, uint _amount) external;
}

// Pluggable win effect (see IWinEffect.sol): mints a fixed bonus amount of
// DEC to the winning player. Needs
// DroneEnergyCores.setAuthorizedToMint(address(this), true) and
// DroneEnergyCores.mintIsActive == true (both owner-gated on that
// contract) before onWin can actually mint — deploy-time wiring, not this
// contract's concern.
//
// onWin is gated behind its own isAllowedToTrigger allowlist (not just
// "anyone can call it") — mirrors this codebase's blanket "assume hostile
// outside actors" rule for permissionless-looking entry points: without
// this gate, any address could call onWin directly and mint itself free
// DEC repeatedly, with no match ever played. RoguelikeMatch.sol,
// PvPMatch.sol, and Tournament.sol are each independently granted this as
// needed.
contract DECBonusWinEffect is Ownable, IWinEffect {
    IMintableDEC public dec;
    uint public bonusAmount;

    mapping(address => bool) public isAllowedToTrigger;

    error NotAllowedToTrigger();

    event BonusAmountSet(uint amount);
    event TriggerAllowedSet(address indexed caller, bool allowed);

    constructor(address _dec, uint _bonusAmount) Ownable(msg.sender) {
        dec = IMintableDEC(_dec);
        bonusAmount = _bonusAmount;
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

    function setDECAddress(address _dec) external onlyOwner {
        dec = IMintableDEC(_dec);
    }

    function setBonusAmount(uint _bonusAmount) external onlyOwner {
        bonusAmount = _bonusAmount;
        emit BonusAmountSet(_bonusAmount);
    }

    function onWin(address _player, uint) external override onlyAllowed {
        if (bonusAmount > 0) dec.mint(_player, bonusAmount);
    }
}
