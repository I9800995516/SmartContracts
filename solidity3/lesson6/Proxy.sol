   // Proxy.sol
   pragma solidity ^0.8.0;

   contract Proxy {
       address public logicContract;

       constructor(address _logicContract) {
           logicContract = _logicContract;
       }

       fallback() external payable {
           (bool success, ) = logicContract.delegatecall(msg.data);
           require(success, "Delegatecall failed");
       }
   }
   
