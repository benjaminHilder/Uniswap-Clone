pragma solidity 0.8.15;
import "./Exchange.sol";

contract Main {
    //     //token    //exchange
    mapping (address => address) public token_to_exchange;

    mapping (uint => address) public exchangeAddresses;
    mapping (uint => address) public tokenAddresses;
    mapping (address => uint) public tokenExchangeIterator;
    uint iterator;

    constructor() {
        iterator = 1;
    }

    function createExchange(address _tokenAddress) public {
        Exchange newExchange = new Exchange();
        newExchange.setTokenAddress(_tokenAddress);
        exchangeAddresses[iterator] = address(newExchange);
        tokenAddresses[iterator] = _tokenAddress;
        tokenExchangeIterator[_tokenAddress] = iterator;
        iterator++;
    }

    function returnExchangeAddress(uint id) public view returns(address){
        return exchangeAddresses[id];
    }

    function returnTokenAddress(address _address) public view returns (uint){
        return (tokenExchangeIterator[_address]);
    }

}