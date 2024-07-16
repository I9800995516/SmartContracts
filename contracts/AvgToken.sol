// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AvgToken is ERC20 {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor(uint256 initialSupply) ERC20("AvgToken", "AVG") {
        owner = msg.sender;
        _mint(owner, initialSupply);
    }
    