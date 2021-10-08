// Token Pool
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./interfaces/IERC20.sol";

contract BridgeEth is OwnableUpgradeable {
    using AddressUpgradeable for address;

    IERC20 public _token;

    mapping(address => uint256) public _lockAmounts;
    mapping(uint256 => bool) public _convertProcess;

    bytes32 private LOCK;
    bytes32 private UNLOCK;
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
        LOCK = keccak256("LOCK");
        UNLOCK = keccak256("UNLOCK");
        VALIDATOR = bytes32(abi.encode(validator));
        _isPaused = false;
    }

    function lockToken(uint256 amount) external {
        require(_isPaused == false, "BridgeEth: bridge is paused");
        _lock(_msgSender(), address(this), amount);
        _lockAmounts[_msgSender()] += amount;
        emit ConvertTransfer(
            _msgSender(),
            amount,
            block.timestamp,
            LOCK,
            VALIDATOR
        );
    }

    function unlockToken(
        address to,
        uint256 amount,
        uint256 nonce
    ) external onlyOwner {
        require(
            _lockAmounts[to] >= amount,
            "BridgeEth: convert amount exceeds balance"
        );
        require(
            _convertProcess[nonce] == false,
            "BridgeEth: transfer already processed"
        );
        _convertProcess[nonce] = true;
        _lockAmounts[to] -= amount;
        _unlockToken(to, amount);
        emit ConvertTransfer(to, amount, block.timestamp, UNLOCK, VALIDATOR);
    }

    function changeToken(address tokenAddress) external onlyOwner {
        require(
            address(_token) != tokenAddress,
            "BridgeEth: same token can not be changed"
        );
        _token = IERC20(tokenAddress);
    }

    function changeValidator(string memory validator) external onlyOwner {
        require(
            VALIDATOR != bytes32(abi.encode(validator)),
            "BridgeEth: same validator can not be changed"
        );
        VALIDATOR = bytes32(abi.encode(validator));
    }

    function setPause(bool pause) external onlyOwner {
        _isPaused = pause;
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
