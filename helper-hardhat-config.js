const { ethers } = require("hardhat")

const networkConfig = {
    default: {
        name: "hardhat",
    },
    31337: {
        name: "localhost",
    },
    // Price Feed Address, values can be obtained at https://docs.chain.link/docs/reference-contracts
    5: {
        name: "goerli",
    },
    80001: {
        name: "mumbai",
    },
}

const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig,
    developmentChains
}
