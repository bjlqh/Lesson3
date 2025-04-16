合约部署以后函数的颜色也可以区分        
读取函数是蓝色的，        
设置状态的函数是橘黄色的，        
可以收款的函数是红色的        


          
VALUE的单位：        
Wei最小单位
Kwei        
Mwei        
Gwei = 9次方Wei
Twei        
Pwei(Finney) = 6次方Gwei        
Ether = 3次方Finney        


          
预言机问题        
链上的任何智能合约没有办法主动的获取真实世界的任何数据        
比如获取某个通证的价格 或者 某个真实世界物品的资产价格，或者交通数据，游戏数据。        
比如我们做一个web3游戏，我们没有办法把所有数据都写在链上.这就大大制约了链上业务的多样性。
很多的数据是在服务器中，那么就必然有链上和链下数据的交互。
由于智能合约没有办法和服务器交互，所以我们需要一个第三方的基础设施（服务）帮我们把链下的数据移到链上去，让智能合约去获取。

DON(Decentralized Oracle Network) 去中心化预言机网络
不同的节点可能获取的数据不同，它们再对数据进行一次聚合（类似共识的操作）将聚合以后的数据写回区块链上。  
就算一个节点出问题了，链上合约的安全性也是可以得到保证的。  

Chainlink就是一个著名的DON。    
它能提供很多服务比如：  
Data    
Compute     
Cross-chain  


Data Feed WorkFlow 喂价     
Data Source -> Data Providers -> DON -> Chainlink Data Feed Contract(喂价合约) -> User smart Contract 
具体怎么使用：      
Consumer 发送请求-> Proxy(代理合约) -> Aggregator(聚合合约) -> DON      
因为DON会不断更新，所以聚合合约也会随着DON的更新而更新，      
所以为了隐藏聚合合约的难度通常会 再加一层代理合约。也是为了保证Aggregator的修改时，用户合约不发生修改，所以要加一层代理合约，避免麻烦。     
这就是喂价合约的工作原理。      


solidity中转账有3种方式：     
transfer: transfer ETH and revert if tx failed   
如果尝试向 msg.sender 转账（如 msg.sender.transfer(1 ether)），编译器会报错。     
合约调用者（msg.sender）将当前合约的余额转走。        
payable(msg.sender).transfer(address(this).balance);    

send: transfer ETH and return false if failed          
bool success = payable(msg.sender).send(address(this).balance);
require(success, "tx failed");

call: transfer ETH with data return value of function and bool  
(succ, ) = payable(msg.sender).call{value: address(this).balance}("");

时间锁  
设定时间段，截止期就要开始结算了。  
block.timestamp 是合约加入区块的时间戳      

第三课。讲了使用区块链浏览器去调用合约，去查看合约中的数。对合约进行验证。以及如何去验证合约。      

coin vs token   
q币 和 点券的关系   


通证合约    
创建通证    

继承用 "is"关键词

ERC20: Fungible Token   通证可以交换，没有区别。可以切分，1个切分成2个0.5      
ERC721: Non Fungible Token   不可交换，每个通证都不一样。不可切分。
