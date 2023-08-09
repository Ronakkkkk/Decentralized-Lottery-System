// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import "hardhat/console.sol";

contract DecentralizedLottery {
    address public manager;
    address[] public players;
    uint256 public minimumbet;
    uint256 public lotteryEnd;
    uint256 private seed;
    constructor(uint256 _minimumbet,uint256 _durationInBlocks) {
        manager=msg.sender;
        minimumbet=_minimumbet;
        lotteryEnd=block.number+_durationInBlocks;
        seed=(block.timestamp+block.difficulty)%100;
    }

    function enterLottery()public payable{
require(msg.value>=minimumbet, "Insufficinet Bet ammount");
require(block.number<lotteryEnd,"Lottery has ended");

players.push(msg.sender);
        
    }

function pickWinner() public restricted {
    require(block.number > lotteryEnd, "Lottery is still ongoing");

    seed = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    uint256 winnerIndex = seed % players.length;
    address winner = players[winnerIndex];

    uint256 balance = address(this).balance;
    payable(winner).transfer(balance);

    emit WinnerSelected(winner);
}
}