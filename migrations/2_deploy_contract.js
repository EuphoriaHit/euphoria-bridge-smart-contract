const BridgeEth = artifacts.require("BridgeEth.sol");
const BSCToken = artifacts.require("BSCToken.sol");

module.exports = async function (deployer, network, addresses) {
  if (network === "rinkeby") {
    await deployer.deploy(BridgeEth);
    await deployer.deploy(BSCToken);
    const bridgeEth = await BridgeEth.deployed();
    const bscToken = await BSCToken.deployed();
    await bscToken.initialize();
    await bridgeEth.initialize(bscToken.address);
  }
};
