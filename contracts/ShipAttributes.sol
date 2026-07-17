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

    // Cost system
    Costs public costs;

    error InvalidAttributesVersion();
    error ShipNotFound();
    error InvalidCostsVersion();

    event CostsSet(uint16 version);
    event CurrentAttributesVersionSet(uint16 version);
    event AttributesVersionCreated(uint16 version);
    event VariantAttributesSet(uint16 version, uint16 variant);

    constructor(address _ships) Ownable(msg.sender) {
        ships = IShips(_ships);

        // Initialize attributes version 1
        currentAttributesVersion = 1;

        // Initialize cost system
        costs.version = 1;
        costs.baseCost = 50;

        costs.accuracy = [0, 10, 25];
        costs.hull = [0, 10, 25];
        costs.speed = [0, 10, 25];

        costs.mainWeapon = [25, 30, 40, 40];
        costs.armor = [0, 5, 10, 15];
        costs.shields = [0, 10, 20, 30];
        costs.special = [0, 10, 20, 15];
        // Index 0 is unused (traits.variant is never 0); indices 1-3 are
        // baseline variants 1-3 (variant 1 is the only one ordinary purchases
        // can reach via Ships.maxVariant; TutorialClaim mints fixed ships
        // using variants 1-3 directly for visual variety).
        costs.variant = [0, 0, 0, 0];

        // Set up default attributes version 1
        AttributesVersion storage v1 = attributesVersions[1];
        v1.version = 1;
        v1.baseHull = 100;
        v1.baseSpeed = 3;

        // Seed identical baseline hull-piece bonuses and special data for
        // variants 1-3 — no per-variant differentiation yet (future
        // setVariantAttributes calls can diverge these once variant balance
        // is designed).
        for (uint16 i = 1; i <= 3; i++) {
            VariantAttributeData storage variantData = v1.variantData[i];

            // Fore accuracy bonuses in whole number percentage additions
            variantData.foreAccuracy.push(0);
            variantData.foreAccuracy.push(25);
            variantData.foreAccuracy.push(50);

            // Hull bonuses in hull points
            variantData.hull.push(0);
            variantData.hull.push(10);
            variantData.hull.push(20);

            // Engine speed in raw movement modifier
            variantData.engineSpeeds.push(0);
            variantData.engineSpeeds.push(1);
            variantData.engineSpeeds.push(2);

            // Initialize special data
            variantData.specials.push(SpecialData(0, 0, 0)); // None
            variantData.specials.push(SpecialData(1, 1, 0)); // EMP
            variantData.specials.push(SpecialData(3, 40, 0)); // RepairDrones
            variantData.specials.push(SpecialData(3, 30, 0)); // FlakArray
        }

        // Initialize gun data
        // Remember, bridge + level extend range
        v1.guns.push(GunData(3, 50, 0)); // Laser
        v1.guns.push(GunData(6, 40, 0)); // Railgun
        v1.guns.push(GunData(4, 60, -1)); // MissileLauncher
        v1.guns.push(GunData(2, 80, 0)); // PlasmaCannon

        // Initialize armor data
        v1.armors.push(ArmorData(0, 1)); // None
        v1.armors.push(ArmorData(15, 0)); // Light
        v1.armors.push(ArmorData(30, -1)); // Medium
        v1.armors.push(ArmorData(45, -2)); // Heavy

        // Initialize shield data
        v1.shields.push(ShieldData(0, 1)); // None
        v1.shields.push(ShieldData(15, 1)); // Light
        v1.shields.push(ShieldData(30, 0)); // Medium
        v1.shields.push(ShieldData(45, -1)); // Heavy
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

        Attributes memory attributes;
        // Calculate base attributes from ship traits and equipment
        attributes.version = currentAttributesVersion;
        attributes.range = attributesVersions[currentAttributesVersion]
            .guns[uint8(_ship.equipment.mainWeapon)]
            .range;
        // Increase range by the rank multiplier as a percentage (avoid overflow)
        uint calculatedBonus = (uint(attributes.range) * rankMultiplier) / 100;
        attributes.range += uint8(calculatedBonus);

        // Apply fore accuracy bonus to range as percentage increase (bridge + level extend range)
        uint8 foreAccuracyBonus = attributesVersions[currentAttributesVersion]
            .variantData[_ship.traits.variant]
            .foreAccuracy[uint8(_ship.traits.accuracy)];
        calculatedBonus = (uint(attributes.range) * foreAccuracyBonus) / 100;
        attributes.range += uint8(calculatedBonus);
        attributes.gunDamage = attributesVersions[currentAttributesVersion]
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
        AttributesVersion storage version = attributesVersions[
            currentAttributesVersion
        ];
        uint8 baseHull = version.baseHull;
        // uint8 traitBonus = _ship.traits.hull * 10; // Convert trait to hull points
        uint8 traitBonus = version.variantData[_ship.traits.variant].hull[
            _ship.traits.hull
        ];
        return baseHull + traitBonus;
    }

    function _calculateMovement(
        Ship memory _ship
    ) internal view returns (uint8) {
        AttributesVersion storage version = attributesVersions[
            currentAttributesVersion
        ];
        int8 baseMovement = int8(version.baseSpeed);

        VariantAttributeData storage variant = version.variantData[
            _ship.traits.variant
        ];

        // Add trait bonus
        baseMovement += int8(variant.engineSpeeds[_ship.traits.speed]);

        // Extract equipment bonuses as int8 to avoid stack-too-deep or type mismatch
        int8 gunMovement = version
            .guns[uint8(_ship.equipment.mainWeapon)]
            .movement;
        int8 armorMovement = version
            .armors[uint8(_ship.equipment.armor)]
            .movement;
        int8 shieldMovement = version
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
        AttributesVersion storage version = attributesVersions[
            currentAttributesVersion
        ];

        uint8 damageReduction = 0;

        damageReduction += version
            .armors[uint8(_ship.equipment.armor)]
            .damageReduction;
        damageReduction += version
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

    // Get gun data from attributes version
    function getGunData(
        MainWeapon _weapon
    ) public view returns (GunData memory) {
        return
            attributesVersions[currentAttributesVersion].guns[uint8(_weapon)];
    }

    // Get armor data from attributes version
    function getArmorData(Armor _armor) public view returns (ArmorData memory) {
        return
            attributesVersions[currentAttributesVersion].armors[uint8(_armor)];
    }

    // Get shield data from attributes version
    function getShieldData(
        Shields _shields
    ) public view returns (ShieldData memory) {
        return
            attributesVersions[currentAttributesVersion].shields[
                uint8(_shields)
            ];
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
        uint16 unadjustedCost = uint16(
            costs.baseCost +
                costs.accuracy[uint8(ship.traits.accuracy)] +
                costs.hull[uint8(ship.traits.hull)] +
                costs.speed[uint8(ship.traits.speed)] +
                costs.mainWeapon[uint8(ship.equipment.mainWeapon)] +
                costs.armor[uint8(ship.equipment.armor)] +
                costs.shields[uint8(ship.equipment.shields)] +
                costs.special[uint8(ship.equipment.special)] +
                costs.variant[ship.traits.variant]
        );

        // TODO: Add rank-based discounts here if needed
        // For now, return unadjusted cost
        return unadjustedCost;
    }

    function setCosts(Costs memory _costs) external onlyOwner {
        // Compute the new version from current storage before it's overwritten below,
        // and ignore whatever `_costs.version` the caller passed in — otherwise a
        // stale/zero/duplicate caller-supplied version would silently corrupt the
        // costsVersion ships rely on to detect stale cost data (see H-01/M-01).
        uint16 newVersion = costs.version + 1;
        costs = _costs;
        costs.version = newVersion;
        emit CostsSet(newVersion);
    }

    function getCosts() external view returns (uint, Costs memory) {
        return (costs.version, costs);
    }

    function getCurrentCostsVersion() external view returns (uint16) {
        return costs.version;
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
        uint16 _version
    ) external view returns (uint16 version, uint8 baseHull, uint8 baseSpeed) {
        AttributesVersion storage versionData = attributesVersions[_version];
        return (
            versionData.version,
            versionData.baseHull,
            versionData.baseSpeed
        );
    }

    /**
     * @dev Set all attributes for a new version at once and increment the version.
     * Per-variant hull-piece bonuses and specials are NOT carried forward from the
     * previous version and must be configured separately via setVariantAttributes
     * for each variant before ships using this version can be calculated.
     * @param _baseHull Base hull points
     * @param _baseSpeed Base speed
     * @param _guns Array of gun data
     * @param _armors Array of armor data
     * @param _shields Array of shield data
     */
    function setAllAttributes(
        uint8 _baseHull,
        uint8 _baseSpeed,
        GunData[] memory _guns,
        ArmorData[] memory _armors,
        ShieldData[] memory _shields
    ) external onlyOwner {
        // Increment version
        currentAttributesVersion++;
        uint16 newVersion = currentAttributesVersion;

        // Set base attributes
        AttributesVersion storage newVersionData = attributesVersions[
            newVersion
        ];
        newVersionData.version = newVersion;
        newVersionData.baseHull = _baseHull;
        newVersionData.baseSpeed = _baseSpeed;

        // Clear existing arrays and set new data
        delete newVersionData.guns;
        for (uint i = 0; i < _guns.length; i++) {
            newVersionData.guns.push(_guns[i]);
        }

        delete newVersionData.armors;
        for (uint i = 0; i < _armors.length; i++) {
            newVersionData.armors.push(_armors[i]);
        }

        delete newVersionData.shields;
        for (uint i = 0; i < _shields.length; i++) {
            newVersionData.shields.push(_shields[i]);
        }

        emit AttributesVersionCreated(newVersion);
    }

    /**
     * @dev Set per-variant hull-piece bonuses and special data for a given
     * attributes version. Must be called for a variant before any ship with
     * that traits.variant can have its attributes calculated under this
     * version — lookups for an unconfigured variant revert (fail loud) rather
     * than silently falling back to a default.
     * @param _version Attributes version to configure (must already exist)
     * @param _variant Ship variant (traits.variant) to configure
     * @param _foreAccuracy Array of fore accuracy bonuses (bridge)
     * @param _hull Array of hull bonuses
     * @param _engineSpeeds Array of engine speed bonuses
     * @param _specials Array of special equipment data
     */
    function setVariantAttributes(
        uint16 _version,
        uint16 _variant,
        uint8[] memory _foreAccuracy,
        uint8[] memory _hull,
        uint8[] memory _engineSpeeds,
        SpecialData[] memory _specials
    ) external onlyOwner {
        if (_version == 0 || _version > currentAttributesVersion) {
            revert InvalidAttributesVersion();
        }

        VariantAttributeData storage variantData = attributesVersions[
            _version
        ].variantData[_variant];

        delete variantData.foreAccuracy;
        for (uint i = 0; i < _foreAccuracy.length; i++) {
            variantData.foreAccuracy.push(_foreAccuracy[i]);
        }

        delete variantData.hull;
        for (uint i = 0; i < _hull.length; i++) {
            variantData.hull.push(_hull[i]);
        }

        delete variantData.engineSpeeds;
        for (uint i = 0; i < _engineSpeeds.length; i++) {
            variantData.engineSpeeds.push(_engineSpeeds[i]);
        }

        delete variantData.specials;
        for (uint i = 0; i < _specials.length; i++) {
            variantData.specials.push(_specials[i]);
        }

        emit VariantAttributesSet(_version, _variant);
    }
}
