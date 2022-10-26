require("dotenv").config()
const { network, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

// Constants
const CONTRACT_NAME = "SmartCupBet" // insert here the name of your contract

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let maticUsdPriceFeedAddress

    if (developmentChains.includes(network.name)) {
        const ethUsdAggregator = await get("MockV3Aggregator")
        maticUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        maticUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }

    const args = [maticUsdPriceFeedAddress]

    const contract = await deploy(CONTRACT_NAME, {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...")
        await verify(contract.address, args)
    }
    log("---------------------------------------------------")
}

module.exports.tags = ["all", "contract"]
