// ERC20 interfaces
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20Metadata.sol";

interface IERC20 is IERC20Metadata {
    function mint(address to, uint256 amount) public virtual
    function burn(uint256 amount) public virtual
    function burnFrom(address account, uint256 amount) public virtual
}
