# SAFARI MIXER NFT SMART CONTRACT

## Introduction

This project builds an **unlimited**, **dynamic**, and **random** (with different chances) generated NFT collection minter smart contract.

Dynamic based on the price of MATIC (binary value based on 1 MATIC >= 1 USD or 1 MATIC < 1 USD).

Chances for random are:
[5, 10, 15, 20, 25, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 72, 76, 80, 83, 86, 89, 91, 93, 95, 97, 99, MAX_CHANCE_VALUE];

For these animals: TORTOISE, FROG, LIZARD, CHICKEN, DUCK, FLAMINGO, BUNNY, SHEEP, CAT, DOG,  PIG, ANTELOPE, FOX, GIRAFFE, OSTRICH, HYENA, CROCODILE, GORILLA, BUFFALO, HIPPO, RHINO,ELEPHANT, PUMA, LEOPARD, TIGER, LION, DINOSAUR, AND UNICORN.


## Smart contract address (Verified)

Contract address: 0x95B4f2897B96e94Ce73aAF1298EaE00Bd01defCb
[Check it here](https://mumbai.polygonscan.com/address/0x95B4f2897B96e94Ce73aAF1298EaE00Bd01defCb)

This project includes the following contracts:
- SafariMixerNFT.sol
- VRFCoordinatorV2Mock.sol (mock)
- MockV3Aggregator.sol (mock)

And scripts with task implementations:
- 00-deploy-mocks.js
- 01-deploy-nft.js
- 02-mint.js


## Setup

First, please clone this repo and install the dependencies with the below commands:

```
git clone https://github.com/ivanmolto/safari-mixer-smart-contracts.git
cd safari-mixer-smart-contracts
npm install
```

To compile run in the terminal the following command:
`npx hardhat compile`

To deploy run in the terminal the following command:
`npx hardhat deploy --network polygonMumbai`

To mint run in the terminal the following command:
`npx hardhat deploy --tags mint --network polygonMumbai`


## OpenSea collection

See NFT collection in OpenSea [here](https://testnets.opensea.io/collection/safarimixernft-utqeajd6wk)


## Images

All images and token URIs are stored in IPFS (used Pinata.cloud) 


## Chainlink Data Feed and Verifiable Random Function

Used Polygon (Matic) Data Feed: 
- MATIC / USD [see here](https://mumbai.polygonscan.com/address/0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada) for getting the NFT images dynamically and imported "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"

Used Chainlink Verifiable Randomness Function: 
As a method to secure randomness for the smart contract getting the images and imported 
- "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol"
- "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol"

Created also the subscription 728 [see here](https://vrf.chain.link/mumbai)


## License

The code is licensed under a MIT License.









