// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "./lib/Tick.sol";
import "./lib/Position.sol";

contract UniswapV3Pool {

    //Errors
    error InvalidTickRange;
    error ZeroLiquidity;
    error InsufficientInputAmount;

    //using Position and Tick library
    using Tick for mapping(int24 => Tick.Info);
    using Position for mapping(bytes32 => Position.Info);

    //setting min and max tick
    int24 internal constant MIN_TICK = -887272;
    int24 internal constant MAX_TICK = -MIN_TICK;

    //setting Pool tokens
    address public immutable token0;
    address public immutable token1;

    //token amount
    amount0 = 0.998976618347425280 ether;
    amount1 = 5000 ether;

    //Packing variables that are read together
    struct Slot0 {
        //current sqrt(P)
        uint160 sqrtPriceX96;
        //current tick
        int24 tick;
    }

    //variable of type Slot0
    Slot0 public slot0;

    //amount of liquidity L
    uint128 public liquidity;

    //Ticks info
    mapping(int24 => Tick.Info) public ticks;

    //Position info
    mapping(bytes32 => Position.Info) public positions;

    //contructor that initializes some varibales of our contract. here we are setting the token address for the pool , current tick and its price
    constructor(
        address _token0,
        address _token1,
        uint160 _sqrtPriceX96,
        int24 _tick
    ) {
        token0 = _token0;
        token1 = _token1;

        slot0 = Slot0({sqrtPriceX96: _sqrtPriceX96, tick: _tick});
    }

    //to provide liquidity
    //1. it takes owner(to track owner of the liquidity), lowerTick-upperTick(to set bounds of price range) and amount of liquidity we want to provide
    //how minting will work------
    //1--> user specifies the price range and amount of liquidity.
    //2--> contract updates the ticks and position mapping.
    //3--> contract will calculate how much token amount user should send
    //4--> contract takes the token from the token and checks correct amount were sent
    function mint(
        address owner,
        int24 lowerTick,
        int24 upperTick,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1) {
        if (
            lowerTick >= upperTick ||
            lowerTick < MIN_TICK ||
            upperTick > MAX_TICK
        ) revert InvalidTickRange();

        if (amount == 0) revert ZeroLiquidity();

        //after check range and liqiuidity add tick and positions
        ticks.update(lowerTick,amount);
        ticks.update(upperTick,amount);

        //get a specific position
        Position.info storage position=positions.get(owner,lowerTick,upperTick);
        
        //update the return position
        position.update(amount)

        //add the amount to the liquidity
        liquidity+=amount;


        uint256 balance0Before;
        uint256 balance1Before;
        if (amount0 > 0) balance0Before = balance0();
        if (amount1 > 0) balance1Before = balance1();
        IUniswapV3MintCallback(msg.sender).uniswapV3MintCallback(
            amount0,
            amount1
        );
        if (amount0 > 0 && balance0Before + amount0 > balance0())
            revert InsufficientInputAmount();
        if (amount1 > 0 && balance1Before + amount1 > balance1())
            revert InsufficientInputAmount();
        
    }
}

function balance0() internal returns (uint256 balance){
    IERC20(token0).balanceOf(address(this));
}

function balance0() internal returns (uint256 balance){
    IERC20(token1).balanceOf(address(this));
}
