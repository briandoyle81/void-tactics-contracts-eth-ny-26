// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";

interface IShipAttributes {
    function calculateShipAttributes(
        Ship memory _ship
    ) external view returns (Attributes memory);

    function calculateShipAttributesById(
        uint _shipId
    ) external view returns (Attributes memory);

    function calculateShipAttributesByIds(
        uint[] memory _shipIds
    ) external view returns (Attributes[] memory);

    function getSpecialRange(
        Special _special,
        uint16 _variant
    ) external view returns (uint8);

    function getSpecialStrength(
        Special _special,
        uint16 _variant
    ) external view returns (uint8);

    function getGunData(
        MainWeapon _weapon,
        uint16 _variant
    ) external view returns (GunData memory);

    function getArmorData(
        Armor _armor,
        uint16 _variant
    ) external view returns (ArmorData memory);

    function getShieldData(
        Shields _shields,
        uint16 _variant
    ) external view returns (ShieldData memory);

    function getSpecialData(
        Special _special,
        uint16 _variant
    ) external view returns (SpecialData memory);

    // Cost calculation functions
    function calculateShipCost(Ship memory ship) external view returns (uint16);

    function setCosts(uint16 _variant, Costs memory _costs) external;

    function getCosts(
        uint16 _variant
    ) external view returns (uint, Costs memory);

    function getCurrentCostsVersion(
        uint16 _variant
    ) external view returns (uint16);

    // Attributes version management functions
    function setCurrentAttributesVersion(uint16 _version) external;

    function getCurrentAttributesVersion() external view returns (uint16);

    function getAttributesVersionBase(
        uint16 _version,
        uint16 _variant
    ) external view returns (uint16 version, uint8 baseHull, uint8 baseSpeed);

    function startNewAttributesVersion() external returns (uint16 newVersion);

    function setVariantAttributes(
        SetVariantAttributesParams memory params
    ) external;
}
