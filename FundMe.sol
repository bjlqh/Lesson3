// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
//1. 创建一个收款函数
//2. 记录投资人并且查看
//3. 锁定期內，达到目标值，生产商可以提款
//4. 锁定期內，没有达到目标值，投资人可以退款
contract FundMe {

    mapping (address => uint256) public funderToAmount;

    uint256 MINIMUM_VALUE = 100 * 10 ** 18; //wei 

    AggregatorV3Interface internal dataFeed;    //合约内部调用

    constructor(){
        //Sepolia测试网
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    
    /*
        外界才能看见，用external
        payable 关键词表示当前函数可以接收原生通证token
            如果是以太网上的原生通证就是eth.如果是在ploygon上是matic
            我们创建的token是一种，但是gas是另一种token,也就是链自带的，也就叫原生token
            如果你的合约想要收取原生token，就需要payable这个关键字
    */
    function fund() external payable {
        require(convertEthToUsd(msg.value) >= MINIMUM_VALUE, "Send more ETH");
        funderToAmount[msg.sender] = msg.value;       
    }

    function getChainlinkDataFeekLatestAnswer() public view returns (int){
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    } 

    //把ETH转化为USD
    function convertEthToUsd(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = uint(getChainlinkDataFeekLatestAnswer());
        return ethAmount * ethPrice / (10**8);
        // ethAmount的单位是wei 1 ether = 10^18wei
        // ETH / USE = 10^8  1个ETH值多少USD,由于chainlink对于获取到的usd的价格扩大了10^8，所以在将ETH转化为USD时，需要除以10^8
    }

}