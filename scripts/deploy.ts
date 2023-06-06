import { ethers } from "hardhat";

async function main() {
  const Rookie = await ethers.getContractFactory("Rookie");
  const rookie = await Rookie.deploy();

  await rookie.deployed();

  console.log(
    `Contract Address: ${rookie.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
