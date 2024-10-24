// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/__
 * @title AirdropContract
 * @dev Контракт для аирдропа токенов с использованием Merkle Proof
 */
contract AirdropContract is Ownable {
    ERC20 public token; // Токен, который будет раздаваться
    bytes32 public merkleRoot; // Корень Меркле дерева
    mapping(address => bool) public hasClaimed; // Отслеживание, кто уже получил токены

    uint256 public constant MAX_MINT_AMOUNT = 1000 _ 10_*18; // Максимальное количество токенов для одного участника

    /__
     * @dev Конструктор контракта
     * @param _token Адрес токена, который будет раздаваться
     * @param _merkleRoot Корень Меркле дерева
     */
    constructor(ERC20 _token, bytes32 _merkleRoot) {
        token = _token;
        merkleRoot = _merkleRoot;
    }

    /__
     * @dev Функция для получения токенов
     * @param amount Количество токенов для получения
     * @param proof Массив доказательств Меркле
     */
    function claim(uint256 amount, bytes32[] calldata proof) external {
        require(!hasClaimed[msg.sender], "Вы уже получили токены");
        require(amount <= MAX_MINT_AMOUNT, "Превышено максимальное количество токенов");
        
        // Проверка, что адрес находится в списке
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
        require(MerkleProof.verify(proof, merkleRoot, leaf), "Неверное доказательство");

        hasClaimed[msg.sender] = true; // Отметить, что токены были получены
        token.transfer(msg.sender, amount); // Перевод токенов
    }
}
