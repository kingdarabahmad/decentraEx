// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

library Position {
    struct Info {
        uint128 liquidity;
    }

    //add liquidity to a specific position
    function update(Info storage self, uint128 _liquidityDelta) internal {
        uint128 liquidityBefore = self.liqiuidity;
        uint128 liquidityAfter = liqiuidityBefore + _liquidityDelta;
        self.liquidity = liquidityAfter;
    }

    //return the specific position from the positions mapping
    function get(
        mapping(bytes32 => Info) storage self,
        address owner,
        int24 lowerTick,
        int24 upperTick
    ) internal view returns (Position.Info storage position) {
        position = self[
            keccak256(abi.encodePacked(owner, lowerTick, upperTick))
        ];
    }
}
