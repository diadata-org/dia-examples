// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./MockERC20.sol";

interface IDIAOracleV2 {
    function getValue(string memory) external view returns (uint128, 
             uint128);
}

contract LendingPool {
    IDIAOracleV2 private _diaOracle;
    string private constant _assetSymbol = "BTC/USD";

    MockERC20 private _BTC;
    MockERC20 private _aBTC; 

    uint256 public constant LTV_RATIO = 70;

    mapping(address => uint256) private _depositedAmount;
    mapping(address => uint256) private _borrowedAmount;

    event AmountDeposited(address lender, uint256 amount);

    event AmountBorrowed(address borrower, uint256 amount);

    constructor(
        address oracle_, 
        address BTC_,
        address aBTC_
    ) {
        _diaOracle = IDIAOracleV2(oracle_);
        _BTC = MockERC20(BTC_);
        _aBTC = MockERC20(aBTC_);
    }

    function supply(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        _BTC.transferFrom(msg.sender, address(this), amount);
        _aBTC.transfer(msg.sender, amount);
        _depositedAmount[msg.sender] += amount;

        emit AmountDeposited(msg.sender, amount);
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        uint256 collateralAmount = _depositedAmount[msg.sender];
        require(collateralAmount > 0, "No collateral deposited");

        // Call DIA Oracle to get the latest price of BTC
        (uint128 latestPrice,) = _diaOracle.getValue(_assetSymbol);

        uint256 collateralValue = (collateralAmount * latestPrice) / 1e8;
        uint256 allowedBorrowValue = (collateralValue * LTV_RATIO) / 100;
        uint256 allowedBorrowAmount = (allowedBorrowValue * 1e8) / latestPrice;

        require((amount + _borrowedAmount[msg.sender]) <= allowedBorrowAmount, "Borrow amount exceeds TVL");

        _BTC.transfer(msg.sender, amount);
        _borrowedAmount[msg.sender] += amount;

        emit AmountBorrowed(msg.sender, amount);
    }

    function getLatestPrice() external view returns (uint256 latestPrice) { 

        (latestPrice,) = _diaOracle.getValue(_assetSymbol);

        return latestPrice;
    }

    function getDepositedAmount(address user) external view returns (uint256) {
        return _depositedAmount[user];
    }

    function getBorrowedAmount(address user) external view returns (uint256) {
        return _borrowedAmount[user];
    }
}