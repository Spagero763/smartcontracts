// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Reputation {
    mapping(address => uint256) public reputation;
    mapping(address => string[]) public badges;

    event ReputationIncreased(address indexed user, uint256 newScore);
    event BadgeAwarded(address indexed user, string badge);

    function increaseReputation(address user, uint256 amount) external {
        reputation[user] += amount;
        emit ReputationIncreased(user, reputation[user]);
    }

    function awardBadge(address user, string memory badge) external {
        badges[user].push(badge);
        emit BadgeAwarded(user, badge);
    }

    function getBadges(address user) external view returns (string[] memory) {
        return badges[user];
    }
}