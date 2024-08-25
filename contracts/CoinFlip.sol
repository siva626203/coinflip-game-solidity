// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlip {
    address public owner;

    // Event emitted when a user plays the game
    event CoinFlipped(address indexed player, bool won, uint256 amount);

    // Modifier to restrict to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to flip the coin
    function flipCoin(bool choice) public payable {
        require(msg.value > 0, "Must send some ETH to flip");

        // Random outcome: true (heads) or false (tails)
        bool outcome = (block.timestamp + block.difficulty) % 2 == 0;

        if (outcome == choice) {
            // Player wins, double the bet
            uint256 payout = msg.value * 2;
            require(address(this).balance >= payout, "Insufficient contract balance");
            payable(msg.sender).transfer(payout);
            emit CoinFlipped(msg.sender, true, msg.value);
        } else {
            // Player loses, contract keeps the bet
            emit CoinFlipped(msg.sender, false, msg.value);
        }
    }

    // Function for the owner to fund the contract
    function fundContract() external payable onlyOwner {}

    // Function to withdraw funds from the contract
    function withdraw(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient contract balance");
        payable(owner).transfer(amount);
    }

    // Fallback function to accept incoming ETH
    receive() external payable {}
}
