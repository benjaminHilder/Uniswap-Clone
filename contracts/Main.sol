pragma solidity 0.8.15;
import "./Exchange.sol";
import "./BasicERC20.sol";

contract Main {
    //     //token    //exchange
    mapping (address => address payable) public token_to_exchange;

    mapping (uint => address payable) public exchangeAddresses;
    mapping (uint => address) public tokenAddresses;
    mapping (address => uint) public tokenExchangeIterator;
    uint iterator;

    uint ethBalance;

    constructor() {
        iterator = 1;
    }

    function createExchange(address _tokenAddress) public {
        Exchange newExchange = new Exchange(_tokenAddress);
        exchangeAddresses[iterator] = payable (address(newExchange));
        tokenAddresses[iterator] = _tokenAddress;
        tokenExchangeIterator[_tokenAddress] = iterator;
        iterator++;
    }

    function swapTokenForToken(address _tokenA, uint _tokenAmount, address _tokenB) public {
        //user must approve this contract to send their funds before calling this function
        uint tokenAIterator = tokenExchangeIterator[_tokenA];
        uint tokenBIterator = tokenExchangeIterator[_tokenB];
        
        require (exchangeAddresses[tokenAIterator] != 0x0000000000000000000000000000000000000000, "Token A does not have an exchange");
        require (exchangeAddresses[tokenBIterator] != 0x0000000000000000000000000000000000000000, "Token B does not have an exchange");
       
        Exchange tokenA_Exchange = Exchange(exchangeAddresses[tokenAIterator]);
        Exchange tokenB_Exchange = Exchange(exchangeAddresses[tokenBIterator]);

        BasicERC20 ERC20TokenA = BasicERC20(_tokenA);
        BasicERC20 ERC20TokenB = BasicERC20(_tokenB);
        
        ERC20TokenA.transferFrom(msg.sender, address(this), _tokenAmount);      
        uint ethRecieved = tokenA_Exchange.tokenToEthSwap(_tokenAmount);

        payable (address(tokenB_Exchange)).transfer(ethRecieved);

        uint tokensRecieved = tokenB_Exchange.ethToTokenSwapNonPayable(ethRecieved);

        ERC20TokenB.transfer(msg.sender, tokensRecieved);
    }

    function returnExchangeAddress(uint id) public view returns(address){
        return exchangeAddresses[id];
    }

    function returnTokenAddress(address _address) public view returns (uint){
        return (tokenExchangeIterator[_address]);
    }

}