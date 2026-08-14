// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Types.sol";
import "./IRenderer.sol";
import "./ImageRenderer.sol";

contract RenderMetadata is IRenderMetadata, Ownable {
    using Strings for uint256;

    ImageRenderer public immutable imageRenderer;

    // Special is a per-faction local slot (0-7), not a global identity, so
    // its display name is keyed by (variant, slot) rather than a single
    // hardcoded if-chain — a per-special branch can't scale to hundreds of
    // specials across dozens of factions within a 24 KiB contract. None
    // (slot 0) is the one truly universal case and stays hardcoded below.
    mapping(uint16 => mapping(Special => string)) public specialNames;

    constructor(address _imageRenderer) Ownable(msg.sender) {
        imageRenderer = ImageRenderer(_imageRenderer);
    }

    function setSpecialName(
        uint16 _variant,
        Special _slot,
        string memory _name
    ) external onlyOwner {
        specialNames[_variant][_slot] = _name;
    }

    function getBasicTraitsString(
        Ship memory ship
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '{"trait_type": "Serial Number", "value": "',
                    ship.traits.serialNumber.toString(),
                    '"},',
                    '{"trait_type": "Variant", "value": "',
                    Strings.toString(ship.traits.variant),
                    '"},',
                    '{"trait_type": "Accuracy", "value": ',
                    Strings.toString(ship.traits.accuracy),
                    "},",
                    '{"trait_type": "Hull", "value": ',
                    Strings.toString(ship.traits.hull),
                    "},",
                    '{"trait_type": "Speed", "value": ',
                    Strings.toString(ship.traits.speed),
                    "}"
                )
            );
    }

    function getStatusTraitsString(
        Ship memory ship
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '{"trait_type": "Shiny", "value": "',
                    ship.shipData.shiny ? "Yes" : "No",
                    '"},',
                    '{"trait_type": "Ships Destroyed", "value": ',
                    Strings.toString(uint256(ship.shipData.shipsDestroyed)),
                    "},",
                    '{"trait_type": "Cost", "value": ',
                    Strings.toString(uint256(ship.shipData.cost)),
                    "},",
                    '{"trait_type": "Modified", "value": "',
                    ship.shipData.modified != 0 ? "Yes" : "No",
                    '"}'
                )
            );
    }

    function getEquipmentTraitsString(
        Ship memory ship
    ) internal view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '{"trait_type": "Main Weapon", "value": "',
                    getMainWeaponString(ship.equipment.mainWeapon, ship.traits.variant),
                    '"},',
                    '{"trait_type": "Armor", "value": "',
                    getArmorString(ship.equipment.armor),
                    '"},',
                    '{"trait_type": "Shields", "value": "',
                    getShieldsString(ship.equipment.shields),
                    '"},',
                    '{"trait_type": "Special", "value": "',
                    getSpecialString(ship.equipment.special, ship.traits.variant),
                    '"}'
                )
            );
    }

    function getTraitsString(
        Ship memory ship
    ) internal view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    getBasicTraitsString(ship),
                    ",",
                    getStatusTraitsString(ship),
                    ",",
                    getEquipmentTraitsString(ship)
                )
            );
    }

    function getMainWeaponString(
        MainWeapon weapon,
        uint16 variant
    ) internal pure returns (string memory) {
        if (variant == 2) {
            if (weapon == MainWeapon.Laser) return "Mining Laser";
            if (weapon == MainWeapon.Railgun) return "Mass Driver";
            if (weapon == MainWeapon.MissileLauncher) return "Attack Drones";
            if (weapon == MainWeapon.PlasmaCannon) return "Plasma Beam";
            return "Unknown";
        }
        if (weapon == MainWeapon.Laser) return "Laser";
        if (weapon == MainWeapon.Railgun) return "Railgun";
        if (weapon == MainWeapon.MissileLauncher) return "Missile Launcher";
        if (weapon == MainWeapon.PlasmaCannon) return "Plasma Cannon";
        return "Unknown";
    }

    function getArmorString(Armor armor) internal pure returns (string memory) {
        if (armor == Armor.None) return "No Armor";
        if (armor == Armor.Light) return "Light Armor";
        if (armor == Armor.Medium) return "Medium Armor";
        if (armor == Armor.Heavy) return "Heavy Armor";
        return "Unknown";
    }

    function getShieldsString(
        Shields shields
    ) internal pure returns (string memory) {
        if (shields == Shields.None) return "No Shields";
        if (shields == Shields.Light) return "Light Shields";
        if (shields == Shields.Medium) return "Medium Shields";
        if (shields == Shields.Heavy) return "Heavy Shields";
        return "Unknown";
    }

    function getSpecialString(
        Special special,
        uint16 variant
    ) internal view returns (string memory) {
        if (special == Special.None) return "No Special";
        string memory name = specialNames[variant][special];
        if (bytes(name).length == 0) return "Unknown";
        return name;
    }

    function tokenURI(
        Ship memory ship
    ) public view override returns (string memory) {
        if (ship.id == 0) {
            revert("InvalidId");
        }

        string memory imageUri = imageRenderer.renderShip(ship);

        string memory baseJson = string(
            abi.encodePacked(
                '{"name": "',
                ship.name,
                " #",
                ship.id.toString(),
                '","description": "A unique spaceship in the Void Tactics universe. Each ship has unique traits, equipment, and stats that determine its capabilities in battle.", "attributes": [',
                getTraitsString(ship),
                '],"image": "',
                imageUri,
                '"}'
            )
        );

        string memory json = Base64.encode(bytes(baseJson));
        return string(abi.encodePacked("data:application/json;base64,", json));
    }
}
