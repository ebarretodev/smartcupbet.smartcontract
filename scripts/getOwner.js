const { ethers, getNamedAccounts } = require("hardhat")

const CONTRACT_NAME = "SmartCupBet"

async function logicTest() {
    const { deployer } = await getNamedAccounts()
    const contract = await ethers.getContract(CONTRACT_NAME, deployer)
    console.log(`Contract deployed and ready to use on address: ${contract.address}`)
    // Insert here the logic you want
    const tx = await contract.getOwner()
    console.log(tx)
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
