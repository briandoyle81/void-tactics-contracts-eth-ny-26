// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./IShips.sol";
import "./IDroneStorefront.sol";

// Recurring free-ship claim, split out of Ships.sol entirely (which has
// almost no bytecode headroom left) and built on the same
// isAllowedToCreateShips "authorized minter" pattern DroneYard/ShipPurchaser/
// TutorialClaim already use — Ships.sol needed zero new logic beyond an
// _isFreeShip flag on its existing createShips (see Ships.sol/IShips.sol).
contract FreeShipClaim is Ownable, ReentrancyGuard {
    IShips public ships;
    address public droneStorefront;

    mapping(address => uint256) public lastClaimTimestamp;

    // 4 weeks in seconds (28 days * 24 hours * 60 minutes * 60 seconds)
    uint256 public claimCooldownPeriod = 28 days;

    error ClaimCooldownNotPassed();

    constructor(address _ships) Ownable(msg.sender) {
        ships = IShips(_ships);
    }

    function setDroneStorefront(address _droneStorefront) external onlyOwner {
        droneStorefront = _droneStorefront;
    }

    function setClaimCooldownPeriod(
        uint256 _newCooldownPeriod
    ) external onlyOwner {
        claimCooldownPeriod = _newCooldownPeriod;
    }

    function claimFreeShips(uint16 _variant) external nonReentrant {
        uint256 lastClaim = lastClaimTimestamp[msg.sender];
        uint256 currentTime = block.timestamp;

        // Note: When lastClaim == 0 (first claim), currentTime will always
        // be much larger than claimCooldownPeriod, so this won't revert for
        // new users.
        if (currentTime < lastClaim + claimCooldownPeriod) {
            revert ClaimCooldownNotPassed();
        }

        // Checks-effects-interactions: record the claim before minting,
        // since ships.createShips's _safeMint can hand control to msg.sender
        // (if it's a contract) via onERC721Received before this function
        // returns — nonReentrant already blocks a reentrant claimFreeShips
        // call, but this ordering is the actual fix (see docs/pre-audit.md
        // SP-01) and matches TutorialClaim's pattern.
        lastClaimTimestamp[msg.sender] = currentTime;

        // 10 base ships, plus a permanent bonus (DroneStorefront's own tier
        // count) earned by turning in drone cores — 1 tier = +1 ship.
        uint256 bonus = droneStorefront == address(0)
            ? 0
            : IDroneStorefront(droneStorefront).droneCoreTier(msg.sender);

        ships.createShips(msg.sender, 10 + bonus, _variant, 0, true);
    }
}
