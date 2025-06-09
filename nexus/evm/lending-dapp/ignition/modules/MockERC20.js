const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const MockERC20 = buildModule("MockERC20", (m) => {
  const btcContract = m.contract("MockERC20", ["MockBTC", "BTC"], {
    id: "BTC",
  });

  const abtcContract = m.contract("MockERC20", ["MockaBTC", "aBTC"], {
    id: "aBTC",
  });

  const usdtContract = m.contract("MockERC20", ["MockUSDT", "USDT"], {
    id: "USDT",
  });

  return { btcContract, abtcContract, usdtContract };
});

module.exports = MockERC20;
