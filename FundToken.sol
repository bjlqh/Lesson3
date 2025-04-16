//SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract FundToken {

    //1、通证的名字
    //2、通证的简称
    //3、通证的发行数量
    //4、owner地址
    //5、balance   address => uint256
    string public tokenName;      
    string public tokenSymbol;      //简称
    uint256 public totalSupply;     //发行数量
    address public owner;
    mapping(address => uint256) public balances;


    constructor(string memory _tokenName, string memory _tokenSymbol){
        //构造函数中传参数 
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        owner = msg.sender;
    }


    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    } 

    //mint：获取通证 
    /*
        铸造一些通证到地址里面。 我现在一个通证都没有，我现在想拥有几个该怎么做?
        我可以设置条件，让他转一些eth到我的合约里来。类似FundMe中 funderToAmount中，是否有值。
        一般情况下mint需要获取一些费用的，根据用户transfer eth的数量而定。
        或者根据FundMe.funderToAmount里面value是多少，给他铸造多少。
    */
    function mint(uint256 amountToMint) public {
        balances[msg.sender] += amountToMint;
        totalSupply += amountToMint;
        //fundMe.funderToAmount里面存的是真正的coin, balances这里存的是token
    }

    //transfer: transfer 通证
    // 我要transfer给谁？transfer的数量
    function transfer(address payee, uint256 amount) public {
        require(balances[msg.sender] >= amount,"You do not have enough balance to transfer");
        balances[msg.sender] -= amount;
        balances[payee] += amount;
    }


    //balanceOf: 查看某一个地址通证的数量
    function balanceOf(address addr) public view returns (uint256){
        return balances[addr];
    }

}