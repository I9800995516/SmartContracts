// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address public implementation;
    address public admin; // Администратор, который может обновлять логику

    constructor(address _implementation) {
        implementation = _implementation;
        admin = msg.sender; // Администратор прокси — это создатель контракта
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function upgradeTo(address newImplementation) external onlyAdmin {
        implementation = newImplementation; // Обновляем адрес контракта логики
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

    receive() external payable {} // Для получения средств, если потребуется
}
