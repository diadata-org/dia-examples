const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const MockERC20 = buildModule("MockERC20", (m) => {
  const btcContract = m.contract("MockERC20", ["MockBTC", "BTC"], {
    id: "BTC",
  });

  const abtcContract = m.contract("MockERC20", ["MockaBTC", "aBTC"], {
    id: "aBTC",
  });

  return { btcContract, abtcContract };
});

module.exports = MockERC20;
