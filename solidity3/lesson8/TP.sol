// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TokenLogic is Initializable, Ownable, ReentrancyGuard {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    function initialize(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public initializer {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = totalSupply; // Начисляем токены владельцу
    }

    function transfer(address to, uint256 amount) public nonReentrant returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

contract TokenProxy is TransparentUpgradeableProxy {
    constructor(address logic, address admin, bytes memory data) 
        TransparentUpgradeableProxy(logic, admin, data) {}
}
