const { ethers } = require("hardhat");

describe("MyERC20 Test", function () {
    it("Should deploy and test MyERC20 contract", async function () {
        const MyERC20 = await ethers.getContractFactory("MyERC20");
        const initialSupply = ethers.parseEther("1000");
        const myERC20 = await MyERC20.deploy(initialSupply);
        await myERC20.waitForDeployment();
        console.log("MyERC20 deployed to:", await myERC20.getAddress());
    })


})