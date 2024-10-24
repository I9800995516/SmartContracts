// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MerkleProof {
    /__
     * @dev Проверяет, является ли `leaf` частью Меркле дерева с корнем `root`.
     * Использует массив `proof`, который должен содержать хэши соседних узлов.
     * 
     * Например, если у нас есть следующие хэши:
     * 
     *     hash1
     *     /    \
     *  hash2  hash3
     *
     * И `leaf` является `hash2`, то `proof` будет содержать `hash3`.
     *
     * @param proof Массив хэшей, представляющий доказательства
     * @param root Корень Меркле дерева
     * @param leaf Хэш листа, который мы проверяем
     * @return true Если `leaf` является частью дерева, иначе false
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }

        return computedHash == root;
    }

    /__
     * @dev Хэширует пару хэшей, возвращая их комбинацию.
     * Использует порядок, чтобы гарантировать правильное вычисление.
     *
     * @param a Первый хэш
     * @param b Второй хэш
     * @return bytes32 Комбинированный хэш
     */
    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a, b)) : keccak256(abi.encodePacked(b, a));
    }
}
