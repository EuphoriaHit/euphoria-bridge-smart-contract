// Token Pool
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

contract BridgeEth is OwnableUpgradeable {
    using AddressUpgradeable for address;

    IERC20Upgradeable public _token;
    mapping(address => uint256) public _convertProcess;

    enum Step {
        Lock,
        Unlock
    }
    event ConvertTransfer(
        address from,
        uint256 amount,
        uint256 date,
        Step indexed step
    );

    function initialize(address tokenAddress) public initializer {
        OwnableUpgradeable.__Ownable_init();
        _token = IERC20Upgradeable(tokenAddress);
    }

    function lockToken(uint256 amount) external {
        _token.transferFrom(owner(), address(this), amount);
        _convertProcess[msg.sender] += amount;
        emit ConvertTransfer(msg.sender, amount, block.timestamp, Step.Lock);
    }

    function unlockToken(uint256 amount) external onlyOwner {}

    function _withdrawToken(address to, uint256 amount) private {
        _token.transfer(to, amount);
    }
}
