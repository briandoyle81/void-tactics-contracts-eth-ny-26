// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IDroneEnergyCores.sol";

// Where players spend DEC (a freely transferable ERC20 — see
// DroneEnergyCores.sol): turn in an exact tier's worth of cores to
// permanently step up droneCoreTier, which FreeShipClaim.claimFreeShips
// reads directly as a player's free-ship bonus (1 tier = +1 ship — see
// IDroneStorefront.sol/FreeShipClaim.sol).
contract DroneStorefront is Ownable {
    address public droneEnergyCores;

    // tierCoreCost[i] = cores required to advance from tier i to tier i+1.
    // Tiers must be purchased in order; the number of configured tiers is
    // itself the cap on how large a player's bonus can grow.
    uint256[] public tierCoreCost;
    mapping(address => uint8) public droneCoreTier;

    event TierAdded(uint256 indexed tierIndex, uint256 cost);
    event CoresTurnedIn(address indexed player, uint8 newTier, uint256 amount);

    error MaxTierReached(address);
    error WrongAmount(uint256 expected, uint256 provided);

    constructor(address _droneEnergyCores) Ownable(msg.sender) {
        droneEnergyCores = _droneEnergyCores;
    }

    function setDroneEnergyCoresAddress(
        address _droneEnergyCores
    ) external onlyOwner {
        droneEnergyCores = _droneEnergyCores;
    }

    function addTier(uint256 _cost) external onlyOwner {
        tierCoreCost.push(_cost);
        emit TierAdded(tierCoreCost.length - 1, _cost);
    }

    // Turns in the exact number of cores required for the caller's next
    // tier, permanently granting +1 to their free-ship bonus.
    function turnInCores(uint256 _amount) external {
        uint8 currentTier = droneCoreTier[msg.sender];
        if (currentTier >= tierCoreCost.length) {
            revert MaxTierReached(msg.sender);
        }

        uint256 required = tierCoreCost[currentTier];
        if (_amount != required) {
            revert WrongAmount(required, _amount);
        }

        require(
            IDroneEnergyCores(droneEnergyCores).transferFrom(
                msg.sender,
                address(this),
                _amount
            ),
            "DEC transfer failed"
        );

        droneCoreTier[msg.sender] = currentTier + 1;

        emit CoresTurnedIn(msg.sender, currentTier + 1, _amount);
    }
}
