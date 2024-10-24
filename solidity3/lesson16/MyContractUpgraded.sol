// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    uint256[] arr;
    bytes15[] bytesArr;
    uint88[] uint88Arr;

    // Function to push a new uint256 element into the array
    function pushArrayElem(uint256 newElem) external {
        assembly {
            // Get the current length of the array
            let length := sload(arr.slot)

            // Calculate the slot for the new element
            let slot := add(arr.slot, length)

            // Store the new value in the calculated slot
            sstore(slot, newElem)

            // Update the length of the array
            sstore(arr.slot, add(length, 1))
        }
    }

    // Function to get an element from the uint256 array
    function getElem(uint256 index) external view returns (uint256) {
        uint256 value;
        assembly {
            // Get the length of the array
            let length := sload(arr.slot)

            // Check if the index is within bounds
            if iszero(lt(index, length)) {
                revert(0, 0)
            }

            // Calculate the slot for the element
            let slot := add(arr.slot, index)

            // Load the value from the slot
            value := sload(slot)
        }
        return value;
    }

    // Function to push a new bytes15 element into the bytes array
    function pushBytesElem(bytes15 newElem) external {
        assembly {
            let length := sload(bytesArr.slot)
            let slot := add(bytesArr.slot, length)
            sstore(slot, newElem)
            sstore(bytesArr.slot, add(length, 1))
        }
    }

    // Function to get an element from the bytes15 array
    function getBytesElem(uint256 index) external view returns (bytes15) {
        bytes15 value;
        assembly {
            let length := sload(bytesArr.slot)
            if iszero(lt(index, length)) {
                revert(0, 0)
            }
            let slot := add(bytesArr.slot, index)
            value := sload(slot)
        }
        return value;
    }

    // Function to push a new uint88 element into the uint88 array
    function pushUint88Elem(uint88 newElem) external {
        assembly {
            let length := sload(uint88Arr.slot)
            let slot := add(uint88Arr.slot, length)
            sstore(slot, newElem)
            sstore(uint88Arr.slot, add(length, 1))
        }
    }

    // Function to get an element from the uint88 array
    function getUint88Elem(uint256 index) external view returns (uint88) {
        uint88 value;
        assembly {
            let length := sload(uint88Arr.slot)
            if iszero(lt(index, length)) {
                revert(0, 0)
            }
            let slot := add(uint88Arr.slot, index)
            value := sload(slot)
        }
        return value;
    }
}


// - Массивы: Контракт содержит три массива: arr для uint256, bytesArr для bytes15 и uint88Arr для uint88.
// - Добавление элементов: Каждая функция push использует ассемблер для вычисления слота, в который будет добавлен новый элемент, и обновляет длину массива.
// - Получение элементов: Функции get проверяют, что индекс находится в пределах длины массива, и возвращают соответствующее значение.

// Этот код демонстрирует, как можно эффективно управлять массивами различных типов данных в Solidity с использованием Yul и ассемблера.