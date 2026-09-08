// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "../Types.sol";

// Minimal settable stand-in for Game.sol's IGameView surface, so an effect
// resolver's own target-validation logic (e.g. the SP-02 status check) can
// be unit-tested directly without spinning up a full game.
contract MockGameView {
    mapping(uint => mapping(uint => ShipPosition)) private positions;
    mapping(uint => mapping(uint => Attributes)) private attrs;

    function setShipPosition(
        uint _gameId,
        uint _shipId,
        ShipPosition calldata _position
    ) external {
        positions[_gameId][_shipId] = _position;
    }

    function setShipAttributes(
        uint _gameId,
        uint _shipId,
        Attributes calldata _attrs
    ) external {
        attrs[_gameId][_shipId] = _attrs;
    }

    function getShipPosition(
        uint _gameId,
        uint _shipId
    ) external view returns (ShipPosition memory) {
        return positions[_gameId][_shipId];
    }

    function getShipAttributes(
        uint _gameId,
        uint _shipId
    ) external view returns (Attributes memory) {
        return attrs[_gameId][_shipId];
    }

    function getAllShipPositions(
        uint /* _gameId */
    ) external pure returns (ShipPosition[] memory) {
        return new ShipPosition[](0);
    }
}
