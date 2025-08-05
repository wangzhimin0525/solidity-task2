// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721Enumerable, Ownable {

    uint256 private _tokenIdCounter;

    mapping(uint256 => string) private _tokenURIs;

    constructor() ERC721("MyNFT", "MNFT") Ownable(msg.sender) {}


    function mintNFT(address to, string memory _tokenURI) public onlyOwner returns (uint256) {
        require(to != address(0), "Cannot mint to the zero address");
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        _tokenIdCounter++;

        return tokenId;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal {
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return _tokenURIs[tokenId];
    }
}