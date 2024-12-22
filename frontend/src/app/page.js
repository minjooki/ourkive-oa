"use client";

import { useState, useEffect } from "react";
import { ethers } from "ethers";
import Link from 'next/link';

function ConnectWalletButton() {
  const [account, setAccount] = useState(null);
  const [error, setError] = useState(null);

  const connectWallet = async () => {
    try {
      if (typeof window.ethereum !== "undefined") {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const accounts = await provider.send("eth_requestAccounts", []);
        setAccount(accounts[0]); 
        setError(null); 
      } else {
        setError("MetaMask is not installed.");
      }
    } catch (err) {
      setError("An error occurred while connecting.");
      console.error(err);
    }
  };

  return (
    <div>
      {account ? (
        <p>Connected: {account}</p>
      ) : (
        <button onClick={connectWallet}>Connect Wallet</button>
      )}
      {error && <p style={{ color: "red" }}>{error}</p>}
    </div>
  );
}

function Navbar() {
  return (
    <nav style={{ padding: "10px", display: "flex", justifyContent: "space-between" }}>
      <h1>NFT Marketplace</h1>
      <ConnectWalletButton />
    </nav>
  );
}

export default function Home() {
  const [nfts, setNfts] = useState([]);
  const nftContractAddress = process.env.NEXT_PUBLIC_NFT_CONTRACT_ADDRESS;

  async function loadNFTs() {
    if (!window.ethereum) return alert("MetaMask is required!");
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const nftContract = new ethers.Contract(
      nftContractAddress,
      [
        "function mint(address to, string memory tokenURI) public",
        "function setMultisigContract(address _multisigContract) external"
      ],
      signer
    );

    const address = await signer.getAddress();
    const balance = await nftContract.balanceOf(address);

    const nftsData = [];
    for (let i = 0; i < balance; i++) {
      const tokenId = await nftContract.tokenOfOwnerByIndex(address, i);
      const tokenURI = await nftContract.tokenURI(tokenId);
      nftsData.push({ tokenId: tokenId.toString(), tokenURI });
    }
    setNfts(nftsData);
  }

  useEffect(() => {
    loadNFTs();
  }, []);

  return (
    <div>
      <Navbar />
      <div style={{ padding: 20 }}>
        <h1>Your NFTs</h1>
        {nfts.length === 0 ? (
          <p>No NFTs found</p>
        ) : (
          nfts.map((nft) => (
            <div key={nft.tokenId} style={{ marginBottom: "10px" }}>
              <h3>Token ID: {nft.tokenId}</h3>
              <img src={nft.tokenURI} alt="NFT" style={{ maxWidth: "200px" }} />
            </div>
          ))
        )}
        <Link href="/sell">
          <button>Go to Sell Page</button>
        </Link>
      </div>
    </div>
  );
}
