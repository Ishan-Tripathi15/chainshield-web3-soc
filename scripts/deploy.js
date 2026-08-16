const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const Registry = await hre.ethers.getContractFactory("SecurityRegistry");
  const registry = await Registry.deploy(deployer.address);
  await registry.waitForDeployment();

  console.log("ChainShield SecurityRegistry deployed to:", await registry.getAddress());
  console.log("Admin:", deployer.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});