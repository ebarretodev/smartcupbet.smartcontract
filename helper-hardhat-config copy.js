const { ethers } = require("hardhat")

const networkConfig = {
    default: {
        name: "hardhat",
        keepersUpdateInterval: "30",
    },
    31337: {
        name: "localhost",
        entranceFee: ethers.utils.parseEther("0.01"),
        subscriptionId: "588",
        gasLane: "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc", // 30 gwei
        callbackGasLimit: "500000",
        interval: "30",
    },
    // Price Feed Address, values can be obtained at https://docs.chain.link/docs/reference-contracts
    5: {
        name: "goerli",
        entranceFee: ethers.utils.parseEther("0.01"),
        //Need for VRF
        vrfCoordinatorV2address: "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D",
        gasLane: "0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15",
        subscriptionId: "4242",
        //Need for keepers
        callbackGasLimit: "500000",
        interval: "30",
    },
    80001: {
        name: "mumbai",
        vrfCoordinatorV2address: "0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed",
    },
}

const developmentChains = ["hardhat", "localhost"]
const DECIMALS = 8
const INITIAL_ANSWER = 20000000000

module.exports = {
    networkConfig,
    developmentChains,
    DECIMALS,
    INITIAL_ANSWER,
}
