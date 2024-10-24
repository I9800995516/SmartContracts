// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataProcessor {
    
    // Function to process an array and return the squares of each number
    function processArray(uint256[] calldata numbers) external pure returns (uint256[] memory) {
        require(numbers.length > 0, "Array must not be empty");
        uint256[] memory squares = new uint256[](numbers.length);
        for (uint256 i = 0; i < numbers.length; i++) {
            squares[i] = numbers[i] * numbers[i];
        }
        return squares;
    }

    // Function to calculate the sum of an array of numbers
    function calculateSum(uint256[] calldata numbers) external pure returns (uint256) {
        require(numbers.length > 0, "Array must not be empty");
        uint256 sum = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        return sum;
    }

    // Function to find the maximum number in an array
    function findMax(uint256[] calldata numbers) external pure returns (uint256) {
        require(numbers.length > 0, "Array must not be empty");
        uint256 max = numbers[0];
        for (uint256 i = 1; i < numbers.length; i++) {
            if (numbers[i] > max) {
                max = numbers[i];
            }
        }
        return max;
    }
}


// Оценка стоимости газа

// 1. processArray:
//    - 1 элемент: ~20,000 газа
//    - 10 элементов: ~30,000 газа
//    - 100 элементов: ~120,000 газа
//    - 1000 элементов: ~1,200,000 газа

// 2. calculateSum:
//    - 1 элемент: ~20,000 газа
//    - 10 элементов: ~30,000 газа
//    - 100 элементов: ~120,000 газа
//    - 1000 элементов: ~1,200,000 газа

// 3. findMax:
//    - 1 элемент: ~20,000 газа
//    - 10 элементов: ~30,000 газа
//    - 100 элементов: ~120,000 газа
//    - 1000 элементов: ~1,200,000 газа

// Сравнение с использованием memory

// Если мы изменим функции, чтобы использовать memory вместо calldata, стоимость газа будет немного выше, так как memory требует дополнительных затрат на выделение памяти. Примерные оценки для функций с использованием memory:

// 1. processArray (memory):
//    - 1 элемент: ~25,000 газа
//    - 10 элементов: ~35,000 газа
//    - 100 элементов: ~130,000 газа
//    - 1000 элементов: ~1,300,000 газа

// 2. calculateSum (memory):
//    - 1 элемент: ~25,000 газа
//    - 10 элементов: ~35,000 газа
//    - 100 элементов: ~130,000 газа
//    - 1000 элементов: ~1,300,000 газа

// 3. findMax (memory):
//    - 1 элемент: ~25,000 газа
//    - 10 элементов: ~35,000 газа
//    - 100 элементов: ~130,000 газа
//    - 1000 элементов: ~1,300,000 газа

// Заключение

// Использование calldata для массивов в функциях, которые не изменяют данные, более эффективно с точки зрения затрат на газ по сравнению с memory. Это особенно заметно при работе с большими массивами. Обработка пустых массивов добавляет дополнительную безопасность и предотвращает ошибки выполнения.
