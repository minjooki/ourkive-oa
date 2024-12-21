// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NewItem is ERC721URIStorage {
    uint private tokenIdCounter;
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

    function mint(address to, string memory tokenURI) public onlyMultisig {
        uint tokenId = tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);

        tokenIdCounter += 1;
        emit MintRequested(to, tokenId);
    }

    function setMultisigContract(address _multisigContract) external {
        multisigContract = _multisigContract;
    }
}