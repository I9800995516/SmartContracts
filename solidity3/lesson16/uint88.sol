uint88[] uint88Arr;

function pushUint88Elem(uint88 newElem) external {
    assembly {
        let length := sload(uint88Arr.slot)
        let slot := add(uint88Arr.slot, length)
        sstore(slot, newElem)
        sstore(uint88Arr.slot, add(length, 1))
    }
}

function getUint88Elem(uint256 index) external view returns (uint88) {
    uint88 value;
    assembly {
        let length := sload(uint88Arr.slot)
        if iszero(lt(index, length)) {
            revert(0, 0)
        }
        let slot := add(uint88Arr.slot, index)
        value := sload(slot)
    }
    return value;
}

//комменты