const { ethers, network } = require("hardhat")
const fs = require("fs")

const FRONT_END_ADDRESSES_FILE = "../WHERE/MUST/SAVE/contractAddress.json" // TODO alter path to save
const FRONT_END_ABI_FILE = "../WHERE/MUST/SAVE/abi.json" // TODO alter path to save
const CONTRACT_NAME = "CONTRACT_NAME" // TODO alter contract name

module.exports = async ()=>{
    if(process.env.UPDATE_FRONT_END){
        console.log('Updating front end...')
        updateContractAddresses()
        updateAbi()
    }
}

const updateAbi = async () => {
    const contract = await ethers.getContract(CONTRACT_NAME) 
    fs.writeFileSync(FRONT_END_ABI_FILE, contract.interface.format(ethers.utils.FormatTypes.json))
}

const updateContractAddresses = async ()=>{
    const contract = await ethers.getContract("Raffle")
    const chainId = network.config.chainId.toString()
    const contractAddress = JSON.parse(fs.readFileSync(FRONT_END_ADDRESSES_FILE, "utf8"))
    if(chainId in contractAddress){
        if (!contractAddress[chainId].includes(contract.address)) {
            contractAddress[chainId].push(contract.address)
        }
    } else {
        contractAddress[chainId] = [contract.address]
    }
    fs.writeFileSync(FRONT_END_ADDRESSES_FILE, JSON.stringify(contractAddress))
}

module.exports.tags = ["all", "frontend"]