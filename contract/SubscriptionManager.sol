// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AgentSubscription {
    // Event emitted when subscription is paid
    event SubscriptionPaid(uint256 indexed telegramId, uint256 timestamp);

    // Mapping to store subscription expiry timestamps
    mapping(uint256 => uint256) public subscriptions;

    // Subscription price in ETH
    uint256 public subscriptionPrice = 0.01 ether;

    // Duration of subscription in seconds (30 days)
    uint256 public constant SUBSCRIPTION_DURATION = 30 days;

    // Owner of the contract
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Function to pay for subscription
    function subscribe(uint256 telegramId) external payable {
        require(msg.value >= subscriptionPrice, "Insufficient payment");

        // Update subscription expiry
        uint256 expiry = block.timestamp + SUBSCRIPTION_DURATION;
        if (subscriptions[telegramId] > block.timestamp) {
            // If subscription is still active, add duration to current expiry
            expiry = subscriptions[telegramId] + SUBSCRIPTION_DURATION;
        }
        subscriptions[telegramId] = expiry;

        // Emit event
        emit SubscriptionPaid(telegramId, block.timestamp);
    }

    // Function to check if subscription is active
    function isSubscriptionActive(
        uint256 telegramId
    ) external view returns (bool) {
        return subscriptions[telegramId] > block.timestamp;
    }

    // Function to update subscription price (owner only)
    function updatePrice(uint256 newPrice) external {
        require(msg.sender == owner, "Only owner can update price");
        subscriptionPrice = newPrice;
    }

    // Function to withdraw funds (owner only)
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
