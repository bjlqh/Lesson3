// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//1. 创建一个收款函数
//2. 记录投资人并且查看
//3. 锁定期內，达到目标值，生产商可以提款
//4. 锁定期內，没有达到目标值，投资人可以退款
contract FundMe {

    mapping (address => uint256) public funderToAmount;

    uint256 MINIMUM_VALUE = 1 * 10 ** 18; //wei 
    
    /*
        外界才能看见，用external
        payable 关键词表示当前函数可以接收原生通证token
            如果是以太网上的原生通证就是eth.如果是在ploygon上是matic
            我们创建的token是一种，但是gas是另一种token,也就是链自带的，也就叫原生token
            如果你的合约想要收取原生token，就需要payable这个关键字
    */
    function fund() external payable {
        require(msg.value >= MINIMUM_VALUE, "Send more ETH");
        funderToAmount[msg.sender] = msg.value;       
    }

}