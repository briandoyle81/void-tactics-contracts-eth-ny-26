// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Reward token minted to a player's own wallet for destroying an AI-owned
// ship in a single-player match (Ships.setTimestampDestroyed) — separate
// from UniversalCredits so this specific reward can be soulbound rather
// than freely tradeable. Non-transferable except to/from a single
// admin-designated address (e.g. a future redemption contract); minting
// and burning (from/to address(0)) are always allowed regardless.
contract DroneEnergyCores is ERC20, Ownable {
    error NotAuthorized(address);
    error MintNotActive();
    error Soulbound();

    bool public mintIsActive;

    mapping(address => bool) public authorizedToMint;

    // The only address DEC may be transferred to or from, besides mint/burn.
    address public transferExemptAddress;

    constructor() ERC20("Drone Energy Cores", "DEC") Ownable(msg.sender) {}

    /*
     * @dev Public Functions
     */

    function mint(address _to, uint _amount) public mintingIsActive {
        if (!authorizedToMint[msg.sender]) {
            revert NotAuthorized(msg.sender);
        }

        _mint(_to, _amount);
    }

    /*
     * @dev Owner Functions
     */

    function setMintIsActive(bool _mintIsActive) public onlyOwner {
        mintIsActive = _mintIsActive;
    }

    function setAuthorizedToMint(
        address _address,
        bool _authorized
    ) public onlyOwner {
        authorizedToMint[_address] = _authorized;
    }

    function setTransferExemptAddress(address _address) public onlyOwner {
        transferExemptAddress = _address;
    }

    /*
     * @dev Soulbound transfer restriction
     */

    // Blocks any transfer that doesn't touch transferExemptAddress on one
    // side. Mint/burn (from or to address(0)) are never blocked here — this
    // only gates wallet-to-wallet transfers.
    function _update(
        address _from,
        address _to,
        uint256 _value
    ) internal override {
        if (
            _from != address(0) &&
            _to != address(0) &&
            _from != transferExemptAddress &&
            _to != transferExemptAddress
        ) {
            revert Soulbound();
        }
        super._update(_from, _to, _value);
    }

    /*
     * @dev Modifiers
     */

    modifier mintingIsActive() {
        if (!mintIsActive) {
            revert MintNotActive();
        }
        _;
    }
}
