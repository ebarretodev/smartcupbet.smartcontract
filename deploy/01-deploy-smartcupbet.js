require("dotenv").config()
const { network, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

// Constants
const CONTRACT_NAME = "SmartCupBet" // insert here the name of your contract

module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let maticUsdPriceFeedAddress

    if (developmentChains.includes(network.name)) {
        const maticUsdAggregator = await get("MockV3Aggregator")
        maticUsdPriceFeedAddress = maticUsdAggregator.address
    } else {
        maticUsdPriceFeedAddress = networkConfig[chainId]["maticUsdPriceFeed"]
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
