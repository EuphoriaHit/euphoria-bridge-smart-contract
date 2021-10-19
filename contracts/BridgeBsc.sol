// BSC bridge
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./interfaces/IERC20.sol";

contract BridgeBsc is OwnableUpgradeable {
    using AddressUpgradeable for address;

    IERC20 public _token;
    mapping(address => uint256) public _mintedAmount;
    mapping(uint256 => bool) public _convertProcess;

    bytes32 private BURN;
    bytes32 private MINT;
    bytes32 private VALIDATOR;

    bool _isPaused;

    event ConvertTransfer(
        address from,
        uint256 amount,
        uint256 date,
        bytes32 type_sign,
        bytes32 validator_sign
    );

    function initialize(address tokenAddress, string memory validator)
        public
        initializer
    {
        OwnableUpgradeable.__Ownable_init();
        _token = IERC20(tokenAddress);
        BURN = keccak256("BURN");
        MINT = keccak256("MINT");
        VALIDATOR = bytes32(abi.encode(validator));
        _isPaused = false;
    }

    function burnToken(uint256 amount) external {
        require(_isPaused == false, "BridgeEth: bridge is paused");
        require(
            _mintedAmount[owner()] >= amount,
            "BSC bridge: convert amount exceeds balance"
        );
        _burn(owner(), amount);
        _mintedAmount[owner()] -= amount;
        emit ConvertTransfer(
            msg.sender,
            amount,
            block.timestamp,
            BURN,
            VALIDATOR
        );
    }

    function mintToken(
        address to,
        uint256 amount,
        uint256 nonce,
        string memory validator
    ) external onlyOwner {
        require(_isPaused == false, "BridgeBsc: bridge is paused");
        require(
            VALIDATOR == keccak256(abi.encodePacked(validator)),
            "BridgeBsc: Unkown validator off-chain"
        );
        require(
            _convertProcess[nonce] == false,
            "BridgeBsc: transfer already processed"
        );
        _convertProcess[nonce] = true;
        _mint(to, amount);
        _mintedAmount[to] += amount;
        emit ConvertTransfer(to, amount, block.timestamp, MINT, VALIDATOR);
    }

    function changeToken(address tokenAddress) external onlyOwner {
        require(
            address(_token) != tokenAddress,
            "BridgeBsc: same token can not be changed"
        );
        _token = IERC20(tokenAddress);
    }

    function changeValidator(string memory validator) external onlyOwner {
        require(
            VALIDATOR != bytes32(abi.encode(validator)),
            "BridgeBsc: same validator can not be changed"
        );
        VALIDATOR = bytes32(abi.encode(validator));
    }

    function setPause(bool pause) external onlyOwner {
        _isPaused = pause;
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
