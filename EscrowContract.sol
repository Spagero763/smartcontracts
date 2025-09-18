// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleEscrow {
    struct Deal {
        address depositor;
        address payee;
        uint256 amount;
        bool released;
    }

    mapping(uint256 => Deal) public deals;
    uint256 public dealCount;

    function deposit(address _payee) external payable {
        require(msg.value > 0, "No ETH sent");
        deals[dealCount] = Deal(msg.sender, _payee, msg.value, false);
        dealCount++;
    }

    function release(uint256 _id) external {
        Deal storage deal = deals[_id];
        require(!deal.released, "Already released");
        require(msg.sender == deal.depositor, "Only depositor can release");

        deal.released = true;
        payable(deal.payee).transfer(deal.amount);
    }

    function refund(uint256 _id) external {
        Deal storage deal = deals[_id];
        require(!deal.released, "Already released");
        require(msg.sender == deal.payee, "Only payee can refund");

        deal.released = true;
        payable(deal.depositor).transfer(deal.amount);
    }
}
