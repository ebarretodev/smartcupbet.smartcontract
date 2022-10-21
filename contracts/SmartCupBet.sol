// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SmartCupBet {

    struct Match {
        uint8 teamA;
        uint8 teamB;
        uint8 penaltyTeamA;
        uint8 penaltyTeamB;
    }

    struct Player {
        Match[] matches;
        address addressPerson;
    }
    
    mapping(address => Player) private s_players;

    function makeBet(uint8 _matchNumber, uint8 _teamA, uint8 _teamB, uint8 _penaltyTeamA, uint8 _penaltyTeamB) public payable{
            s_players[msg.sender].addressPerson = msg.sender;
            s_players[msg.sender].matches[_matchNumber] = Match(_teamA, _teamB, _penaltyTeamA, _penaltyTeamB);
    }

    function getPlayerMatchs() public view returns (Match[] memory) {
        return s_players[msg.sender].matches;
    }

    function getPlayerExist() public view returns (Player memory){
        return s_players[msg.sender];
    }

}
