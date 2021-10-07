// BSC bridge
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./interfaces/IERC20.sol";

contract BridgeBsc is OwnableUpgradeable {
    using AddressUpgradeable for address;

    IERC20 public _token;
    mapping(address => uint256) public _convertProcess;

    string private BURN = "BURN";
    string private MINT = "MINT";

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

    function burnToken(uint256 amount) external {
        require(
            _convertProcess[owner()] >= amount,
            "BSC bridge: convert amount exceeds balance"
        );
        _burn(owner(), amount);
        _convertProcess[owner()] -= amount;
        emit ConvertTransfer(msg.sender, amount, block.timestamp, BURN);
    }

    function mintToken(uint256 amount) external onlyOwner {
        _mint(owner(), amount);
        _convertProcess[msg.sender] += amount;
        emit ConvertTransfer(msg.sender, amount, block.timestamp, MINT);
    }

    function _withdrawToken(address to, uint256 amount) external onlyOwner {
        _token.transfer(to, amount);
    }

    function _burn(address to, uint256 amount) private {
        _token.burnFrom(to, amount);
    }

    function _mint(address to, uint256 amount) private {
        _token.mint(to, amount);
    }
}
