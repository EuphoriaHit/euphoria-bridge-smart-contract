const BSCToken = artifacts.require('BSCToken.sol');
contract('BSCToken', async (accounts) => {
  it('should smart contract deploy', async () => {
    const bridge = await BSCToken.new();
    console.log(bridge.address);
    console.log(bridge._token);
    assert(bridge.address != '');
  });
});
