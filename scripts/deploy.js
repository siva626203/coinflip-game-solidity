const hre = require("hardhat");

async function main() {
  const CoinFlip = await hre.ethers.getContractFactory("CoinFlip");
  const coinflip = await CoinFlip.deploy();

  await coinflip.deployed();

  console.log("CoinFlip deployed to:", coinflip.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
