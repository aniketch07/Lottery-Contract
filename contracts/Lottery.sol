// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    function participate() public payable {
        require(msg.value == 1 ether, "Please pay exactly 1 ether to participate");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint) {
        require(manager == msg.sender, "You are not the manager");
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        require(manager == msg.sender, "You are not the manager");
        return players;
    }

    function getTotalNumberOfPlayers() public view returns (uint) {
        return players.length;
    }

    function random() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(manager == msg.sender, "You are not the manager");
        require(players.length >= 3, "There must be at least 3 players to pick a winner");

        uint r = random();
        uint index = r % players.length;
        winner = players[index];

        winner.transfer(getBalance());
         players=new address payable[](0);
    }
}
