// Token Pool
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract BSCToken is ERC20Upgradeable {
    function initialize() public initializer {
        __ERC20_init("Euporia Hit", "UPH");
    }
}
