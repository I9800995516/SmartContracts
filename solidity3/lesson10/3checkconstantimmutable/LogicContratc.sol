// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicContract {
    string public constant constantValue = "constant";
    uint256 public immutable immutableValue;
    
    constructor(uint256 _immutableValue) {
        immutableValue = _immutableValue;
    }

    function getConstant() public pure returns (string memory) {
        return constantValue;
    }

    function getImmutable() public view returns (uint256) {
        return immutableValue;
    }
}
