// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Types.sol";
import "./IShips.sol";
import "./IFleets.sol";
import "./IShipAttributes.sol";

contract Fleets is Ownable, IFleets {
    IShips public ships;
    IShipAttributes public shipAttributes;
    // Contracts (e.g. Lobbies, SinglePlayerMatch) authorized to manage
    // fleets, mirroring Game.isAllowedToStartGames. Widened from a single
    // lobbiesAddress so more than one orchestrator can create/clear fleets
    // (Lobbies-free vs-AI matches via SinglePlayerMatch, alongside PvP via
    // Lobbies).
    mapping(address => bool) public isAllowedToManageFleets;
    address public gameAddress;

    mapping(uint => Fleet) public fleets;
    uint public fleetCount;

    event FleetCreated(
        uint indexed fleetId,
        uint indexed lobbyId,
        address indexed owner
    );
    event FleetCleared(uint indexed fleetId);

    error NotAllowedToManageFleets();
    error FleetNotFound();
    error ShipNotOwned();
    error ShipAlreadyInFleet();
    error ShipCostVersionMismatch();
    error InvalidFleetCost();
    error ShipNotFound();
    error DuplicatePosition();
    error ArrayLengthMismatch();
    error InvalidPosition();

    constructor(address _ships) Ownable(msg.sender) {
        ships = IShips(_ships);
    }

    function setIsAllowedToManageFleets(
        address _address,
        bool _isAllowed
    ) public onlyOwner {
        isAllowedToManageFleets[_address] = _isAllowed;
    }

    function setGameAddress(address _gameAddress) public onlyOwner {
        gameAddress = _gameAddress;
    }

    function setShipAttributes(address _shipAttributes) public onlyOwner {
        shipAttributes = IShipAttributes(_shipAttributes);
    }

    function createFleet(
        uint _lobbyId,
        address _owner,
        uint[] calldata _shipIds,
        Position[] calldata _startingPositions,
        uint _costLimit,
        bool _isCreator
    ) external returns (uint) {
        if (!isAllowedToManageFleets[msg.sender])
            revert NotAllowedToManageFleets();

        // Validate that shipIds and startingPositions arrays have the same length
        if (_shipIds.length != _startingPositions.length)
            revert ArrayLengthMismatch();

        // Validate positions based on whether this is creator or joiner fleet, and
        // check for duplicates in the same pass (I-09: these used to be two
        // separate loops over the same array with no dependency between them).
        // O(n), all in memory, no storage writes. Use bitset for 17×11 grid (187
        // positions max).
        uint256[2] memory positionBitset; // 2 * 256 = 512 bits > 187 positions
        for (uint i = 0; i < _startingPositions.length; i++) {
            Position memory pos = _startingPositions[i];

            if (_isCreator) {
                // Creator ships must be in columns 0-3 (first 4 columns)
                if (pos.col < 0 || pos.col > 3) revert InvalidPosition();
            } else {
                // Joiner ships must be in columns 13-16 (last 4 columns)
                if (pos.col < 13 || pos.col > 16) revert InvalidPosition();
            }

            // Validate row bounds (0-10 for 11 rows)
            if (pos.row < 0 || pos.row > 10) revert InvalidPosition();

            // Convert position to single key: row * GRID_WIDTH + col
            uint256 key = uint256(int256(pos.row)) *
                17 +
                uint256(int256(pos.col));
            uint256 wordIndex = key / 256;
            uint256 bitIndex = key % 256;
            if ((positionBitset[wordIndex] & (1 << bitIndex)) != 0) {
                revert DuplicatePosition();
            }
            positionBitset[wordIndex] |= (1 << bitIndex);
        }

        uint totalCost = 0;
        fleetCount++;
        uint fleetId = fleetCount;

        Fleet storage newFleet = fleets[fleetId];
        newFleet.id = fleetId;
        newFleet.lobbyId = _lobbyId;
        newFleet.owner = _owner;
        newFleet.shipIds = _shipIds;

        // Copy startingPositions array element by element
        for (uint i = 0; i < _startingPositions.length; i++) {
            newFleet.startingPositions.push(_startingPositions[i]);
        }

        // Validate ships and calculate total cost
        for (uint i = 0; i < _shipIds.length; i++) {
            uint shipId = _shipIds[i];
            Ship memory ship = ships.getShip(shipId);

            // Validate ship ownership
            if (ship.owner != _owner) revert ShipNotOwned();

            // Validate ship is not in another fleet
            if (ship.shipData.inFleet) revert ShipAlreadyInFleet();

            // Validate cost version
            if (
                ship.shipData.costsVersion !=
                shipAttributes.getCurrentCostsVersion()
            ) revert ShipCostVersionMismatch();

            totalCost += ship.shipData.cost;
        }

        // Validate total cost
        if (totalCost > _costLimit) revert InvalidFleetCost();

        newFleet.totalCost = totalCost;
        newFleet.isComplete = true;

        // Mark ships as in fleet
        for (uint i = 0; i < _shipIds.length; i++) {
            ships.setInFleet(_shipIds[i], true);
        }

        emit FleetCreated(fleetId, _lobbyId, _owner);
        return fleetId;
    }

    function clearFleet(uint _fleetId) external {
        if (!isAllowedToManageFleets[msg.sender])
            revert NotAllowedToManageFleets();

        Fleet storage fleet = fleets[_fleetId];
        if (fleet.id == 0) revert FleetNotFound();

        // Release ships from fleet
        for (uint i = 0; i < fleet.shipIds.length; i++) {
            ships.setInFleet(fleet.shipIds[i], false);
        }

        // Clear the fleet's shipIds array
        delete fleet.shipIds;

        emit FleetCleared(_fleetId);
    }

    function removeShipFromFleet(uint _fleetId, uint _shipId) external {
        if (!isAllowedToManageFleets[msg.sender] && msg.sender != gameAddress)
            revert NotAllowedToManageFleets();

        Fleet storage fleet = fleets[_fleetId];
        if (fleet.id == 0) revert FleetNotFound();

        // Find and remove the ship from the fleet
        for (uint i = 0; i < fleet.shipIds.length; i++) {
            if (fleet.shipIds[i] == _shipId) {
                // Remove ship from array by shifting elements
                for (uint j = i; j < fleet.shipIds.length - 1; j++) {
                    fleet.shipIds[j] = fleet.shipIds[j + 1];
                }
                fleet.shipIds.pop();

                // Read cost before releasing the ship from the fleet: a ship's cost
                // is only ever writable while inFleet is false (see Ships._setCostOfShip
                // and DroneYard.modifyShip), so this ordering can't change behavior
                // today, but it stops relying on that invariant holding elsewhere.
                Ship memory ship = ships.getShip(_shipId);
                fleet.totalCost -= ship.shipData.cost;

                // Release ship from fleet
                ships.setInFleet(_shipId, false);

                return;
            }
        }

        // Ship not found in fleet
        revert ShipNotFound();
    }

    // View functions
    function getFleet(uint _fleetId) external view returns (Fleet memory) {
        if (fleets[_fleetId].id == 0) revert FleetNotFound();
        return fleets[_fleetId];
    }

    // Check if a ship is in a specific fleet
    function isShipInFleet(
        uint _fleetId,
        uint _shipId
    ) external view returns (bool) {
        if (fleets[_fleetId].id == 0) revert FleetNotFound();

        Fleet memory fleet = fleets[_fleetId];
        for (uint i = 0; i < fleet.shipIds.length; i++) {
            if (fleet.shipIds[i] == _shipId) {
                return true;
            }
        }
        return false;
    }

    function getFleetShipIdsAndPositions(
        uint _fleetId
    )
        external
        view
        returns (uint[] memory shipIds, Position[] memory startingPositions)
    {
        if (fleets[_fleetId].id == 0) revert FleetNotFound();
        Fleet memory fleet = fleets[_fleetId];
        return (fleet.shipIds, fleet.startingPositions);
    }
}
