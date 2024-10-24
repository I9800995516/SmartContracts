   // Proxy.sol
   pragma solidity ^0.8.0;

   contract Proxy {
       address public logicContract;
       address public owner;

       constructor(address _logicContract) {
           logicContract = _logicContract;
           owner = msg.sender; // Устанавливаем владельца на адрес, который развернул контракт
       }

       modifier onlyOwner() {
           require(msg.sender == owner, "Not the contract owner");
           _;
       }

       function updateLogicContract(address _newLogicContract) external onlyOwner {
           logicContract = _newLogicContract; // Обновляем адрес логики
       }

       fallback() external payable {
           (bool success, ) = logicContract.delegatecall(msg.data);
           require(success, "Delegatecall failed");
       }
   }
   
