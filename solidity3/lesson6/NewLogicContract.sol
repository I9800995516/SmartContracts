   // NewLogicContract.sol
   pragma solidity ^0.8.0;

   contract NewLogicContract {
       uint public value;

       function setValue(uint _value) public {
           value = _value;
       }

       function incrementValue() public {
           value++;
       }
   }
   
