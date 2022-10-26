require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-etherscan")
require("hardhat-deploy")
require("solidity-coverage")
require("hardhat-gas-reporter")
require("hardhat-contract-sizer")
require("dotenv").config()

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY
const MUMBAI_RPC_URL = process.env.MUMBAI_RPC_URL
const MUMBAI_PRIVATE_KEY = process.env.MUMBAI_PRIVATE_KEY
const POLYGON_RPC_URL = process.env.POLYGON_RPC_URL
const POLYGON_PRIVATE_KEY = process.env.POLYGON_PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const COIN_MARKET_CAP = process.env.COIN_MARKET_CAP

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: {
        compilers: [{ version: "0.8.8" }, { version: "0.6.6" }],
    },
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            blockConfirmations: 1,
        },
        goerli: {
            url: GOERLI_RPC_URL,
            accounts: [GOERLI_PRIVATE_KEY],
            chainId: 5,
            blockConfirmations: 6,
        },
        mumbai: {
            url: MUMBAI_RPC_URL,
            accounts: [MUMBAI_PRIVATE_KEY],
            chainId: 5,
            blockConfirmations: 6,
        },
        polygon: {
            url: POLYGON_RPC_URL,
            accounts: [POLYGON_PRIVATE_KEY],
            chainId: 5,
            blockConfirmations: 6,
        },
    },
    etherscan: {
        // Your API key for Etherscan
        // Obtain one at https://etherscan.io/
        apiKey: ETHERSCAN_API_KEY,
    },
    gasReporter: {
        enabled: true,
        outputFile: "gas-reporter.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: COIN_MARKET_CAP,
        token: "MATIC",
    },
    namedAccounts: {
        deployer: {
            default: 0,
        },
        player: {
            default: 1,
        },
    },
    mocha: {
        timeout: 300000, // 300 seconds
    },
}
