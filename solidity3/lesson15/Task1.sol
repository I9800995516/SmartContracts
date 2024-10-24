// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitOperations {
    bool isContract = true;
    address owner = address(12345);
    uint16 id = 9876; 

    // Function to get all values stored in the same slot
    function getValues() external view returns (bool, address, uint16) {
        bool _isContract;
        address _owner;
        uint16 _id;

        // Using inline assembly to read from the same storage slot
        assembly {
            // Load the first 32 bytes from the storage slot 0
            let slotValue := sload(0)

            // Extract the boolean (1 byte), address (20 bytes), and uint16 (2 bytes)
            _isContract := and(slotValue, 0x01) // Get the last byte for isContract
            _owner := shr(8, slotValue) // Shift right to get the address
            _id := and(shr(88, slotValue), 0xFFFF) // Get the last 2 bytes for id
        }

        return (_isContract, _owner, _id);
    }
}


// Explanation of the Code

// 1. Storage Layout: In Solidity, the variables are stored in slots. The isContract (1 byte), owner (20 bytes), and id (2 bytes) can fit into a single 32-byte storage slot. The layout in the slot would look like this:
//    - isContract: 1 byte (last byte)
//    - owner: 20 bytes (next 20 bytes)
//    - id: 2 bytes (first 2 bytes)

// 2. Inline Assembly: The getValues function uses inline assembly to read the entire storage slot (slot 0) at once. It then extracts the individual values:
//    - isContract is extracted using a bitwise AND operation to get the last byte.
//    - owner is obtained by shifting the slot value right by 8 bytes (64 bits) to discard the isContract byte and the id bytes.
//    - id is extracted by shifting the slot value right by 88 bits (11 bytes) and applying a mask to get the last 2 bytes.

// 3. Return Values: The function returns the extracted values as a tuple.

// This implementation efficiently retrieves the values stored in the same slot while ensuring that the data types are correctly interpreted.