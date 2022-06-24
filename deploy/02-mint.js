const { network, ethers } = require("hardhat")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    // Dynamic & Random  NFT
    const safariMixerNFT = await ethers.getContract("SafariMixerNFT", deployer)
    const mintFee = await safariMixerNFT.getMintFee()
    const safariMixerNFTMintTx = await safariMixerNFT.requestNft({ value: mintFee.toString() })
    const safariMixerNFTMintTxReceipt = await safariMixerNFTMintTx.wait(1)
    
    await new Promise(async (resolve) => {
        setTimeout(resolve, 300000) // 5 minute timeout time
        
        safariMixerNFT.once("NftMinted", async () => {
            resolve()
        })
        if (chainId == 31337) {
            const requestId = safariMixerNFTMintTxReceipt.events[1].args.requestId.toString()
            const vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock", deployer)
            await vrfCoordinatorV2Mock.fulfillRandomWords(requestId, safariMixerNFT.address)
        }
    })
    console.log(`NFT index 0 tokenURI: ${await safariMixerNFT.tokenURI(0)}`)
}
module.exports.tags = ["all", "mint"]