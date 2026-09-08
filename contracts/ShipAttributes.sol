// SPDX-License-Identifier: UNLICENSED

// Attributes turns traits into the numbers used by the game
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Types.sol";
import "./IShips.sol";
import "./IShipAttributes.sol";

contract ShipAttributes is IShipAttributes, Ownable {
    IShips public ships;

    // Attributes version tracking
    mapping(uint16 => AttributesVersion) public attributesVersions;
    uint16 public currentAttributesVersion;

    // Cost system — per-variant, keyed by traits.variant. A zero-valued
    // `.version` means the variant has never been configured; reads for an
    // unconfigured variant revert (fail loud) rather than silently
    // returning a near-zero cost — same philosophy as VariantAttributeData.
    mapping(uint16 => Costs) public costsByVariant;

    error InvalidAttributesVersion();
    error ShipNotFound();
    error InvalidCostsVersion();

    event CostsSet(uint16 variant, uint16 version);
    event CurrentAttributesVersionSet(uint16 version);
    event AttributesVersionCreated(uint16 version);
    event VariantAttributesSet(uint16 version, uint16 variant);

    // No variant is seeded here on purpose — variant 1 and variant 2 are
    // both configured identically via setCosts/setVariantAttributes calls
    // in ignition/modules/DeployAndConfig.ts (setCostsVariant1Call/
    // setVariant1AttributesCall alongside their variant-2 counterparts),
    // not hardcoded here. Every variant, including 1, is unconfigured
    // (fails loud — see setVariantAttributes's doc comment) until those
    // calls run.
    constructor(address _ships) Ownable(msg.sender) {
        ships = IShips(_ships);

        // Initialize attributes version 1
        currentAttributesVersion = 1;
        attributesVersions[1].version = 1;
    }

    function setShipsAddress(address _ships) public onlyOwner {
        ships = IShips(_ships);
    }

    // Calculate attributes for a ship in memory and return Attributes
    function calculateShipAttributes(
        Ship memory _ship
    ) public view returns (Attributes memory) {
        if (_ship.id == 0) revert ShipNotFound();

        uint8 rank = getRank(_ship.shipData.shipsDestroyed);
        uint8 rankMultiplier = 0;
        if (rank == 1) {
            rankMultiplier = 0;
        } else if (rank == 2) {
            rankMultiplier = 10;
        } else if (rank == 3) {
            rankMultiplier = 20;
        } else if (rank == 4) {
            rankMultiplier = 30;
        } else if (rank == 5) {
            rankMultiplier = 40;
        } else if (rank >= 6) {
            rankMultiplier = 50;
        }

        VariantAttributeData storage variantData = attributesVersions[
            currentAttributesVersion
        ].variantData[_ship.traits.variant];

        Attributes memory attributes;
        // Calculate base attributes from ship traits and equipment
        attributes.version = currentAttributesVersion;
        attributes.range = variantData
            .guns[uint8(_ship.equipment.mainWeapon)]
            .range;
        // Increase range by the rank multiplier as a percentage (avoid overflow)
        uint calculatedBonus = (uint(attributes.range) * rankMultiplier) / 100;
        attributes.range += uint8(calculatedBonus);

        // Apply fore accuracy bonus to range as percentage increase (bridge + level extend range)
        uint8 foreAccuracyBonus = variantData.foreAccuracy[
            uint8(_ship.traits.accuracy)
        ];
        calculatedBonus = (uint(attributes.range) * foreAccuracyBonus) / 100;
        attributes.range += uint8(calculatedBonus);
        attributes.gunDamage = variantData
            .guns[uint8(_ship.equipment.mainWeapon)]
            .damage;
        // Increase damage by the rank multiplier as a percentage (avoid overflow)
        calculatedBonus = (uint(attributes.gunDamage) * rankMultiplier) / 100;
        attributes.gunDamage += uint8(calculatedBonus);
        attributes.hullPoints = _calculateHullPoints(_ship);
        // Increase hull points by the rank multiplier as a percentage (avoid overflow)
        calculatedBonus = (uint(attributes.hullPoints) * rankMultiplier) / 100;
        attributes.hullPoints += uint8(calculatedBonus);
        attributes.maxHullPoints = attributes.hullPoints;
        attributes.movement = _calculateMovement(_ship);
        // Increase movement by the rank multiplier as a percentage (avoid overflow)
        calculatedBonus = (uint(attributes.movement) * rankMultiplier) / 100;
        attributes.movement += uint8(calculatedBonus);
        attributes.damageReduction = _calculateDamageReduction(_ship);
        // Increase damage reduction by the rank multiplier as a percentage (avoid overflow)
        calculatedBonus =
            (uint(attributes.damageReduction) * rankMultiplier) /
            100;
        attributes.damageReduction += uint8(calculatedBonus);
        // Initialize empty status effects array
        attributes.statusEffects = new uint8[](0);

        return attributes;
    }

    function getRank(uint _shipsDestroyed) public pure returns (uint8) {
        // Rank 1: 0-9 kills (0% bonus)
        // Rank 2: 10-29 kills (10% bonus)
        // Rank 3: 30-99 kills (20% bonus)
        // Rank 4: 100-299 kills (30% bonus)
        // Rank 5: 300-999 kills (40% bonus)
        // Rank 6: 1000+ kills (50% bonus)
        if (_shipsDestroyed >= 1000) {
            return 6;
        } else if (_shipsDestroyed >= 300) {
            return 5;
        } else if (_shipsDestroyed >= 100) {
            return 4;
        } else if (_shipsDestroyed >= 30) {
            return 3;
        } else if (_shipsDestroyed >= 10) {
            return 2;
        } else {
            return 1;
        }
    }

    // Calculate attributes for a ship by ID
    function calculateShipAttributesById(
        uint _shipId
    ) public view returns (Attributes memory) {
        Ship memory ship = ships.getShip(_shipId);
        if (ship.id == 0) revert ShipNotFound();
        return calculateShipAttributes(ship);
    }

    // Calculate attributes for multiple ships by their IDs
    function calculateShipAttributesByIds(
        uint[] memory _shipIds
    ) public view returns (Attributes[] memory) {
        Attributes[] memory results = new Attributes[](_shipIds.length);

        for (uint i = 0; i < _shipIds.length; i++) {
            Ship memory ship = ships.getShip(_shipIds[i]);
            if (ship.id == 0) revert ShipNotFound();
            results[i] = calculateShipAttributes(ship);
        }

        return results;
    }

    // Internal calculation functions

    function _calculateHullPoints(
        Ship memory _ship
    ) internal view returns (uint8) {
        VariantAttributeData storage variantData = attributesVersions[
            currentAttributesVersion
        ].variantData[_ship.traits.variant];
        uint8 baseHull = variantData.baseHull;
        // uint8 traitBonus = _ship.traits.hull * 10; // Convert trait to hull points
        uint8 traitBonus = variantData.hull[_ship.traits.hull];
        return baseHull + traitBonus;
    }

    function _calculateMovement(
        Ship memory _ship
    ) internal view returns (uint8) {
        VariantAttributeData storage variant = attributesVersions[
            currentAttributesVersion
        ].variantData[_ship.traits.variant];
        int8 baseMovement = int8(variant.baseSpeed);

        // Add trait bonus
        baseMovement += int8(variant.engineSpeeds[_ship.traits.speed]);

        // Extract equipment bonuses as int8 to avoid stack-too-deep or type mismatch
        int8 gunMovement = variant
            .guns[uint8(_ship.equipment.mainWeapon)]
            .movement;
        int8 armorMovement = variant
            .armors[uint8(_ship.equipment.armor)]
            .movement;
        int8 shieldMovement = variant
            .shields[uint8(_ship.equipment.shields)]
            .movement;
        int8 specialMovement = variant
            .specials[uint8(_ship.equipment.special)]
            .movement;

        baseMovement +=
            gunMovement +
            armorMovement +
            shieldMovement +
            specialMovement;

        return baseMovement > 0 ? uint8(baseMovement) : 0;
    }

    function _calculateDamageReduction(
        Ship memory _ship
    ) internal view returns (uint8) {
        VariantAttributeData storage variantData = attributesVersions[
            currentAttributesVersion
        ].variantData[_ship.traits.variant];

        uint8 damageReduction = 0;

        damageReduction += variantData
            .armors[uint8(_ship.equipment.armor)]
            .damageReduction;
        damageReduction += variantData
            .shields[uint8(_ship.equipment.shields)]
            .damageReduction;

        return damageReduction;
    }

    // Get special range from attributes version
    function getSpecialRange(
        Special _special,
        uint16 _variant
    ) public view returns (uint8) {
        return
            attributesVersions[currentAttributesVersion]
                .variantData[_variant]
                .specials[uint8(_special)]
                .range;
    }

    // Get special strength from attributes version
    function getSpecialStrength(
        Special _special,
        uint16 _variant
    ) public view returns (uint8) {
        return
            attributesVersions[currentAttributesVersion]
                .variantData[_variant]
                .specials[uint8(_special)]
                .strength;
    }

    // Get gun data for a variant from the current attributes version
    function getGunData(
        MainWeapon _weapon,
        uint16 _variant
    ) public view returns (GunData memory) {
        return
            attributesVersions[currentAttributesVersion]
                .variantData[_variant]
                .guns[uint8(_weapon)];
    }

    // Get armor data for a variant from the current attributes version
    function getArmorData(
        Armor _armor,
        uint16 _variant
    ) public view returns (ArmorData memory) {
        return
            attributesVersions[currentAttributesVersion]
                .variantData[_variant]
                .armors[uint8(_armor)];
    }

    // Get shield data for a variant from the current attributes version
    function getShieldData(
        Shields _shields,
        uint16 _variant
    ) public view returns (ShieldData memory) {
        return
            attributesVersions[currentAttributesVersion]
                .variantData[_variant]
                .shields[uint8(_shields)];
    }

    // Get special data from attributes version
    function getSpecialData(
        Special _special,
        uint16 _variant
    ) public view returns (SpecialData memory) {
        return
            attributesVersions[currentAttributesVersion]
                .variantData[_variant]
                .specials[uint8(_special)];
    }

    // Cost calculation functions
    function calculateShipCost(
        Ship memory ship
    ) external view returns (uint16) {
        Costs storage costs = costsByVariant[ship.traits.variant];
        if (costs.version == 0) revert InvalidCostsVersion();

        uint16 unadjustedCost = uint16(
            costs.baseCost +
                costs.accuracy[uint8(ship.traits.accuracy)] +
                costs.hull[uint8(ship.traits.hull)] +
                costs.speed[uint8(ship.traits.speed)] +
                costs.mainWeapon[uint8(ship.equipment.mainWeapon)] +
                costs.armor[uint8(ship.equipment.armor)] +
                costs.shields[uint8(ship.equipment.shields)] +
                costs.special[uint8(ship.equipment.special)]
        );

        // TODO: Add rank-based discounts here if needed
        // For now, return unadjusted cost
        return unadjustedCost;
    }

    function setCosts(
        uint16 _variant,
        Costs memory _costs
    ) external onlyOwner {
        // Compute the new version from current storage before it's overwritten below,
        // and ignore whatever `_costs.version` the caller passed in — otherwise a
        // stale/zero/duplicate caller-supplied version would silently corrupt the
        // costsVersion ships rely on to detect stale cost data (see H-01/M-01).
        uint16 newVersion = costsByVariant[_variant].version + 1;
        costsByVariant[_variant] = _costs;
        costsByVariant[_variant].version = newVersion;
        emit CostsSet(_variant, newVersion);
    }

    function getCosts(
        uint16 _variant
    ) external view returns (uint, Costs memory) {
        return (costsByVariant[_variant].version, costsByVariant[_variant]);
    }

    function getCurrentCostsVersion(
        uint16 _variant
    ) external view returns (uint16) {
        return costsByVariant[_variant].version;
    }

    // Attributes version management functions
    function setCurrentAttributesVersion(uint16 _version) external onlyOwner {
        currentAttributesVersion = _version;
        emit CurrentAttributesVersionSet(_version);
    }

    function getCurrentAttributesVersion() external view returns (uint16) {
        return currentAttributesVersion;
    }

    function getAttributesVersionBase(
        uint16 _version,
        uint16 _variant
    ) external view returns (uint16 version, uint8 baseHull, uint8 baseSpeed) {
        AttributesVersion storage versionData = attributesVersions[_version];
        VariantAttributeData storage variantData = versionData.variantData[
            _variant
        ];
        return (
            versionData.version,
            variantData.baseHull,
            variantData.baseSpeed
        );
    }

    /**
     * @dev Start a new attributes version and increment the version counter.
     * Every per-variant stat (baseHull/baseSpeed/guns/armors/shields/
     * foreAccuracy/hull/engineSpeeds/specials) lives on VariantAttributeData
     * now, so a new version starts completely empty — it must be configured
     * separately via setVariantAttributes for each variant before ships
     * using this version can be calculated.
     */
    function startNewAttributesVersion()
        external
        onlyOwner
        returns (uint16 newVersion)
    {
        currentAttributesVersion++;
        newVersion = currentAttributesVersion;
        attributesVersions[newVersion].version = newVersion;
        emit AttributesVersionCreated(newVersion);
    }

    /**
     * @dev Fully configure a variant (faction) under a given attributes
     * version: base hull/speed, per-tier bonuses, weapon/armor/shield
     * stats, and equipped-Special data. Must be called for a variant before
     * any ship with that traits.variant can have its attributes or cost
     * calculated under this version — lookups for an unconfigured variant
     * revert (fail loud) rather than silently falling back to a default.
     * @param params See SetVariantAttributesParams.
     */
    function setVariantAttributes(
        SetVariantAttributesParams memory params
    ) external onlyOwner {
        if (params.version == 0 || params.version > currentAttributesVersion) {
            revert InvalidAttributesVersion();
        }

        VariantAttributeData storage variantData = attributesVersions[
            params.version
        ].variantData[params.variant];

        variantData.baseHull = params.baseHull;
        variantData.baseSpeed = params.baseSpeed;

        delete variantData.foreAccuracy;
        for (uint i = 0; i < params.foreAccuracy.length; i++) {
            variantData.foreAccuracy.push(params.foreAccuracy[i]);
        }

        delete variantData.hull;
        for (uint i = 0; i < params.hull.length; i++) {
            variantData.hull.push(params.hull[i]);
        }

        delete variantData.engineSpeeds;
        for (uint i = 0; i < params.engineSpeeds.length; i++) {
            variantData.engineSpeeds.push(params.engineSpeeds[i]);
        }

        delete variantData.guns;
        for (uint i = 0; i < params.guns.length; i++) {
            variantData.guns.push(params.guns[i]);
        }

        delete variantData.armors;
        for (uint i = 0; i < params.armors.length; i++) {
            variantData.armors.push(params.armors[i]);
        }

        delete variantData.shields;
        for (uint i = 0; i < params.shields.length; i++) {
            variantData.shields.push(params.shields[i]);
        }

        delete variantData.specials;
        for (uint i = 0; i < params.specials.length; i++) {
            variantData.specials.push(params.specials[i]);
        }

        emit VariantAttributesSet(params.version, params.variant);
    }
}
