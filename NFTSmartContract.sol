// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract NewItem is ERC721 {
    uint private _tokenIdCounter;

    constructor() ERC721("NewItem", "MNFT") {
    }

    function mint(address to, string tokenURI) public {
        uint tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);

        _tokenIdCounter += 1;
    }
}