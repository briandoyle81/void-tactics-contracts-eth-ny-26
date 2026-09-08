// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./Types.sol";
import "./IDroneNames.sol";

// Deterministic name generator for variant-2 ("drone") ships -- variant 1
// uses IOnchainRandomShipNames (real-world-style ship names); variant 2
// gets its own distinct flavor here instead: "[MODEL]-[SERIAL] [CODEWORD]",
// e.g. "KR-17 Cinder" or "M4-882 Vector". The model/serial half reads like
// an industrial part number; the codeword half is what a player actually
// remembers and refers to it by. Codeword pools are themed to the ship's
// equipped main weapon (a mining-tool loadout draws from a different pool
// than a combat-drone loadout), so players start recognizing a drone's role
// from its name alone.
//
// Every part is pure and derived entirely from the caller-supplied seed --
// no storage, no owner-configurable word lists, nothing that could change
// after the fact for an already-generated name.
contract DroneNames is IDroneNames {
    // No vowels -- deliberately reads like a machine-stamped part code
    // rather than a pronounceable syllable (that job belongs to the
    // codeword half). 20 consonants.
    bytes constant CONSONANTS = "BCDFGHJKLMNPQRSTVWXZ";

    function getRandomDroneName(
        bytes32 _seed,
        MainWeapon _weapon
    ) external pure override returns (string memory) {
        bytes32 templateHash = keccak256(abi.encodePacked(_seed, "template"));
        uint templateIdx = uint8(templateHash[0]) % 6;

        bytes32 charsHash = keccak256(abi.encodePacked(_seed, "chars"));
        (string memory model, string memory serial) = _buildModelSerial(
            templateIdx,
            charsHash
        );

        string memory codeword = _pickCodeword(_seed, _weapon);

        return string.concat(model, "-", serial, " ", codeword);
    }

    // Six irregular model/serial shapes (mixed letter/digit counts on
    // both sides of the dash) so the population reads like it comes from
    // several different manufacturers rather than one fixed template --
    // e.g. "KR-17", "M4-882", "7X-41", "DR-044", "N-720", "VX3-09".
    function _buildModelSerial(
        uint _templateIdx,
        bytes32 _h
    ) internal pure returns (string memory model, string memory serial) {
        if (_templateIdx == 0) {
            model = string(abi.encodePacked(_letter(_h, 0), _letter(_h, 1)));
            serial = _digits(_h, 2, 2);
        } else if (_templateIdx == 1) {
            model = string(abi.encodePacked(_letter(_h, 0), _digit(_h, 1)));
            serial = _digits(_h, 2, 3);
        } else if (_templateIdx == 2) {
            model = string(abi.encodePacked(_digit(_h, 0), _letter(_h, 1)));
            serial = _digits(_h, 2, 2);
        } else if (_templateIdx == 3) {
            model = string(abi.encodePacked(_letter(_h, 0), _letter(_h, 1)));
            serial = _digits(_h, 2, 3);
        } else if (_templateIdx == 4) {
            model = string(abi.encodePacked(_letter(_h, 0)));
            serial = _digits(_h, 1, 3);
        } else {
            model = string(
                abi.encodePacked(_letter(_h, 0), _letter(_h, 1), _digit(_h, 2))
            );
            serial = _digits(_h, 3, 2);
        }
    }

    function _letter(bytes32 _h, uint _idx) internal pure returns (bytes1) {
        return CONSONANTS[uint8(_h[_idx]) % CONSONANTS.length];
    }

    function _digit(bytes32 _h, uint _idx) internal pure returns (bytes1) {
        return bytes1(uint8(48 + (uint8(_h[_idx]) % 10)));
    }

    function _digits(
        bytes32 _h,
        uint _startIdx,
        uint _count
    ) internal pure returns (string memory) {
        bytes memory out = new bytes(_count);
        for (uint i = 0; i < _count; i++) {
            out[i] = _digit(_h, _startIdx + i);
        }
        return string(out);
    }

    function _pickCodeword(
        bytes32 _seed,
        MainWeapon _weapon
    ) internal pure returns (string memory) {
        bytes32 h = keccak256(abi.encodePacked(_seed, "codeword"));
        string[10] memory pool = _poolFor(_weapon);
        return pool[uint(h) % 10];
    }

    // Variant 2's real weapon lineup (see RenderMetadata.getMainWeaponString):
    // Generic="Medium Mining Laser", Sniper="Linear Accelerator",
    // Missile="Torpedo Launcher", Close="Mining Drill".
    // Generic and Close are both mining tools, so they share a pool;
    // Sniper (an accelerator) draws from a space/physics pool; Missile
    // (a combat weapon) draws from a predator/animal pool. Any MainWeapon
    // value not explicitly themed (including the `future1`-`future4`
    // reserved enum members) falls back to the mining pool rather than
    // needing its own.
    function _poolFor(
        MainWeapon _weapon
    ) internal pure returns (string[10] memory) {
        if (_weapon == MainWeapon.Sniper) {
            return [
                "Comet",
                "Nova",
                "Pulsar",
                "Helix",
                "Vector",
                "Zenith",
                "Corona",
                "Umbra",
                "Nadir",
                "Orbit"
            ];
        } else if (_weapon == MainWeapon.Missile) {
            return [
                "Wasp",
                "Viper",
                "Shrike",
                "Rook",
                "Hornet",
                "Jackal",
                "Mantis",
                "Kestrel",
                "Raven",
                "Moth"
            ];
        } else {
            return [
                "Flint",
                "Auger",
                "Slate",
                "Cinder",
                "Rime",
                "Grit",
                "Onyx",
                "Ash",
                "Basalt",
                "Shale"
            ];
        }
    }
}
