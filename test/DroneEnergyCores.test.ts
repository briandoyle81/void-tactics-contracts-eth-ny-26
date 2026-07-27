import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import hre from "hardhat";
import { parseEther } from "viem";
import { deployShipsFixture } from "./fixtures/deployShipsFixture";

describe("DroneEnergyCores", function () {
  describe("Minting", function () {
    it("Should revert mint from an unauthorized address", async function () {
      const { droneEnergyCores, owner, user1 } =
        await loadFixture(deployShipsFixture);

      await droneEnergyCores.write.setMintIsActive([true], {
        account: owner.account,
      });

      await expect(
        droneEnergyCores.write.mint([user1.account.address, parseEther("1")], {
          account: user1.account,
        }),
      ).to.be.rejectedWith("NotAuthorized");
    });

    it("Should revert mint when minting is not active", async function () {
      const { droneEnergyCores, owner, user1 } =
        await loadFixture(deployShipsFixture);

      // The deploy script itself activates minting (so Ships can pay DEC
      // rewards out of the box) — explicitly turn it back off to exercise
      // this revert path.
      await droneEnergyCores.write.setMintIsActive([false], {
        account: owner.account,
      });
      await droneEnergyCores.write.setAuthorizedToMint(
        [owner.account.address, true],
        { account: owner.account },
      );

      await expect(
        droneEnergyCores.write.mint([user1.account.address, parseEther("1")], {
          account: owner.account,
        }),
      ).to.be.rejectedWith("MintNotActive");
    });

    it("Should mint to an address once authorized and active", async function () {
      const { droneEnergyCores, owner, user1 } =
        await loadFixture(deployShipsFixture);

      await droneEnergyCores.write.setMintIsActive([true], {
        account: owner.account,
      });
      await droneEnergyCores.write.setAuthorizedToMint(
        [owner.account.address, true],
        { account: owner.account },
      );

      await droneEnergyCores.write.mint(
        [user1.account.address, parseEther("1")],
        { account: owner.account },
      );

      expect(
        await droneEnergyCores.read.balanceOf([user1.account.address]),
      ).to.equal(parseEther("1"));
    });
  });

  describe("Soulbound transfers", function () {
    async function mintTo(droneEnergyCores: any, owner: any, to: string, amount: bigint) {
      await droneEnergyCores.write.setMintIsActive([true], {
        account: owner.account,
      });
      await droneEnergyCores.write.setAuthorizedToMint(
        [owner.account.address, true],
        { account: owner.account },
      );
      await droneEnergyCores.write.mint([to, amount], {
        account: owner.account,
      });
    }

    it("Should revert a direct wallet-to-wallet transfer between two non-exempt addresses", async function () {
      const { droneEnergyCores, owner, user1, user2 } =
        await loadFixture(deployShipsFixture);
      await mintTo(droneEnergyCores, owner, user1.account.address, parseEther("5"));

      const user1DEC = await hre.viem.getContractAt(
        "DroneEnergyCores",
        droneEnergyCores.address,
        { client: { wallet: user1 } },
      );

      await expect(
        user1DEC.write.transfer([user2.account.address, parseEther("1")]),
      ).to.be.rejectedWith("Soulbound");
    });

    it("Should allow a transfer to the designated exempt address", async function () {
      const { droneEnergyCores, owner, user1, user2 } =
        await loadFixture(deployShipsFixture);
      await mintTo(droneEnergyCores, owner, user1.account.address, parseEther("5"));

      await droneEnergyCores.write.setTransferExemptAddress(
        [user2.account.address],
        { account: owner.account },
      );

      const user1DEC = await hre.viem.getContractAt(
        "DroneEnergyCores",
        droneEnergyCores.address,
        { client: { wallet: user1 } },
      );
      await user1DEC.write.transfer([user2.account.address, parseEther("1")]);

      expect(
        await droneEnergyCores.read.balanceOf([user2.account.address]),
      ).to.equal(parseEther("1"));
    });

    it("Should allow a transfer from the designated exempt address", async function () {
      const { droneEnergyCores, owner, user1, user2 } =
        await loadFixture(deployShipsFixture);
      await droneEnergyCores.write.setTransferExemptAddress(
        [user1.account.address],
        { account: owner.account },
      );
      await mintTo(droneEnergyCores, owner, user1.account.address, parseEther("5"));

      const user1DEC = await hre.viem.getContractAt(
        "DroneEnergyCores",
        droneEnergyCores.address,
        { client: { wallet: user1 } },
      );
      await user1DEC.write.transfer([user2.account.address, parseEther("1")]);

      expect(
        await droneEnergyCores.read.balanceOf([user2.account.address]),
      ).to.equal(parseEther("1"));
    });

    it("Should still revert a transfer between two non-exempt wallets even with an exempt address set elsewhere", async function () {
      const { droneEnergyCores, owner, user1, user2, user3 } =
        await loadFixture(deployShipsFixture);
      await mintTo(droneEnergyCores, owner, user1.account.address, parseEther("5"));
      await droneEnergyCores.write.setTransferExemptAddress(
        [user3.account.address],
        { account: owner.account },
      );

      const user1DEC = await hre.viem.getContractAt(
        "DroneEnergyCores",
        droneEnergyCores.address,
        { client: { wallet: user1 } },
      );

      await expect(
        user1DEC.write.transfer([user2.account.address, parseEther("1")]),
      ).to.be.rejectedWith("Soulbound");
    });
  });
});
