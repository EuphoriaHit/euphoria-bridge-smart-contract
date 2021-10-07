// Token Pool
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./interfaces/IERC20.sol";

contract BridgeEth is OwnableUpgradeable {
    using AddressUpgradeable for address;

    IERC20 public _token;
    mapping(address => uint256) public _convertProcess;

    string private LOCK = "LOCK";
    string private UNLOCK = "UNLOCK";

    event ConvertTransfer(
        address from,
        uint256 amount,
        uint256 date,
        string sign
    );

    function initialize(address tokenAddress) public initializer {
        OwnableUpgradeable.__Ownable_init();
        _token = IERC20(tokenAddress);
    }

    function lockToken(uint256 amount) external {
        _lock(owner(), address(this), amount);
        _convertProcess[owner()] += amount;
        emit ConvertTransfer(owner(), amount, block.timestamp, LOCK);
    }

    function unlockToken(address to, uint256 amount) external onlyOwner {
        _unlockToken(to, amount);
        emit ConvertTransfer(owner(), amount, block.timestamp, UNLOCK);
    }

    function _lock(
        address from,
        address to,
        uint256 amount
    ) private {
        _token.transferFrom(from, to, amount);
    }

    function _unlockToken(address to, uint256 amount) private {
        _token.transfer(to, amount);
    }
}
