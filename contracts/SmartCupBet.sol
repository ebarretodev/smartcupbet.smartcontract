// SPDX-License-Identifier: MIT

/**  Pragma statements */
pragma solidity ^0.8.0;

/** Import statements */
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

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

/**
 * @title A contract for beting using smart contracts
 * @author Eliabel Barreto
 * @notice This contract is in produce on https://smartcupbet.web.app
 * @dev This implements price feeds as our library
 */
contract SmartCupBet {
    /** Type declarations */

    using PriceConverter for uint256;

    enum MatchState {
        OPEN,
        CLOSED
    }

    enum WinnerChoice {
        TEAM_A,
        TEAM_B,
        DRAW
    }

    struct Match {
        bool betDone;
        uint8 teamA;
        uint8 teamB;
        uint8 penaltyTeamA;
        uint8 penaltyTeamB;
    }

    struct Odds {
        uint32 teamA;
        uint32 teamB;
        uint32 draw;
    }

    struct GrandPrize {
        uint256 totalPrize;
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
    AggregatorV3Interface private s_priceFeed;

    /** Random Variables */
    mapping(address => uint256) private s_players; // FIXME under develop
    mapping(address => WinsAndBets) private winsAndBets;
    mapping(uint8 => Odds) private oddsMatch;
    mapping(uint8 => MatchState) private matchState;

    mapping(address => mapping(uint8 => Match)) private matchBetRegister;

    mapping(address => uint256) private positionGrandPrize;
    mapping(address => uint8) private pointsGrandPrize;
    address[] private rankingGrandPrize;

    //Internal wallets
    mapping(uint8 => uint256) private matchValueBets;
    GrandPrize private s_GrandPrize;
    uint256 private ContractOwnerValues;

    /** Events */
    event BetEntered(uint8 indexed matchNumber,Odds odds);

    /** Modifiers */
    modifier onlyOwner() {
        //require(msg.sender == owner, "You are not the Owner!");
        if (msg.sender != i_owner) revert SmartCupBet__NotOwner();
        _;
    }

    /** Functions */
    constructor(address _priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    // function to make a bet on individual match and recalculate all data odds
    // must insert as args match number, teamA, teamB, penaltyTeamA, penaltyTeamB

    function makeBet(
        uint8 _matchNumber,
        uint8 _teamA,
        uint8 _teamB,
        uint8 _penaltyTeamA,
        uint8 _penaltyTeamB
    ) public payable {
        // verify if match is open, if not revert error MatchNotOpen()
        if (matchState[_matchNumber] == MatchState.CLOSED) revert SmartCupBet__MatchNotOpen();
        // verify if player make a bet on this match, if yes, revert error AlreadyMakeBetOnMatch()
        if (matchBetRegister[msg.sender][_matchNumber].betDone != false)
            revert SmartCupBet__AlreadyMakeBetOnMatch();
        // verify the amount sended to bet, must be a US$3.00, if not revert error NotEnoughtFunds()
        if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD_ENTRANCE_FEE) {
            revert SmartCupBet__NotEnoughtFunds();
        }
        //  add the values to "internal wallets" amount to current match (75%), grand prize(20%), contract owner(5%)
        
        matchValueBets[_matchNumber] += (msg.value * 75) / 100;

        s_GrandPrize.totalPrize += (msg.value * 20 * 70) / (100 * 100);

        s_GrandPrize.allPrize += (msg.value * 20 * 15) / (100 * 100);

        ContractOwnerValues += (msg.value * 20 * 15) / (100 * 100);
        ContractOwnerValues += (msg.value * 5) / 100;

        // insert the values match to table of user
        matchBetRegister[msg.sender][_matchNumber] = Match(
            true,
            _teamA,
            _teamB,
            _penaltyTeamA,
            _penaltyTeamB
        );
        // TODO insert the values choice winner (TeamA, TeamB, Draw) to match array
        // TODO update the odds values for current match
        if(_teamA == _teamB){
            if(_matchNumber < 49){

            }
        }

        // TODO emit event EnterBet at the end to FrontEnd Recalculate the page
        // emit EnterBet(oddsMatch[_matchNumber]);
    }

    // function to close matches
    function closeMatch(uint8 index) public onlyOwner {
        if (index > 64 || index < 1) revert SmartCupBet__MatchIndexNotExist();
        if (matchState[index] == MatchState.CLOSED) revert SmartCupBet__MatchNotOpen();
        matchState[index] = MatchState.CLOSED;
    }

    // TODO function to confirm real results of matches and force calculations
    // on this function must be reorder the ranking list for GrandPrize

    // TODO function to pay the values to winners
    // on this function must see the winners and make the payout

    // function to withdraw in case of errors
    function withdraw() public onlyOwner {
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        if (!callSuccess) revert SmartCupBet__WithdrawError();
    }

    /* View / Pure functions */
    // TODO list all matchs of individuals
    function getPlayerMatchs() public view {}

    // TODO list all data of individuals
    function getPlayerExist() public view {}

    function getOwner() public view returns (address) {
        return i_owner;
    }

    // TODO list all participants

    // list odds of each match
    function getOddsMatch(uint8 index) public view returns (Odds memory) {
        if (index > 64 || index < 1) revert SmartCupBet__MatchIndexNotExist();
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
        if (index > 64 || index < 1) revert SmartCupBet__MatchIndexNotExist();
        return matchState[index];
    }

    // TODO list the points acumulate until now to GrandPrize, up to 64 matches

    // list the Position on GrandPrize
    function getPositionGrandPrize() public view returns (uint256) {
        return positionGrandPrize[msg.sender];
    }

    // TODO list the points accumulate for individuals

    // TODO sort the array with
    function sort() internal {
        uint256 size = rankingGrandPrize.length;
        for (uint256 step = 0; step < size - 1; ++step) {
            int256 swapped = 0;
            for (uint256 i = 0; i < size - step - 1; ++i) {
                if (
                    pointsGrandPrize[rankingGrandPrize[i]] >
                    pointsGrandPrize[rankingGrandPrize[i + 1]]
                ) {
                    address temp;
                    temp = rankingGrandPrize[i];
                    rankingGrandPrize[i] = rankingGrandPrize[i + 1];
                    rankingGrandPrize[i + 1] = temp;
                    swapped = 1;
                }
            }
            for (uint256 i = 0; i < size - 1; i++) {
                if (i == 0) {
                    positionGrandPrize[rankingGrandPrize[i]] = i;
                }
            }
            if (swapped == 0) {
                break;
            }
        }
    }
}
