// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Marketplace {
    address public multisigContract;

    struct Listing {
        address seller;
        address nftContract;
        uint tokenId;
        uint price;
    }

    mapping(uint256 => Listing) public listings;

    event ItemListed(
        address indexed seller,
        address indexed nftContract,
        uint indexed tokenId,
        uint price
    );

    event ItemBought(
        address indexed buyer,
        address indexed nftContract,
        uint256 indexed tokenId,
        uint256 price
    );

    constructor(address _multisigContract) {
        multisigContract = _multisigContract;
    }

    modifier onlyMultisig() {
        require(msg.sender == multisigContract, "Only multisig is authorized");
        _;
    }

    function listItem(address nftContract, uint tokenId, uint price) external onlyMultisig {
        IERC721 nft = IERC721(nftContract);
        require(nft.ownerOf(tokenId) == msg.sender);

        listings[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            nftContract: nftContract,
            tokenId: tokenId
        });

        emit ItemListed(msg.sender, nftContract, tokenId, price);

    }

    function buyItem(address nftContract, uint tokenId) external payable {
        Listing memory listing = listings[tokenId];
        require(msg.value >= listing.price, "Not enough funds to purchase");

        IERC721(nftContract).safeTransferFrom(listing.seller, msg.sender, tokenId);
        delete listings[tokenId];
        payable(listing.seller).transfer(listing.price);

        emit ItemBought(msg.sender, nftContract, tokenId, listing.price);
    }

}