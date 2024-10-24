// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NewLogicContract {
    string public constant constantValue = "constant"; // Константное значение, как и в старой логике
    uint256 public immutable immutableValue; // Иммутабельное значение, как и в старой логике
    
    uint256 public value; // Сохраняемое значение, как и в старой логике

    constructor(uint256 _immutableValue) {
        immutableValue = _immutableValue;
    }

    // Функция для установки значения
    function setValue(uint256 _value) public {
        value = _value;
    }

    // Функция для получения сохраненного значения
    function getValue() public view returns (uint256) {
        return value;
    }

    // Новая функция для удвоения значения
    function doubleValue() public {
        value = value * 2;
    }

    // Функция для получения константного значения
    function getConstant() public pure returns (string memory) {
        return constantValue;
    }

    // Функция для получения иммутабельного значения
    function getImmutable() public view returns (uint256) {
        return immutableValue;
    }
}
