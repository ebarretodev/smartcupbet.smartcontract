//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface _priceFeed) internal view returns (uint256) {
        (, int256 price, , , ) = _priceFeed.latestRoundData();
        //ETH in terms of USD
        //3000.00000
        return uint256(price * 1e10); //1 ** 10 ==10000000000
    }

    function getConversionRate(uint256 _maticAmount, AggregatorV3Interface _priceFeed)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice(_priceFeed);
        uint256 maticAmountInUsd = (ethPrice * _maticAmount) / 1e18;
        return maticAmountInUsd;
    }
}
