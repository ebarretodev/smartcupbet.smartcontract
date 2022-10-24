const { ethers } = require("hardhat")

const CONTRACT_NAME = "SmartCupBet"

async function logicTest() {
    const contract = await ethers.getContract(CONTRACT_NAME)
    console.log(`Contract deployed and ready to use on address: ${contract.address}`)
    // Insert here the logic you want
}

logicTest()
    .then(() => {
        process.exit(0)
        console.log("---------------------------------")
        console.log("Script Finish without error.")
        console.log("---------------------------------")
    })
    .catch((error) => {
        console.log("---------------------------------")
        console.log("Script finish with error")
        console.log("---------------------------------")

        console.error(error)
        process.exit(1)
    })
