const { ethers, getNamedAccounts } = require("hardhat")

const CONTRACT_NAME = "SmartCupBet"

async function logicTest() {
    const { deployer } = await getNamedAccounts()
    const contract = await ethers.getContract(CONTRACT_NAME, deployer)
    console.log("---------------------------------")
    console.log(`Contract deployed and ready to use on address: ${contract.address}`)
    console.log("---------------------------------")
    // Insert here the logic you want
    const tx1 = await contract.getMatchState(1)
    console.log(tx1.toString())

    const tx2 = await contract.closeMatch(1)
    console.log(tx2)

    const tx3 = await contract.getMatchState(1)
    console.log(tx3.toString())
}

logicTest()
    .then(() => {        
        console.log("---------------------------------")
        console.log("Script Finish without error.")
        console.log("---------------------------------")
        process.exit(0)
    })
    .catch((error) => {
        console.log("---------------------------------")
        console.log("Script finish with error")
        console.log("---------------------------------")

        console.error(error)
        process.exit(1)
    })
