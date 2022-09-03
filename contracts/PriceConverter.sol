// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Importing from online
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        //  ETH in terms of USD
        // 300.00000000 with 8 decimal palces
        return uint256(price * 1e10); // 1**10 = 10000000000
    }

    // function getVersion() internal view returns (uint256) {
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(
    //         0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
    //     );
    //     return priceFeed.version();
    // }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        //  eth price = $3000 = 3000_000000000000000000 = ETH / USD price
        //  1_000000000000000000 ETH

        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        //  equals 2.999e21 or 2999.99999999999999999
        // use round numbers in Ethereum
        return ethAmountInUsd;
    }
}
