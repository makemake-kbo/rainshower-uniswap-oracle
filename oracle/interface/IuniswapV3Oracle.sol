//SPDX-License-Identifier: 3BSD
pragma solidity >=0.7.0;

/// @title Rainshower oracle interface
/// @author makemake
/// @dev Interface for the Rainshower TWAP oracle. Use to get the TWAP price using Uniswap V3.
interface IuniswapV3Oracle {
    
    /// @notice Approximate the amount of tokens recieved by a swap
    /// @param _pool Pool address
    /// @param _period Period of the TWAP in seconds
    /// @param _amount Amount to be swapped
    /// @param _token0 Address of the token used for _amount
    /// @param _token1 Address of the token used for amountReceived
    /// @return amountReceived Amount of tokens received for _amount of _token0
    function getSpotPrice(address _pool, uint32 _period, uint128 _amount, address _token0, address _token1) external view returns(uint256 amountReceived);
}
