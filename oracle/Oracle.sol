// SPDX-License-Identifier: 3BSD
pragma solidity ^0.7.0;

import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {OracleLib} from "./lib/OracleLib.sol";

/// @title Rainshower oracle
/// @author makemake
/// @dev Use to get the TWAP price using Uniswap V3
contract Oracle {
    /// @notice Gets the tick time weighted average tick
    /// @param _pool Pool address
    /// @param _period Period of the TWAP in seconds
    /// @return twat Time weighted average tick
    function _getTwat(address _pool, uint32 _period) internal view returns (int24 twat) {
        return OracleLib.getTwat(_pool, _period);
    }

    /// @notice Approximate the amount of tokens recieved by a swap
    /// @param _tick Tick at wich we calculate the amount
    /// @param _amount Amount to be swapped
    /// @param _token0 Address of the token used for _amount
    /// @param _token1 Address of the token used for amountReceived
    /// @return amountReceived Amount of tokens received for _amount of _token0
    function _getAmountAtTick(int24 _tick, uint128 _amount, address _token0, address _token1) internal pure returns (uint256 amountReceived) {
        return OracleLib.getAmountAtTick(_tick, _amount, _token0, _token1);
    }
    
    /// @notice Approximate the amount of tokens recieved by a swap
    /// @param _pool Pool address
    /// @param _period Period of the TWAP in seconds
    /// @param _amount Amount to be swapped
    /// @param _token0 Address of the token used for _amount
    /// @param _token1 Address of the token used for amountReceived
    /// @return amountReceived Amount of tokens received for _amount of _token0
    function getSpotPrice(address _pool, uint32 _period, uint128 _amount, address _token0, address _token1) external view returns(uint256 amountReceived){
        return _getAmountAtTick(_getTwat(_pool, _period), _amount, _token0, _token1);
    }
}
