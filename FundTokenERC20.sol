// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";

/*
    1.让FundMe的参与者，基于mapping来领取相应数量的通证。就是mint通证
    2.让FundMe的参与者，transfer 通证。
    3.再使用完通证以后需要burn 通证
*/
contract FundTokenERC20 is ERC20 {
    
    FundMe fundMe;
    constructor(address fundMeAddr) ERC20 ("FundTokenERC20", "FT") {
        /*
            表示 "fundMe 变量将指向链上已部署的 FundMe 合约实例（地址为 fundMeAddr)"

            FundTokenERC20 合约需要与预先部署好的 FundMe 合约交互，而不是每次部署代币时都重新部署一个新的 FundMe 合约。
            重新部署会导致：
                丢失原有 FundMe 合约中的数据
                破坏两个合约之间的关联性
            经济性：
                每次部署新合约需要消耗 Gas，而直接绑定现有合约地址是零成本操作。
        */
        fundMe = FundMe(fundMeAddr);
    }

    //铸造
    function mint(uint256 amountToMint) public afterGetFund {
        require(fundMe.funderToAmount(msg.sender) >= amountToMint,"You cannot mint this many tokens");
        //调用ERC20的 mint 去铸造token
        _mint(msg.sender, amountToMint);
        //修改funderToAmount里面键值对.当前地址，之前的数量-现在的数量
        fundMe.setFunderToAmount(msg.sender, fundMe.funderToAmount(msg.sender) - amountToMint);
    }

    //兑换
    function claim(uint256 amountToClaim) public afterGetFund {
        //如果完成兑换，需要销毁通证的数量
        //balanceOf返回当前调用者的通证的数量
        require(balanceOf(msg.sender) >= amountToClaim, "you dont have enough ERC20 tokens");
        //todo do something
        _burn(msg.sender, amountToClaim);
    }

    modifier afterGetFund(){
        require(fundMe.getFundSuccess(), "The fundme is not completed yet");
        _;
    }

    /*
        以上两个函数调用的时机是什么时候呢？
        只有等到FundMe众筹结束以后，并且Owner调用getFund提取所有的Eth以后。
        其他的参与者才能铸造ERC20的通证，作为凭证。再去对商品进行兑换。
        要保证以上两个函数在这样一个时机被调用。就要回到FundMe，查看getFund执行完以后是否有标记。
    */




    /*
    让FundMe的参与者，transfer 通证。这个方法ERC20已经做了，我们直接继承就行了。
    function transfer(address to, uint256 value) public returns (bool){
        //调用父类方法
        //因为parent 不支持transferFrom ，所以使用_transfer 代替。
        _transfer(msg.sender, to, value);
        fundMe.setFunderToAmount(msg.sender, fundMe.funderToAmount(msg.sender) + value);
    }
    */


    /*
    销毁通证，可以继承ERC20的实现
    function burn(address account, uint256 value) internal {
        require(account == _msgSender(), "ERC20: transfer from non-zero address");
        require(_allowance[account][_msgSender()] >= value,"You cannot burn this many tokens, please get more tokens first!");
         //调用父类方法
       ERC20.burn(account,value);
    }
    */
    
}