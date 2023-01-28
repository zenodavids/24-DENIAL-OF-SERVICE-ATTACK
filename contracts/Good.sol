// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// To aviod DOS attack like in Good.sol, You can create a seperate withdraw function for the previous winners.


// contract Good is the name of the smart contract
contract Good {
// Declare a public variable to store the address of the current winner
address public currentWinner;

// Declare a public variable to store the current auction price
uint public currentAuctionPrice;

// Declare a mapping to store the balances of each address
mapping(address => uint) public balances;

// Constructor function that sets the initial value of the current winner to the msg.sender
constructor() {
currentWinner = msg.sender;
}

// Function to set the current auction price, and update the current winner
function setCurrentAuctionPrice() public payable {
// Require that the msg.value is greater than the current auction price
require(msg.value > currentAuctionPrice, "Need to pay more than the currentAuctionPrice");
// Add the current auction price to the previous winner's balance
balances[currentWinner] += currentAuctionPrice;
// Set the current auction price to the msg.value
currentAuctionPrice = msg.value;
// Set the current winner to the msg.sender
currentWinner = msg.sender;
}

// Function to allow a user to withdraw their balance
function withdraw() public {
// Require that the msg.sender is not the current winner
require(msg.sender != currentWinner, "Current winner cannot withdraw");
// Get the balance of the msg.sender
uint amount = balances[msg.sender];
// Set the balance of the msg.sender to 0
balances[msg.sender] = 0;

// Send the amount to the msg.sender
(bool sent, ) = msg.sender.call{value: amount}("");
// Require that the send was successful
require(sent, "Failed to send Ether");
}
}