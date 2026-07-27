// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

// Stub. Intended as DroneEnergyCores' transferExemptAddress — the one
// address DEC (soulbound otherwise) can be sent to — so players have
// somewhere to spend it once this contract does something. No
// redemption/spend logic yet; just holds a reference to the DEC token and
// accepts transfers (a plain ERC20 transfer/transferFrom needs no receiver
// hook, so this contract already "accepts" DEC as-is).
contract DroneStorefront is Ownable {
    address public droneEnergyCores;

    constructor(address _droneEnergyCores) Ownable(msg.sender) {
        droneEnergyCores = _droneEnergyCores;
    }

    function setDroneEnergyCoresAddress(
        address _droneEnergyCores
    ) external onlyOwner {
        droneEnergyCores = _droneEnergyCores;
    }
}
