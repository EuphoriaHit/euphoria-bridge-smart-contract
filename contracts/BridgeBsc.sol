// Token Pool
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./interfaces/IERC20.sol";

contract BridgeBsc is OwnableUpgradeable {
    using AddressUpgradeable for address;

    IERC20 public _token;
    mapping(address => uint256) public _convertProcess;

    enum Step {
        Burn,
        Mint
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

    function burnToken(uint256 amount) external {
        _burn(owner(), amount);
        _convertProcess[msg.sender] += amount;
        emit ConvertTransfer(msg.sender, amount, block.timestamp, Step.Burn);
    }

    function mintToken(uint256 amount) external onlyOwner {
        _mint(owner(), amount);
        _convertProcess[msg.sender] += amount;
        emit ConvertTransfer(msg.sender, amount, block.timestamp, Step.Burn);
    }

    function _withdrawToken(address to, uint256 amount) private {
        _token.transfer(to, amount);
    }

    function _burn(address to, uint256 amount) private view returns (bool) {
        _token.burnFrom(to, amount);
        return true;
    }

    function _mint(address to, uint256 amount) private view returns (bool) {
        _token.mint(to, amount);
        return true;
    }
}
