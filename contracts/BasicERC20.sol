// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BasicERC20 is ERC20, Ownable {
    constructor(string memory _name, string memory _ticker, address _tokenHolder, uint _supply) ERC20(_name, _ticker) {
        _mint(_tokenHolder, _supply);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}