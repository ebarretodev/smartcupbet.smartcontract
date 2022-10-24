// SPDX-License-Identifier: MIT

/**  Pragma statements */
pragma solidity ^0.8.0;

/** Import statements */

/** Error codes */
error SmartCupBet__NotOwner();
error SmartCupBet__MatchNotOpen();
error SmartCupBet__AlreadyMakeBetOnMatch();
error SmartCupBet__NotEnoughtFunds();
error SmartCupBet__MatchIndexNotExist();
error SmartCupBet__WithdrawError();

/** Interfaces */

/** Libraries */

/**  Contracts */
contract SmartCupBet {
    /** Type declarations */
    enum MatchState {
        OPEN,
        CLOSED
    }

    struct Match { // FIXME under develop
        uint8 teamA;
        uint8 teamB;
        uint8 penaltyTeamA;
        uint8 penaltyTeamB;
    }

    struct Player { // FIXME under develop
        Match[] matches;
        address addressPerson;
    }

    struct Odds {
        uint32 teamA;
        uint32 teamB;
        uint32 draw;
    }

    struct GrandPrize {
        uint256 firstPrize;
        uint256 secondPrize;
        uint256 thirdPrize;
        uint256 allPrize;
    }

    struct WinsAndBets {
        uint256 Wins;
        uint256 Bets;
        uint8 Matches;
    }

    /** State variables */
    address private immutable i_owner;
    uint256 private constant MINIMUM_USD_ENTRANCE_FEE = 3 * 1e18;

    /** Random Variables */
    mapping(address => uint256) private s_players; // FIXME under develop
    mapping(address => WinsAndBets) private winsAndBets;
    mapping (uint8 => Odds) private oddsMatch;
    mapping (uint8 => MatchState) private  matchState;

    GrandPrize private s_GrandPrize;

    /** Events */
    event BetEntered();

    /** Modifiers */
    modifier onlyOwner() {
        //require(msg.sender == owner, "You are not the Owner!");
        if (msg.sender != i_owner) revert SmartCupBet__NotOwner();
        _;
    }

    /** Functions */
    constructor() {
        i_owner = msg.sender;
    }

    // ANCHOR function to make a bet on individual match and recalculate all data odds
    // must insert as args match number, teamA, teamB, penaltyTeamA, penaltyTeamB
    // TODO verify if match is open, if not revert error MatchNotOpen()
    // TODO verify if player make a bet on this match, if yes, revert error AlreadyMakeBetOnMatch()
    // TODO verify the amount sended to bet, must be a US$3.00, if not revert error NotEnoughtFunds()
    // TODO add the values to "internal wallets" amount to current match (70%), grand prize(20%), contract owner(10%)
    // TODO insert the values match to table of user
    // TODO insert the values choice winner (TeamA, TeamB, Draw) to match array
    // TODO update the odds values for current match
    // TODO emit event EnterBet at the end to FrontEnd Recalculate the page
    // TODO 

    function makeBet(
        uint8 _matchNumber,
        uint8 _teamA,
        uint8 _teamB,
        uint8 _penaltyTeamA,
        uint8 _penaltyTeamB
    ) public payable {

        
    }

    // TODO function to close matches
    function closeMatch(uint8 index) public onlyOwner {
        if(index > 64 || index < 1) revert SmartCupBet__MatchIndexNotExist();
        if(matchState[index] == MatchState.CLOSED) revert SmartCupBet__MatchNotOpen();
        matchState[index] = MatchState.CLOSED;  
    }

    // TODO function to confirm real results of matches and force calculations

    // TODO function to pay the values to winners

    // function to withdraw in case of errors
    function withdraw() public onlyOwner{
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!callSuccess) revert SmartCupBet__WithdrawError();
    }

    /* View / Pure functions */
    // FIXME list all matchs of individuals
    function getPlayerMatchs() public view {
        
    }

    // FIXME list all data of individuals
    function getPlayerExist() public view {
        
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    // TODO list all participants
    
    // list odds of each match
    function getOddsMatch(uint8 index) public view returns (Odds memory) {
        if(index > 64 || index < 1) revert SmartCupBet__MatchIndexNotExist();
        return oddsMatch[index];
    }

    // List how much individuals win, bet and matches participation
    function getWinsAndBets() public view returns (WinsAndBets memory) {
        return winsAndBets[msg.sender];
    }

    // FIXME list the GrandPrize values return the values on USD
    function getGrandPrizeValues() public view returns (GrandPrize memory) {
        return s_GrandPrize;
    }

    // FIXME return the minimum entrance fee for the bet calculate with DataPriceFeeds of CHAINLINK
    function getEntranceFee() public pure returns (uint256) {
        return MINIMUM_USD_ENTRANCE_FEE;
    }

    // function to get the match state
    function getMatchState(uint8 index) public view returns (MatchState) {
        if(index > 64 || index < 1) revert SmartCupBet__MatchIndexNotExist();
        return matchState[index];
    }


    // TODO list the points acumulate until now to GrandPrize, up to 64 matches

    // TODO list the Position on GrandPrize

    // TODO list the points accumulate for individuals

}
