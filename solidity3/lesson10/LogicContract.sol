// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicContract {
    string public constant constantValue = "constant"; // Константное значение
    uint256 public immutable immutableValue; // Иммутабельное значение

    constructor(uint256 _immutableValue) {
        immutableValue = _immutableValue; // Установка иммутабельного значения в конструкторе
    }

    function getConstant() public pure returns (string memory) {
        return constantValue; // Возвращает константное значение
    }

    function getImmutable() public view returns (uint256) {
        return immutableValue; // Возвращает иммутабельное значение
    }
}
