const { expect } = require("chai");
const { ethers } = require("hardhat");

describe ("testing the main contract", async() => {
    let Main;
    let main;
    let ExchangeContract;

    let ERC20_1;
    let erc20_1;

    let ERC20_2;
    let erc20_2;

    let acc1;
    let acc2

    beforeEach(async() => {
    [acc1, acc2] = await ethers.getSigners();

    Main = await ethers.getContractFactory("Main");
    main = await Main.deploy();
    await main.deployed();

    ERC20_1 = await ethers.getContractFactory("BasicERC20");
    erc20_1 = await ERC20_1.deploy("ERC20_1", "Token1", acc1.address, 1000);
    await erc20_1.deployed();

    ERC20_2 = await ethers.getContractFactory("BasicERC20");
    erc20_2 = await ERC20_1.deploy("ERC20_2", "Token2", acc1.address, 1000);
    await erc20_2.deployed();

    ExchangeContract = await ethers.getContractFactory("Exchange")
    BasicERC20Contract = await ethers.getContractFactory("BasicERC20")
    })

    it("should console log the address for exchange", async () => {
        const provider = waffle.provider;

        await main.createExchange(erc20_1.address);
        ERC20_1ExchangeAddress = await main.returnExchangeAddress(1);
        ERC20_1TokenAddress = await main.returnTokenAddress(erc20_1.address)

        await console.log("ERC20 1 address: " + erc20_1.address)
        await console.log("ERC20 1 Exchange Address: " + ERC20_1ExchangeAddress)

        let returnAddress1 = await main.returnTokenAddress(erc20_1.address);
        console.log('return address: ' + returnAddress1)
        expect (returnAddress1 == 1);

        let exchangeInstance1 = await ExchangeContract.attach(ERC20_1ExchangeAddress);

        let tokenAddressInExchange = await exchangeInstance1.tokenAddress();
        console.log("token address in exchange " + tokenAddressInExchange);
        expect (tokenAddressInExchange == ERC20_1ExchangeAddress)
        
        //let bal = await provider.getBalance(acc1.address);
        //console.log("balance: " + bal);
//
        //await acc1.sendTransaction({ 
        //    to: acc2.address, 
        //    value: 1
        //});
        //bal = await provider.getBalance(acc1.address);
        //console.log("balance: " + bal);
        let tokenBalance = await erc20_1.balanceOf(acc1.address);
        console.log("token balance: " + tokenBalance)

        let ethBalance = await provider.getBalance(acc1.address);
        console.log("eth balance: " + ethBalance);

        await erc20_1.connect(acc1).approve(exchangeInstance1.address, 1000)

        await exchangeInstance1.connect(acc1).addLiquidity(100, {value: 1});

        tokenBalance = await erc20_1.balanceOf(acc1.address);
        console.log("token balance: " + tokenBalance)

        ethBalance = await provider.getBalance(acc1.address);
        console.log("eth balance: " + ethBalance);


        //let tokenBalance = await exchangeInstance1.getTokenBalance();
        //console.log("token balance: " + tokenBalance);

    })
})