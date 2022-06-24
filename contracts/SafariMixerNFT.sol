// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

error AlreadyInitialized();
error NeedMoreMATICSent();
error RangeOutOfBounds();

contract SafariMixerNFT is ERC721URIStorage, VRFConsumerBaseV2, Ownable {

  AggregatorV3Interface internal immutable i_priceFeed;
  
  enum Specie {
    TORTOISE,
    FROG,
    LIZARD,
    CHICKEN,
    DUCK,
    FLAMINGO,
    BUNNY,
    SHEEP,
    CAT,
    DOG,
    PIG,
    ANTELOPE,
    FOX,
    GIRAFFE,
    OSTRICH,
    HYENA,
    CROCODILE,
    GORILLA,
    BUFFALO,
    HIPPO,
    RHINO,
    ELEPHANT,
    PUMA,
    LEOPARD,
    TIGER,
    LION, 
    DINOSAUR,
    UNICORN
  }

  // Chainlink VRF Variables
  VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
  uint64 private immutable i_subscriptionId;
  bytes32 private immutable i_gasLane;
  uint32 private immutable i_callbackGasLimit;
  uint16 private constant REQUEST_CONFIRMATIONS = 3;
  uint32 private constant NUM_WORDS = 1;
  
  
  // NFT Variables 
  uint256 private i_mintFee; 
  uint256 public s_tokenCounter;
  mapping(uint256 => Specie) private s_tokenIdToSpecie;
  uint256 internal constant MAX_CHANCE_VALUE = 100;
  string[] internal s_animalTokenUris;
  bool private s_initialized;

  // VRF Helpers
  mapping(uint256 => address) public s_requestIdToSender;

  // Events
  event NftRequested(uint256 indexed requestId, address requester);
  event NftMinted(Specie specie, address minter);

  constructor(
    address priceFeedAddress,
    address vrfCoordinatorV2,
    uint64 subscriptionId,
    bytes32 gasLane,
    uint256 mintFee,
    uint32 callbackGasLimit,
    string[56] memory animalTokenUris
  ) VRFConsumerBaseV2(vrfCoordinatorV2) ERC721 ("SafariMixerNFT", "SAFARIMIXER") {
    i_priceFeed = AggregatorV3Interface(priceFeedAddress);
    i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
    i_gasLane = gasLane;
    i_subscriptionId = subscriptionId;
    i_mintFee = mintFee;
    i_callbackGasLimit = callbackGasLimit;
    _initializeContract(animalTokenUris);
  }

  function requestNft() public payable returns (uint256 requestId) {
    if (msg.value < i_mintFee) {
      revert NeedMoreMATICSent();
    }
    requestId = i_vrfCoordinator.requestRandomWords(
      i_gasLane, 
      i_subscriptionId, 
      REQUEST_CONFIRMATIONS, 
      i_callbackGasLimit, 
      NUM_WORDS
    );

    s_requestIdToSender[requestId] = msg.sender;
    emit NftRequested(requestId, msg.sender);
  }

  function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
    (, int256 price, , , ) = i_priceFeed.latestRoundData();
    address animalOwner = s_requestIdToSender[requestId];
    uint256 newItemId = s_tokenCounter;
    s_tokenCounter = s_tokenCounter + 1;
    uint256 moddedRng = randomWords[0] % MAX_CHANCE_VALUE;
    Specie animalSpecie = getSpecieFromModdedRng(moddedRng);
    _safeMint(animalOwner, newItemId);
    if (price >= 1){
      price = 1;
    } else { 
      price = 0;
    }
    _setTokenURI(newItemId, s_animalTokenUris[uint256(price) + 2 * uint256(animalSpecie)]);
    emit NftMinted(animalSpecie, animalOwner);
  }

  function getChangeArray() public pure returns (uint256[28] memory) {
    return [5, 10, 15, 20, 25, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 72, 76, 80, 83, 86, 89, 91, 93, 95, 97, 99, MAX_CHANCE_VALUE];
  }

  function _initializeContract(string[56] memory animalTokenUris) private {
    
    if (s_initialized) {
      revert AlreadyInitialized();
    }
    s_animalTokenUris = animalTokenUris;
    s_initialized = true;
  }

  function getSpecieFromModdedRng(uint256 moddedRng) public pure returns (Specie) {
    uint256 cumulativeSum = 0;
    uint256[28] memory chanceArray = getChangeArray();
    for (uint256 i = 0; i < chanceArray.length; i++) {
      if (moddedRng >= cumulativeSum && moddedRng < cumulativeSum + chanceArray[i]) {
        return Specie(i);
      }
      cumulativeSum = cumulativeSum + chanceArray[i];
    }
    revert RangeOutOfBounds();
  }

  function withdraw() public onlyOwner {
    uint256 amount = address(this).balance;
    (bool success, ) = payable(msg.sender).call{value: amount}("");
    require(success, "Transfer failed");
  }

  function getMintFee() public view returns (uint256) {
    return i_mintFee;
  }

  function getAnimalTokenUris(uint256 index) public view returns (string memory) {
    return s_animalTokenUris[index];
  }

  function getInitialized() public view returns (bool) {
    return s_initialized;
  }

  function getTokenCounter() public view returns (uint256) {
    return s_tokenCounter;
  }
}