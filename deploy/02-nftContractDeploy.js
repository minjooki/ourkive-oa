const { deployments, ethers } = require("hardhat");

async function main() {

    const multisigAddress = (await deployments.get("Multisig")).address;
    console.log("Multisig contract address:", multisigAddress);

    const nftFactory = await ethers.getContractFactory("NewItem");
    const nft = await nftFactory.deploy(multisigAddress);
    console.log("NFT contract deployed at:", nft.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});