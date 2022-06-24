const networkConfig = {
  31337: {
      name: "localhost",
      gasLane: "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc", 
      mintFee: "10000000000000000", 
      callbackGasLimit: "500000", 
  },
  
  80001: {
      name: "polygonMumbai",
      maticUsdPriceFeed: "0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada",
      vrfCoordinatorV2: "0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed",
      gasLane: "0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f",
      callbackGasLimit: "500000", 
      mintFee: "100000000000000000", // 0.1 MATIC
      subscriptionId: "728", 
  },
}

const DECIMALS = "18"
const INITIAL_PRICE = "200000000000000000000"
const developmentChains = ["hardhat", "localhost"]

module.exports = {
  networkConfig,
  developmentChains,
  DECIMALS,
  INITIAL_PRICE,
}