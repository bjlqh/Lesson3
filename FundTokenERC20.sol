// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./FundMe.sol";

/*
    1.让FundMe的参与者，基于mapping来领取相应数量的通证。就是mint通证
    2.让FundMe的参与者，transfer 通证
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

    function mint(uint256 amountToMint) public {
        require(fundMe.funderToAmount(msg.sender) >= amountToMint,"You cannot mint this many tokens");
        //调用ERC20的 mint 去铸造token
        _mint(msg.sender, amountToMint);
        
    }
}
