// SPDX-License-Identifier: 3BSD
pragma solidity ^0.7.0;

import "@uniswap/v3-core/contracts/libraries/FullMath.sol";
import "@uniswap/v3-core/contracts/libraries/TickMath.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

/// @title Rainshower oracle library
/// @author makemake
/// @dev Contains functions for use with the Uniswap V3 oracle
library OracleLib {
    /// @notice Gets the tick time weighted average tick
    /// @param _pool Pool address
    /// @param _period Period of the TWAP in seconds
    /// @return twat Time weighted average tick
    function getTwat(address _pool, uint32 _period) internal view returns (int24 twat) {
        require(_period != 0);

        uint32[] memory historicalCumulativeTick = new uint32[](2);
        historicalCumulativeTick[0] = _period;
        historicalCumulativeTick[1] = 0;

        (int56[] memory cumulativeTicks, ) = IUniswapV3Pool(_pool).observe(historicalCumulativeTick);
        int56 tickDelta = cumulativeTicks[1] - cumulativeTicks[0];
        
        twat = int24(tickDelta / _period);

        if (tickDelta < 0 && (tickDelta % _period != 0)) {
            twat--;
        }

    }

    /// @notice Approximate the amount of tokens recieved by a swap
    /// @param _tick Tick at wich we calculate the amount
    /// @param _amount Amount to be swapped
    /// @param _token0 Address of the token used for _amount
    /// @param _token1 Address of the token used for amountReceived
    /// @return amountReceived Amount of tokens received for _amount of _token0
    function getAmountAtTick(int24 _tick, uint128 _amount, address _token0, address _token1) internal pure returns (uint256 amountReceived) {
        uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(_tick);

        // Use better precision if amountReceived is less than type(uint128).max
        if (sqrtPriceX96 <= type(uint128).max) {
            uint256 ratioX192 = uint256(sqrtPriceX96) * sqrtPriceX96;

            if (_token0 < _token1) {
                amountReceived = FullMath.mulDiv(ratioX192, _amount, 1 << 192);
            } else {
                amountReceived = FullMath.mulDiv(1 << 192, _amount, ratioX192);
            }
        } else {
            uint256 ratioX128 = FullMath.mulDiv(sqrtPriceX96, sqrtPriceX96, 1 << 64);

            if (_token0 < _token1) {
                amountReceived = FullMath.mulDiv(ratioX128, _amount, 1 << 192);
            } else {
                amountReceived = FullMath.mulDiv(1 << 192, _amount, ratioX128);
            }
        }
    }
}
