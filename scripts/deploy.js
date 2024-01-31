async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    const Token = await ethers.getContractFactory("Airdrop");
    const token = await Token.deploy("0x496aeCcFF38Cfe3B939fC6A78D96d607Fb102F0B",1000);
  
    console.log("Token address:", token.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });