// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenFactory {
    address[] public deployedTokens;

    event TokenCreated(address tokenAddress, string name, string symbol, uint256 supply);

    function createToken(string memory name, string memory symbol, uint256 supply) external {
        ERC20Token newToken = new ERC20Token(name, symbol, supply, msg.sender);
        deployedTokens.push(address(newToken));
        emit TokenCreated(address(newToken), name, symbol, supply);
    }

    function getDeployedTokens() external view returns (address[] memory) {
        return deployedTokens;
    }
}

contract ERC20Token is ERC20 {
    constructor(string memory name, string memory symbol, uint256 supply, address owner)
        ERC20(name, symbol)
    {
        _mint(owner, supply * (10 ** decimals()));
    }
}
