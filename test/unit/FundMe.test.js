const { assert } = require("chai")
const { deployment, ether, getNamedAccounts } = require("hardhat")

describe("FundMe", async function() {
    let fundMe
    let deployer
    let MockV3Aggregator
    beforeEach(async function() {
        // deploy our fundMe contract
        // using Hardhat-deploy
        // const account = await ethers.getSigners()
        // const accountZero = accounts[0]
        deployer = (await getNamedAccounts()).deployer
        const { deployer } = await getNamedAccounts()
        await deployment.fixture(["all"])
        fundMe = await ethers.getContract("FundMe")
        MockV3Aggregator = await ethers.getContract(
            "MockV3Aggregator",
            deployer
        )
    })

    describe("constructor", async function() {
        it("Sets the aggregator addresses correctly", async function() {
            const response = await fundMe.priceFeed()
            assert.equal(response, MockV3Aggregator.address)
        })
    })
})
