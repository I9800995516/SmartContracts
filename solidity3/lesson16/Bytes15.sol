bytes15[] bytesArr;

function pushBytesElem(bytes15 newElem) external {
    assembly {
        let length := sload(bytesArr.slot)
        let slot := add(bytesArr.slot, length)
        sstore(slot, newElem)
        sstore(bytesArr.slot, add(length, 1))
    }
}

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
