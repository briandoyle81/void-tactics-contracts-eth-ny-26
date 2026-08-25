// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Types.sol";
import "./IRenderer.sol";

contract RenderMetadata is IRenderMetadata, Ownable {
    using Strings for uint256;

    // Typed against the shared interface (not the concrete ImageRenderer
    // contract) so a new variant's image renderer -- e.g. ImageRendererV2 --
    // can be wired in via the same constructor param without this contract
    // depending on that concrete type.
    IImageRenderer public immutable imageRenderer;
    IImageRenderer public immutable imageRendererV2;

    // Special is a per-faction local slot (0-7), not a global identity, so
    // its display name is keyed by (variant, slot) rather than a single
    // hardcoded if-chain — a per-special branch can't scale to hundreds of
    // specials across dozens of factions within a 24 KiB contract. None
    // (slot 0) is the one truly universal case and stays hardcoded below.
    mapping(uint16 => mapping(Special => string)) public specialNames;

    // MainWeapon/Armor/Shields names are keyed by (variant, enum value) for
    // the same reason as specialNames above: each faction reskins the same
    // mechanical enum with its own flavor text (e.g. variant 2's Generic is a
    // "Medium Mining Laser"), and a hardcoded if-chain per variant doesn't
    // scale. Armor.None/Shields.None are the truly universal cases and stay
    // hardcoded below; MainWeapon has no None value, so it has no hardcoded
    // fallback.
    mapping(uint16 => mapping(MainWeapon => string)) public mainWeaponNames;
    mapping(uint16 => mapping(Armor => string)) public armorNames;
    mapping(uint16 => mapping(Shields => string)) public shieldsNames;

    constructor(
        address _imageRenderer,
        address _imageRendererV2
    ) Ownable(msg.sender) {
        imageRenderer = IImageRenderer(_imageRenderer);
        imageRendererV2 = IImageRenderer(_imageRendererV2);
    }

    function setSpecialName(
        uint16 _variant,
        Special _slot,
        string memory _name
    ) external onlyOwner {
        specialNames[_variant][_slot] = _name;
    }

    function setMainWeaponName(
        uint16 _variant,
        MainWeapon _weapon,
        string memory _name
    ) external onlyOwner {
        mainWeaponNames[_variant][_weapon] = _name;
    }

    function setArmorName(
        uint16 _variant,
        Armor _armor,
        string memory _name
    ) external onlyOwner {
        armorNames[_variant][_armor] = _name;
    }

    function setShieldsName(
        uint16 _variant,
        Shields _shields,
        string memory _name
    ) external onlyOwner {
        shieldsNames[_variant][_shields] = _name;
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
                    getArmorString(ship.equipment.armor, ship.traits.variant),
                    '"},',
                    '{"trait_type": "Shields", "value": "',
                    getShieldsString(ship.equipment.shields, ship.traits.variant),
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
    ) internal view returns (string memory) {
        string memory name = mainWeaponNames[variant][weapon];
        if (bytes(name).length == 0) return "Unknown";
        return name;
    }

    function getArmorString(
        Armor armor,
        uint16 variant
    ) internal view returns (string memory) {
        if (armor == Armor.None) return "No Armor";
        string memory name = armorNames[variant][armor];
        if (bytes(name).length == 0) return "Unknown";
        return name;
    }

    function getShieldsString(
        Shields shields,
        uint16 variant
    ) internal view returns (string memory) {
        if (shields == Shields.None) return "No Shields";
        string memory name = shieldsNames[variant][shields];
        if (bytes(name).length == 0) return "Unknown";
        return name;
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

        string memory imageUri = ship.traits.variant == 2
            ? imageRendererV2.renderShip(ship)
            : imageRenderer.renderShip(ship);

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
