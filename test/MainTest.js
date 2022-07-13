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

    it("Should be able to create an exchange contract and return its address", async() => {
        await main.createExchange(erc20_1.address);

        ERC20_1ExchangeAddress = await main.returnExchangeAddress(1);
  

        expect(await String(ERC20_1ExchangeAddress)).to.not.equal("0x0000000000000000000000000000000000000000")
    })

    it("Should be able to create an exchange and deposit liquidity of selected token", async() => {
        await main.createExchange(erc20_1.address);

        ERC20_1ExchangeAddress = await main.returnExchangeAddress(1);
        ERC20_1TokenAddress = await main.returnTokenAddress(erc20_1.address)

        let exchangeInstance = await ExchangeContract.attach(ERC20_1ExchangeAddress);

        await erc20_1.connect(acc1).approve( exchangeInstance.address, 1000);
        await exchangeInstance.connect(acc1).addLiquidity(100, {value: 100});

        expect (await exchangeInstance.getEthBalance()).to.not.equal(0);
        expect (await exchangeInstance.getTokenBalance()).to.not.equal(0);
    })
})