const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

/*
 * E.g. Somnia Testnet
 * DIA Oracle - 0x9206296ea3aee3e6bdc07f7aaef14dfcf33d865d
 * ERC20 Deployments:
 * MockERC20#BTC - 0xB1d8c25937e200AE7Eae0f3E4893FD7399ae42a9
 * MockERC20#aBTC - 0x346A239F4BaeECAaF1d844Ad2DFc959626cb333d
 * MockERC20#USDT - 0x37C31C9194ec1d3aF5234461B169B84BD28B7a84
 *
 */
const LendingPool = buildModule("LendingPool", (m) => {
  const contract = m.contract(
    "LendingPool",
    [
      "0x9206296ea3aee3e6bdc07f7aaef14dfcf33d865d",
      "0xB1d8c25937e200AE7Eae0f3E4893FD7399ae42a9",
      "0x346A239F4BaeECAaF1d844Ad2DFc959626cb333d",
      "0x37C31C9194ec1d3aF5234461B169B84BD28B7a84",
    ],
    {
      id: "LendingPool",
    }
  );
  return { contract };
});

module.exports = LendingPool;
