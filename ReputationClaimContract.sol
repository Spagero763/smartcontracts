// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReputationClaim {
    mapping(address => bool) public hasClaimed;
    mapping(address => string) public userHash;

    event Claimed(address indexed user, string castHash);

    function claimBadge(string memory castHash) external {
        require(!hasClaimed[msg.sender], "Already claimed");
        hasClaimed[msg.sender] = true;
        userHash[msg.sender] = castHash;
        emit Claimed(msg.sender, castHash);
    }

    function getBadge(address user) external view returns (string memory) {
        return userHash[user];
    }
}
