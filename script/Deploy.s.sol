// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/CreatorToken.sol";
import "../src/ArtNFT.sol";

contract Deploy is Script {
    function run() external {
        // Broadcast transactions
        vm.startBroadcast();

        // Deploy CreatorToken
        CreatorToken token = new CreatorToken();

        // Deploy ArtNFT with address of CreatorToken
        ArtNFT nft = new ArtNFT(address(token));

        // Transfer ownership of the token to the NFT contract
        token.transferOwnership(address(nft));

        vm.stopBroadcast();
    }
}
