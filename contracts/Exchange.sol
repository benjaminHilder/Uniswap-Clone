pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange {
    address deployer;
    address public tokenAddress;

    uint ethBalance;
    uint tokenBalance;

    function addLiquidity(uint _tokenAmount) public payable {
        ERC20 ERC20Token = ERC20(tokenAddress);
        //require(ERC20Token.balanceOf(msg.sender) <= _tokenAmount);
        
        ethBalance += msg.value;
        tokenBalance += _tokenAmount;
        ERC20Token.transferFrom(msg.sender, address(this), _tokenAmount);
    }

    constructor () {
        deployer = msg.sender;
    }
    function setTokenAddress(address _tokenAddress) public {
        require(msg.sender == deployer, "only deployer can call this function");
        tokenAddress = _tokenAddress;
    }

    function getEthBalance() public view returns(uint) {
        return ethBalance;
    }

    function getTokenBalance() public view returns(uint) {
        return tokenBalance;
    }
}