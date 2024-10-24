// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataProcessor {
    
    // Function to process an array and return the squares of each number
    function processArray(uint256[] calldata numbers) external pure returns (uint256[] memory) {
        uint256[] memory squares = new uint256[](numbers.length);
        for (uint256 i = 0; i < numbers.length; i++) {
            squares[i] = numbers[i] * numbers[i];
        }
        return squares;
    }

    // Function to calculate the sum of an array of numbers
    function calculateSum(uint256[] calldata numbers) external pure returns (uint256) {
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
