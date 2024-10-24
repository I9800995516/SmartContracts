   const hre = require("hardhat");

   async function main() {
       const LogicContract = await hre.ethers.getContractFactory("LogicContract");
       const logic = await LogicContract.deploy();
       await logic.deployed();

       const Proxy = await hre.ethers.getContractFactory("Proxy");
       const proxy = await Proxy.deploy(logic.address);
       await proxy.deployed();

       console.log("LogicContract deployed to:", logic.address);
       console.log("Proxy deployed to:", proxy.address);
   }

   main().catch((error) => {
       console.error(error);
       process.exitCode = 1;
   });
   
