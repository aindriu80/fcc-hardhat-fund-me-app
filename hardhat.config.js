// require("dotenv").config()
require("@nomiclabs/hardhat-etherscan")
// require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("solidity-coverage")
require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy")

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.8",
    defaultNetwork: "hardhat",
    networks: {
        ropsten: {
            url: process.env.ROPSTEN_URL || "",
            accounts: []
        }
    },
    gasReporter: {
        enabled: process.env.REPORT_GAS !== undefined,
        currency: "USD"
    },
    etherscan: {
        apiKey: process.env.EtherscanAPI_KEY
    },
    namedAcccounts: {
        deployer: {
            default: 0
        },
        users: {
            default: 1
        }
    }
}
