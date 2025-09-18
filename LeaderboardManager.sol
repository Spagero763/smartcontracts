// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LeaderboardManager {
    struct Player {
        uint256 score;
        bool exists;
    }

    mapping(address => Player) public players;
    address[] public playerList;

    function addOrUpdateScore(address _player, uint256 _score) external {
        if (!players[_player].exists) {
            players[_player] = Player(_score, true);
            playerList.push(_player);
        } else {
            players[_player].score = _score;
        }
    }

    function getScore(address _player) external view returns (uint256) {
        return players[_player].score;
    }

    function getTopPlayers(uint256 count) external view returns (address[] memory) {
        require(count > 0, "Invalid count");
        uint256 n = playerList.length;
        address[] memory sorted = new address[](n);
        for (uint256 i = 0; i < n; i++) {
            sorted[i] = playerList[i];
        }

        // simple bubble sort (ok for small n)
        for (uint256 i = 0; i < n; i++) {
            for (uint256 j = i + 1; j < n; j++) {
                if (players[sorted[j]].score > players[sorted[i]].score) {
                    address temp = sorted[i];
                    sorted[i] = sorted[j];
                    sorted[j] = temp;
                }
            }
        }

        if (count > n) count = n;

        address[] memory top = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            top[i] = sorted[i];
        }
        return top;
    }

    function getAllPlayers() external view returns (address[] memory) {
        return playerList;
    }
}
