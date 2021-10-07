var HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();
var mnemonic = process.env.MNEMONIC;
module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    rinkeby: {
      provider: function () {
        return new HDWalletProvider(
          mnemonic,
          `https://rinkeby.infura.io/v3/${process.env.API_KEY}`,
        );
      },
      network_id: 4,
      // gas: 4500000,
      // gasPrice: 10000000000,
      // skipDryRun: true,
    },
    ropsten: {
      provider: function () {
        return new HDWalletProvider(
          mnemonic,
          `https://ropsten.infura.io/v3/${process.env.API_KEY}`,
        );
      },
      network_id: 4,
      gas: 4500000,
      gasPrice: 10000000000,
    },
    bscTestnet: {
      provider: () =>
        new HDWalletProvider(
          mnemonic,
          'https://data-seed-prebsc-1-s1.binance.org:8545',
        ),
      network_id: 97,
      skipDryRun: true,
      gas: 4500000,
      gasPrice: 10000000000,
    },
  },
  mocha: {
    // timeout: 100000
  },
  compilers: {
    solc: {
      version: '^0.8.0',
    },
  },
  db: {
    enabled: false,
  },
  // plugins: ['truffle-plugin-verify'],
};
