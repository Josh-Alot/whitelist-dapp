// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Whitelist.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {
   uint256 constant public _price = 0.01 ether; //  _price is the price of one Crypto Dev NFT
   uint256 constant public maxTokensIds = 20; // Max number of Crypto Devs NFTs that can ever exist

   Whitelist whitelist; // imports whitelist contract instance

   uint256 public reservedTokens; // number of tokens reserved for whitelisted members
   uint256 public reservedTokensClaimed = 0; // number of tokens minted

   
    /**
    * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
    * name in our case is `Crypto Devs` and symbol is `CD`.
    * Constructor for Crypto Devs takes in the baseURI to set _baseTokenURI for the collection.
    * It also initializes an instance of whitelist interface.
    */
    constructor(address whitelistContract) ERC721("Crypto Devs", "CD") Ownable(msg.sender) {
        whitelist = Whitelist(whitelistContract);
        reservedTokens = whitelist.maxWhiteListedAddresses();
    }

    function mint() public payable {
        // Make sure we always leave enough room for whitelist reservations
        require(totalSupply() + reservedTokens - reservedTokensClaimed < maxTokensIds, "EXCEEDED_MAX_SUPPLY");

        // If user is part of the whitelist, make sure there is still reserved tokens left
        if (whitelist.whiteListedAddresses(msg.sender) && msg.value < _price) {
            // Make sure user doesn't already own an NFT
            require(balanceOf(msg.sender) == 0, "ALREADY_OWNED");
        } else {
            // If user is not part of the whitelist, make sure they have sent enough ETH
            require(msg.value >= _price, "NOT_ENOUGH_ETHER");
        }

        uint256 tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);
    }


    /**
    * @dev withdraw sends all the ether in the contract
    * to the owner of the contract
    */
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}