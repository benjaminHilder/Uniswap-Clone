pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange {
    address deployer;
    address public tokenAddress;

    uint ethBalance;
    uint tokenBalance;

    constructor (address _tokenAddress) {
        deployer = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function addLiquidity(uint _tokenAmount) public payable {
        ERC20 ERC20Token = ERC20(tokenAddress);
        
        ethBalance += msg.value;
        tokenBalance += _tokenAmount;
        ERC20Token.transferFrom(msg.sender, address(this), _tokenAmount);
    }

    function ethToTokenSwap() public payable {
        ERC20 ERC20Token = ERC20(tokenAddress);

        uint invariant = ethBalance * tokenBalance;
        ethBalance += msg.value;
        uint tokenBalDifference = invariant / ethBalance;
        uint tokensOut = tokenBalance - tokenBalDifference;
        tokenBalance -= tokensOut;
        
        ERC20Token.transfer(msg.sender, tokensOut);
    }

    function tokenToEthSwap(uint _tokenAmount) public {
        //user must approve this contract and token amount before calling this function
        ERC20 ERC20Token = ERC20(tokenAddress);

        ERC20Token.transferFrom(msg.sender, address(this), _tokenAmount);

        uint invariant = ethBalance * tokenBalance;
        tokenBalance += _tokenAmount;
        uint ethBalDifference = invariant / tokenBalance;
        uint ethOut = ethBalance - ethBalDifference;

        ethBalance -= ethOut;

        payable(msg.sender).transfer(ethOut);
    }

    function getEthBalance() public view returns(uint) {
        return ethBalance;
    }

    function getTokenBalance() public view returns(uint) {
        return tokenBalance;
    }

}