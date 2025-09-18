// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Raffle {
    address public owner;
    address[] public players;
    address public recentWinner;

    constructor() {
        owner = msg.sender;
    }

    function enterRaffle() external payable {
        require(msg.value > 0.001 ether, "Need > 0.001 ETH to enter");
        players.push(msg.sender);
    }

    function pickWinner() external {
        require(msg.sender == owner, "Only owner");
        require(players.length > 0, "No players yet");

        uint256 index = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players.length))
        ) % players.length;

        recentWinner = players[index];
        payable(recentWinner).transfer(address(this).balance);

        // reset players
        delete players;
    }

    function getPlayers() external view returns (address[] memory) {
        return players;
    }

    function getRecentWinner() external view returns (address) {
        return recentWinner;
    }
}
