// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.19;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// contract ArtNFTPlatform is ERC20, ERC721, Ownable {
//     uint256 private _tokenIds;
//     uint256 public constant CREATOR_REWARD = 100 * 10 ** 18; // 100 tokens, 18 decimals

//     // tokenId => creator address
//     mapping(uint256 => address) public creators;

//     // tokenId => metadata URI
//     mapping(uint256 => string) private _tokenURIs;

//     event NFTMinted(address indexed creator, uint256 indexed tokenId);

//     constructor() ERC20("CreatorToken", "CRT") ERC721("ArtNFT", "ART") Ownable() {
//         // Optionally mint initial tokens to owner here, or none for incremental supply
//     }

//     // Mint NFT with metadata URI
//     function mintNFT(string memory tokenURI_) external returns (uint256) {
//         _tokenIds++;
//         uint256 newItemId = _tokenIds;

//         _safeMint(msg.sender, newItemId);
//         _setTokenURI(newItemId, tokenURI_);

//         creators[newItemId] = msg.sender;

//         // Reward the creator with ERC20 tokens
//         _mint(msg.sender, CREATOR_REWARD);

//         emit NFTMinted(msg.sender, newItemId);

//         return newItemId;
//     }

//     // === Token URI handling ===
//     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
//         require(_exists(tokenId), "URI set of nonexistent token");
//         _tokenURIs[tokenId] = _tokenURI;
//     }

//     function tokenURI(uint256 tokenId) public view override returns (string memory) {
//         require(_exists(tokenId), "URI query for nonexistent token");
//         return _tokenURIs[tokenId];
//     }

//     // === Overrides to resolve conflicts ===

//     // ERC20 transferFrom (with amount)
//     function transferFrom(address from, address to, uint256 amount) public override(ERC20) returns (bool) {
//         return ERC20.transferFrom(from, to, amount);
//     }

//     // ERC721 transferFrom (with tokenId)
//     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721) {
//         ERC721.transferFrom(from, to, tokenId);
//     }

//     // _burn override for ERC721
//     function _burn(uint256 tokenId) internal override(ERC721) {
//         super._burn(tokenId);
//         // Clean up tokenURI storage
//         if (bytes(_tokenURIs[tokenId]).length != 0) {
//             delete _tokenURIs[tokenId];
//         }
//     }

//     // _beforeTokenTransfer override to satisfy compiler (ERC20 & ERC721)
//     function _beforeTokenTransfer(address from, address to, uint256 amountOrTokenId) internal override(ERC20, ERC721) {
//         super._beforeTokenTransfer(from, to, amountOrTokenId);
//     }
// }
