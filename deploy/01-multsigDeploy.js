const { ethers, deployments, getNamedAccounts } = require("hardhat");

async function main() {
    const { deployer } = await getNamedAccounts();
    const { deploy } = deployments;
    const [owner2, owner3] = await ethers.getSigners();

    const owners = [
        deployer,
        "0xAddress1", // Replace with actual addresses
        "0xAddress2"
    ];

    const requiredApprovals = 2;

    const multisig = await deploy("Multisig", {
        from: deployer,
        args: [owners, requiredApprovals],
        log: true,
    });

    console.log("Multisig deployed at:", multisig.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});