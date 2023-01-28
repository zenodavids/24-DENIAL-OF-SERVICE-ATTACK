const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Denial of Service', function () {
  it('After being declared the winner, Attack.sol should not allow anyone else to become the winner', async function () {
    // Deploy the good contract
    const Good = await ethers.getContractFactory('Good')
    const goodContract = await Good.deploy()
    await goodContract.deployed()
    console.log("Good Contract's Address:", goodContract.address)

    // Deploy the Attack contract
    const Attack = await ethers.getContractFactory('Attack')
    const attackContract = await Attack.deploy(goodContract.address)
    await attackContract.deployed()
    console.log("Attack Contract's Address", attackContract.address)

    // Now lets attack the good contract
    // Get two addresses
    const [_, addr1, addr2] = await ethers.getSigners()

    // Initially let addr1 become the current winner of the auction
    let tx = await goodContract.connect(addr1).setCurrentAuctionPrice({
      value: ethers.utils.parseEther('1'),
    })
    await tx.wait()

    // Start the attack and make Attack.sol the current winner of the auction
    tx = await attackContract.attack({
      value: ethers.utils.parseEther('3'),
    })
    await tx.wait()

    // Now lets trying making addr2 the current winner of the auction
    tx = await goodContract.connect(addr2).setCurrentAuctionPrice({
      value: ethers.utils.parseEther('4'),
    })
    await tx.wait()

    // Now lets check if the current winner is still attack contract
    expect(await goodContract.currentWinner()).to.equal(attackContract.address)
  })
})

/**
 * Notice how Attack.sol will lead Good.sol into a DOS attack. First addr1 will become the current winner by calling setCurrentAuctionPrice on Good.sol then Attack.sol will become the current winner by sending more ETH than addr1 using the attack function. Now when addr2 will try to become the new winner, it wont be able to do that because of this check(if (sent)) present in the Good.sol contract which verifies that the current winner should only be changed if the ETH is sent back to the previous current winner.

Since Attack.sol doesnt have a fallback function which is necessary to accept ETH payments, sent is always false and thus the current winner is never updated and addr2 can never become the current winner
 */
