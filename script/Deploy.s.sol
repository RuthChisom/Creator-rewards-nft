// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/CreatorToken.sol";
import "../src/ArtNFT.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy CreatorToken
        CreatorToken creatorToken = new CreatorToken();

        // Deploy ArtNFT with CreatorToken address
        ArtNFT artNFT = new ArtNFT(address(creatorToken));

        // Transfer ownership of CreatorToken to ArtNFT (optional, recommended)
        creatorToken.transferOwnership(address(artNFT));

        vm.stopBroadcast();

        // Log addresses
        console.log("CreatorToken deployed at:", address(creatorToken));
        console.log("ArtNFT deployed at:", address(artNFT));
    }
}
