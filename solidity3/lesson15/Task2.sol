// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitOperations {
    uint256 private slot; // Storage for all variables in one slot

    // Function to get the stored variables
    function getVariables() public view returns (bool, address, uint16) {
        bool isContract = (slot & 0x01) != 0; // Extracting isContract (last byte)
        address owner = address(uint160((slot >> 8) & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)); // Extracting owner (next 20 bytes)
        uint16 id = uint16((slot >> 88) & 0xFFFF); // Extracting id (first 2 bytes)
        return (isContract, owner, id);
    }

    // Function to set the variables in one slot
    function setVariables(bool _isContract, address _owner, uint16 _id) public {
        slot = 0; // Reset the slot
        slot |= (_isContract ? 1 : 0); // Set isContract
        slot |= (uint256(uint160(_owner)) << 8); // Set owner
        slot |= (uint256(_id) << 88); // Set id
    }
}

// Explanation of the Code

// 1. Storage Slot: The contract uses a single uint256 variable named slot to store all three values:
//    - isContract: 1 bit (last bit of the slot)
//    - owner: 20 bytes (next 20 bytes after the boolean)
//    - id: 2 bytes (first 2 bytes of the slot)

// 2. getVariables Function:
//    - isContract: Extracted by performing a bitwise AND with 0x01 and checking if the result is not zero.
//    - owner: Extracted by shifting the slot right by 8 bits and masking the result to get the last 20 bytes, then converting it to an address.
//    - id: Extracted by shifting the slot right by 88 bits and masking with 0xFFFF to get the last 2 bytes.

// 3. setVariables Function:
//    - The slot is reset to zero to clear previous values.
//    - The isContract value is set using a conditional expression that assigns 1 if true, otherwise 0.
//    - The owner address is cast to uint160 and shifted left by 8 bits to place it in the correct position.
//    - The id is shifted left by 88 bits to place it in the correct position in the slot.

// This implementation efficiently manages the storage of multiple variables in a single slot using bitwise operations, ensuring that the data types are correctly handled.