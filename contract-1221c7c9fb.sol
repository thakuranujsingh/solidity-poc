// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable@4.8.1/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.8.1/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable@4.8.1/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable@4.8.1/proxy/utils/UUPSUpgradeable.sol";

contract TogoToken is Initializable, ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC20_init("TogoToken", "TGK");
        __Ownable_init();
        __UUPSUpgradeable_init();

        _mint(msg.sender, 7000000000 * 10 ** decimals());
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}
}
