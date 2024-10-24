pragma solidity ^0.8.0;

contract MyContract {
    uint256[] arr;

    function pushArrayElem(uint256 newElem) external {
        assembly {
            // Получаем текущую длину массива
            let length := sload(arr.slot)

            // Вычисляем слот для нового элемента
            let slot := add(arr.slot, length)

            // Сохраняем новое значение в вычисленный слот
            sstore(slot, newElem)

            // Обновляем длину массива
            sstore(arr.slot, add(length, 1))
        }
    }

    function getElem(uint256 index) external view returns (uint256) {
        uint256 value;
        assembly {
            // Получаем длину массива
            let length := sload(arr.slot)

            // Проверяем, что индекс в пределах длины массива
            if iszero(lt(index, length)) {
                revert(0, 0)
            }

            // Вычисляем слот для элемента
            let slot := add(arr.slot, index)

            // Получаем значение из слота
            value := sload(slot)
        }
        return value;
    }
}
