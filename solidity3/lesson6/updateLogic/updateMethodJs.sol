   async function updateLogic() {
       const Proxy = await ethers.getContractAt("Proxy", proxyAddress);
       const newLogicAddress = await deployNewLogic(); // Функция для развертывания нового контракта логики
       
       const tx = await Proxy.updateLogicContract(newLogicAddress);
       await tx.wait();

       console.log("Logic contract updated to:", newLogicAddress);
   }
   
