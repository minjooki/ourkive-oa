const { ethers, deployments } = require("hardhat");

async function main() {
    const multisigAddress = (await deployments.get("Multisig")).address;
    console.log("Multisig contract address:", multisigAddress);

    const marketplaceFactory = await ethers.getContractFactory("Marketplace");
    const marketplace = await marketplaceFactory.deploy(multisigAddress);
    console.log("Marketplace contract deployed at:", marketplace.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});