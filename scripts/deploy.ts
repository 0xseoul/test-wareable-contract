import { ethers } from "hardhat";
import fs from "fs";

async function main() {
  const wearable721 = await ethers.getContractFactory("WEARABLE721");
  const wearable1155 = await ethers.getContractFactory("WEARABLE1155");
  const itemHandler = await ethers.getContractFactory("ItemHandler");
  const WEARABLE721 = await wearable721.deploy();
  const WEARABLE1155 = await wearable1155.deploy();

  // await greeter.deployed();
  const ITEMHANDLER = await itemHandler.deploy(
    WEARABLE721.address,
    WEARABLE721.address
  );

  console.log("WEARABLE721", WEARABLE721.address);
  console.log("WEARABLE1155", WEARABLE1155.address);
  console.log("ITEMHANDLER", ITEMHANDLER.address);
  // make config json
  const config = {
    WEARABLE721: WEARABLE721.address,
    WEARABLE1155: WEARABLE1155.address,
    ITEMHANDLER: ITEMHANDLER.address,
  };
  fs.writeFileSync("config.json", JSON.stringify(config));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
