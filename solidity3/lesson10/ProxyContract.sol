// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address public implementation; // Адрес контракта реализации

    constructor(address _implementation) {
        implementation = _implementation; // Установка адреса контракта реализации
    }

    function _delegate(address _implementation) internal {
        assembly {
            calldatacopy(0, 0, calldatasize()) // Копирование данных вызова
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0) // Делегирование вызова
            returndatacopy(0, 0, returndatasize()) // Копирование данных ответа
            switch result
            case 0 { revert(0, returndatasize()) } // Обработка ошибки
            default { return(0, returndatasize()) } // Возврат результата
        }
    }

    fallback() external {
        _delegate(implementation); // Делегирование вызова в случае отсутствия функции
    }
}
