// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/CryptoDevs.sol";

contract DeployScript is Script {
    function run() external {
        string memory privateKeyStr = vm.envString("PRIVATE_KEY");
        uint256 deployerPrivateKey = vm.parseUint(string.concat("0x", privateKeyStr));
        address whitelistContract = 0x83d344c5275EfE06db360B71E47DD39f9eFF0a92;
        
        vm.startBroadcast(deployerPrivateKey);
        
        CryptoDevs cryptoDevs = new CryptoDevs(whitelistContract);
        
        vm.stopBroadcast();
        
        console.log("CryptoDevs deployed to:", address(cryptoDevs));
    }
} 