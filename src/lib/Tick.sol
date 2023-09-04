// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

library Tick {
    struct Info {
        bool initialized;
        uint128 liquidity;
    }

    //this function update and initialized the liquidity if had 0 liquidity and add new liquidity
    function update(
        mapping(int24 => Tick.info) storage self,
        int24 _tick,
        uint128 liquidityDelta
    ) internal {

        //find out the tick info from ticks mapping for corresponding tick
        Tick.info storage tickInfo= self[_tick]
        uint128 liquidityBefore= tickInfo.liqiuidity;
        uint128 liquidityAfter= liquidityBefore + liquidityDelta;

        if(liqiuidityBefore==0){
            tickInfo.initialized=true;
        }

        tickInfo.liqiuidity= liquidityAfter
    }
}
