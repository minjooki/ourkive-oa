// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NewItem is ERC721, Ownable {
    uint private _tokenIdCounter;
    address public multisigContract;

    event MintRequested(address to, uint tokenId);

    modifier onlyMultisig() {
        require(msg.sender == multisigContract, "Only multisig is authorized to mint");
        _;
    }

    constructor(address _multisigContract) ERC721("NewItem", "MNFT") {
        tokenIdCounter = 1;
        multisigContract = _multisigContract;
    }

    function mint(address to, string tokenURI) public onlyMultisig {
        uint tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);

        _tokenIdCounter += 1;
        emit MintRequested(to, tokenId);
    }

    function setMultisigContract(address _multisigContract) external onlyOwner {
        multisigContract = _multisigContract;
    }
}