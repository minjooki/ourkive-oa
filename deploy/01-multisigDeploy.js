const { ethers, deployments } = require("hardhat");

async function main() {
    const [owner1, owner2, owner3] = await ethers.getSigners();

    const owners = [
        owner1.address,
        owner2.address,
        owner3.address
    ];

    const multisigFactory = await ethers.getContractFactory("Multisig");

    const multisig = await multisigFactory.deploy(owners);

    console.log("Multisig deployed at:", multisig.address);

    // Save deployment for later use
    await deployments.save("Multisig", {
        address: multisig.address,
        abi: JSON.parse(multisig.interface.format('json')),
    });
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});