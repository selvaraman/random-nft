import { ethers } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("Rookie", function () {
  async function deployContract() {
    const Rookie = await ethers.getContractFactory("Rookie");
    const rookie = await Rookie.deploy();
    return rookie;
  }

  describe("Basic", function () {
    it("should return name of the NFT", async function () {
      const contract = await loadFixture(deployContract);
      expect(await contract.name()).to.eq("Rookie");
    });

    it("should return total supply 0", async function () {
      const contract = await loadFixture(deployContract);
      expect(await contract.totalSupply()).to.eq(0);
    });

    it("should mint 10 NFTs", async function () {
      const contract = await loadFixture(deployContract);
      const uris = [
        "1.png",
        "2.png",
        "3.png",
        "4.png",
        "5.png",
        "6.png",
        "7.png",
        "8.png",
        "9.png",
        "10.png",
      ];
      await contract.safeMint(uris);
      expect(await contract.totalSupply()).to.eq(uris.length);
      const l = await ethers.getSigners();
      for (let i = 0; i < uris.length; i++) {
        await contract.assignRandomNft(i, l[i].address);
      }
    });
  });
});
