// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// contract Good is the name of the smart contract
contract Good {
// currentWinner is a public variable of type address
address public currentWinner;
// currentAuctionPrice is a public variable of type uint
uint public currentAuctionPrice;
// balances is a public mapping from address to uint
mapping(address => uint) public balances;
// constructor is called once when the contract is deployed
constructor() {
    // msg.sender is the address of the account that deployed the contract
    // currentWinner is set to the address of the account that deployed the contract
    currentWinner = msg.sender;
}

// function setCurrentAuctionPrice is public and payable
function setCurrentAuctionPrice() public payable {
    // require statement ensures that the value sent with the transaction is greater than currentAuctionPrice
    require(msg.value > currentAuctionPrice, "Need to pay more than the currentAuctionPrice");
    // Adds the currentAuctionPrice to the balance of the current winner in the balances mapping
    balances[currentWinner] += currentAuctionPrice;
    // updates the currentAuctionPrice
    currentAuctionPrice = msg.value;
    // updates the currentWinner
    currentWinner = msg.sender;
}

// function withdraw is public
function withdraw() public {
    // require statement ensures that the sender of the transaction is not the current winner
    require(msg.sender != currentWinner, "Current winner cannot withdraw");
    // gets the amount to withdraw from the balances mapping
    uint amount = balances[msg.sender];
    // sets the balance of the sender to 0
    balances[msg.sender] = 0;

    // sends the amount to the sender
    (bool sent,) = msg.sender.call{value: amount}("");
    // require statement ensures that the call was successful
    require(sent, "Failed to send Ether");
}
}