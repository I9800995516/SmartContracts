// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StorageOptimization {
    // Массив балансов пользователей
    uint256[] public balances;

    // Маппинг для индекса балансов
    mapping(address => uint256) public balanceIndex;

    // Функция для обновления или добавления баланса пользователя
    function updateBalance(address user, uint256 newBalance) public {
        // Получаем индекс баланса пользователя
        uint256 index = balanceIndex[user];

        // Если индекс равен 0, это значит, что пользователь ещё не в массиве
        if (index == 0) {
            // Добавляем новый баланс в массив
            balances.push(newBalance);

            // Сохраняем индекс пользователя, индекс будет равен длине массива (нумерация начинается с 1)
            balanceIndex[user] = balances.length;
        } else {
            // Обновляем существующий баланс пользователя
            balances[index - 1] = newBalance;
        }
    }

    // Функция для тестирования затрат на газ при обращении к холодным и тёплым слотам
    function testGasUsage(address user1, address user2) public {
        // Первая запись в холодные слоты
        updateBalance(user1, 100);

        // Вторая запись в холодные слоты
        updateBalance(user2, 200);

        // Повторное обновление — теперь слоты будут тёплыми
        updateBalance(user1, 300);
        updateBalance(user2, 400);
    }

    // Функция для чтения баланса пользователя
    function getBalance(address user) public view returns (uint256) {
        uint256 index = balanceIndex[user];
        if (index == 0) {
            return 0;  // Баланс по умолчанию для новых пользователей
        } else {
            return balances[index - 1];
        }
    }
}


// Массив balances: Он хранит балансы пользователей. Индекс в массиве определяется с помощью маппинга.
// Маппинг balanceIndex: Содержит индексы пользователей в массиве balances. Индексы начинаются с 1 (нумерация с 0 зарезервирована для нового пользователя).
// Функция updateBalance: Добавляет нового пользователя в массив или обновляет его существующий баланс.
// Оптимизация доступа к хранилищу:
// При первой записи в маппинг и массив мы обращаемся к холодным слотам, которые требуют больше газа.
// При повторных вызовах тех же данных мы обращаемся к тёплым слотам, что снижает затраты на газ.
// Функция testGasUsage: Позволяет протестировать несколько операций чтения и записи для анализа затрат на газ.
// Оптимизация за счёт многократного обращения к тёплым слотам
// Когда данные в хранилище впервые запрашиваются или изменяются (при работе с холодными слотами), это требует значительных затрат газа. Однако если слоты были недавно использованы (например, в том же транзакционном контексте), они считаются "тёплыми", и дальнейший доступ к ним требует гораздо меньше газа.

// Холодные слоты: Первоначальный доступ к переменной в хранилище (например, к маппингу или элементам массива), которая ранее не использовалась в транзакции. Для каждого нового обращения к холодным слотам требуется больше газа.
// Тёплые слоты: Если слот был доступен хотя бы раз в течение транзакции, при последующих обращениях к нему затраты на газ значительно снижаются.
// Анализ затрат на газ
// Чтение и запись в холодные слоты:
// Запись в маппинг (cold write): При первом обращении к маппингу требуется больше газа, потому что слот является холодным. Для хранения данных нужно загрузить слот и обновить его.
// Запись в массив (cold write): Добавление нового элемента в массив также требует значительных затрат на газ, так как слот холодный.
// Чтение и запись в тёплые слоты:
// Запись в маппинг (warm write): При повторном доступе к маппингу в одной и той же транзакции затраты на газ снижаются, так как слот уже был доступен ранее.
// Запись в массив (warm write): Аналогично, повторное обращение к массиву с теми же данными требует меньше газа.
// Пример оценки газа:
// Первоначальное обновление балансов (холодные слоты):
// Затраты на газ выше, так как нужно сохранить новую запись в маппинге и массиве, причём обращение к хранилищу происходит впервые в этой транзакции.
// Повторное обновление балансов (тёплые слоты):
// Затраты на газ существенно ниже, так как слоты уже "разогреты" в текущей транзакции, и обращение к ним требует меньше газа.
// Точную оценку затрат на газ можно получить с помощью Hardhat или Remix, запуская тесты и анализируя расходы газа.