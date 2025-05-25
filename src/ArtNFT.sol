// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ICreatorToken {
    function mint(address to, uint256 amount) external;
}

contract ArtNFT is ERC721, Ownable {
    uint256 private _tokenIds;
    uint256 public constant REWARD_AMOUNT = 100 * 10 ** 18;

    ICreatorToken public creatorToken;

    mapping(uint256 => address) public creators;
    mapping(uint256 => string) private _tokenURIs;

    event NFTMinted(address indexed creator, uint256 indexed tokenId);

    constructor(address creatorTokenAddress) ERC721("ArtNFT", "ART") {
        creatorToken = ICreatorToken(creatorTokenAddress);
    }

    function mintNFT(string memory tokenURI_) external returns (uint256) {
        _tokenIds++;
        uint256 newItemId = _tokenIds;

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI_);

        creators[newItemId] = msg.sender;

        creatorToken.mint(msg.sender, REWARD_AMOUNT);

        emit NFTMinted(msg.sender, newItemId);

        return newItemId;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        require(_exists(tokenId), "URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }
}
