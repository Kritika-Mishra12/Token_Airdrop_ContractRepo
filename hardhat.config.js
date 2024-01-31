require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  paths:{
    artifacts: "./src/artifacts",
  },
  networks: {
    testnet: {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545/`,
      chainId: 97,
      accounts: [''], //put your private key
    },
  },
  etherscan: {
    apiKey: 'NQPQD5UKR73TYG8ST8CF3GC6SNMNUEUE39'
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      "viaIR": true,
    }
  },
};

