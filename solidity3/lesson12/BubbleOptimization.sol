// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Stack {
    uint256[] private _a;

    // Функция для сортировки массива пузырьком
    function bubbleSort() external {
        uint256 n = _a.length;  // Кэшируем длину массива, чтобы не обращаться к хранилищу каждый раз

        // Если массив пустой или имеет один элемент, нет необходимости сортировать
        if (n <= 1) {
            return;
        }

        // Внешний цикл для проходов по массиву
        for (uint256 i = 0; i < n - 1; i++) {
            bool swapped = false;  // Оптимизация: Если за проход не было обменов, массив уже отсортирован

            // Внутренний цикл для сравнения соседних элементов
            for (uint256 j = 0; j < n - 1 - i; j++) {
                uint256 current = _a[j];       // Кэшируем текущее значение элемента из хранилища
                uint256 next = _a[j + 1];      // Кэшируем следующее значение элемента из хранилища

                // Если текущий элемент больше следующего, меняем их местами
                if (current > next) {
                    _a[j] = next;   // Обновляем текущее значение в массиве
                    _a[j + 1] = current;  // Обновляем следующее значение в массиве
                    swapped = true;  // Устанавливаем флаг, что был произведён обмен
                }
            }

            // Если не было обменов, массив уже отсортирован
            if (!swapped) {
                break;
            }
        }
    }

    // Функция для получения массива
    function getArray() external view returns (uint256[] memory) {
        return _a;
    }
}


// Оптимизации:
// Кэширование длины массива:

// Мы кэшируем длину массива n = _a.length; в начале функции. Это снижает количество обращений к хранилищу, поскольку каждое обращение к .length требует загрузки данных из хранилища.
// Кэширование элементов массива:

// Перед сравнением соседних элементов массива, мы сначала загружаем их значения в переменные current и next. Это минимизирует количество операций записи/чтения из хранилища, так как обращение к хранилищу дорогое по газу.
// Ранняя остановка цикла (swapped):

// Если за один проход по массиву не было произведено обменов, это означает, что массив уже отсортирован, и мы можем завершить сортировку, не делая лишних операций. Это снижает количество проходов по массиву.
// Оптимизация внутреннего цикла:

// Внутренний цикл идет только до n - 1 - i, поскольку каждый раз после завершения прохода последний элемент уже на своём месте. Это позволяет уменьшить количество сравнений в последующих итерациях.
// Анализ затрат на газ:
// Основное снижение затрат на газ происходит за счёт сокращения числа обращений к хранилищу через кэширование данных в стеке (работа с локальными переменными).
// Чем меньше размер массива, тем меньше затрат на газ потребуется, так как пузырьковая сортировка имеет временную сложность 
// 𝑂
// (
// 𝑛
// 2
// )
// O(n 
// 2
//  ).
// Флаг swapped позволяет завершить сортировку раньше, если массив уже отсортирован, что также экономит газ.