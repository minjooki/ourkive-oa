"use client";

import { useState } from "react";
import { ethers } from "ethers";

export default function Sell() {
  const [tokenId, setTokenId] = useState("");
  const [price, setPrice] = useState("");
  const marketplaceAddress = process.env.NEXT_PUBLIC_MARKETPLACE_CONTRACT_ADDRESS;

  async function listNFT() {
    if (!window.ethereum) return alert("MetaMask is required!");
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const marketplaceContract = new ethers.Contract(
      marketplaceAddress,
      [
        "function listItem(address nftContract, uint tokenId, uint price) public",
      ],
      signer
    );

    const nftAddress = process.env.NEXT_PUBLIC_NFT_CONTRACT_ADDRESS;
    await marketplaceContract.listItem(nftAddress, tokenId, ethers.utils.parseEther(price));
  }

  return (
    <div style={{ padding: 20 }}>
    <h1>List NFT for Sale</h1>
    <input
        type="text"
        placeholder="Token ID"
        value={tokenId}
        onChange={(e) => setTokenId(e.target.value)}
    />
    <input
        type="text"
        placeholder="Price in ETH"
        value={price}
        onChange={(e) => setPrice(e.target.value)}
    />
    <button onClick={listNFT}>List NFT</button>
    </div>
  );
}
