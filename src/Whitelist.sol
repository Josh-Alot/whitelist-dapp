// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Whitelist {
    // max number of whitelisted addresses allowed
    uint public maxWhiteListedAddresses;

    // mapping of whitelisted addresses
    // if an address is whitelisted, we would set it to true, it is false by default for all other addresses.
    mapping(address => bool) public whiteListedAddresses;
    
    // would be used to keep track of how many addresses have been whitelisted
    uint public numAddressesWhitelisted;

    // Setting the Max number of whitelisted addresses
    // User will put the value at the time of deployment
    constructor(uint8 _maxWhiteListedAddresses) {
        maxWhiteListedAddresses = _maxWhiteListedAddresses;
    }

    /**
        addAddressToWhitelist - This function adds the address of the sender to the
        whitelist
     */
    function addAddressToWhiteList() public {
        // first check if the address is already whitelisted
        require(!whiteListedAddresses[msg.sender], "Sender has already been whitelisted");

        // check if the number of whitelisted addresses has reached the max
        require(numAddressesWhitelisted < maxWhiteListedAddresses, "More addresses cant be added, limit reached");

        // add the address to the whitelist and increment the number of whitelisted addresses
        whiteListedAddresses[msg.sender] = true;
        numAddressesWhitelisted++;
    }
}