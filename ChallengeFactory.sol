// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Reputation.sol";
import "./PlatformToken.sol";

contract ChallengeManager {
    struct Challenge {
        address creator;
        string description;
        uint256 reward;
        uint256 deadline;
        bool rewardClaimed;
    }

    struct Solution {
        address submitter;
        string solutionDescription;
        uint256 submissionTime;
    }

    mapping(uint256 => Challenge) public challenges;
    mapping(uint256 => Solution[]) public solutions;
    mapping(uint256 => mapping(address => uint256)) public votes;

    Reputation public reputationContract;
    PlatformToken public tokenContract;

    constructor(address _reputation, address _token) {
        reputationContract = Reputation(_reputation);
        tokenContract = PlatformToken(_token);
    }

    // ... (existing functions: createChallenge, submitSolution, vote, etc.) ...

    function claimReward(uint256 challengeId) external {
        Challenge storage c = challenges[challengeId];
        require(block.timestamp >= c.deadline, "Challenge not ended");
        require(!c.rewardClaimed, "Reward already claimed");

        // Determine the winner (submitter with the most votes)
        address winner = _getWinner(challengeId);
        require(winner != address(0), "No valid winner");

        // Transfer token reward and increase reputation
        tokenContract.transfer(winner, c.reward);
        reputationContract.increaseReputation(winner, 1);

        c.rewardClaimed = true;
        emit RewardClaimed(challengeId, winner, c.reward);
    }

    // Helper function to determine the winner (submitter with the most votes)
    function _getWinner(uint256 challengeId) internal view returns (address) {
        address winner = address(0);
        uint256 maxVotes = 0;

        for (uint256 i = 0; i < solutions[challengeId].length; i++) {
            address submitter = solutions[challengeId][i].submitter;
            if (votes[challengeId][submitter] > maxVotes) {
                maxVotes = votes[challengeId][submitter];
                winner = submitter;
            }
        }

        return winner;
    }

    event RewardClaimed(uint256 challengeId, address winner, uint256 reward);
}