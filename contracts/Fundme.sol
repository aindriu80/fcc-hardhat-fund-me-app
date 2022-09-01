// SPDX-Licence-Identifier: MIT
// Pragma
pragma solidity ^0.8.8;
// Imports
import "./PriceConverter.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Error codes
error FundMe__NotOwner();

//  Interfaces, Libraries, Contracts

/** @title A contract for crowd funding
 *  @author Aindriú Mac Giolla Eoin
 *  @notice This contract is to demo a sample funding contract
 *  @dev This implements price feeds as our library
 */
contract FundMe {
    // Type Declarations
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18; // 1 * 10 * 18
    // 21,415 - using a constant
    // 23,515 - not using a constant
    // 21,415 * 141000000000 = $9.058545 with Ethereum at around $3k
    // 23,515 * 141000000000 = $9.946845

    // Keeping track of people who send money
    address[] public funders;
    
    // State Variables
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable owner;

    // 21,508 gas - immutable
    // 23,644 - non immutable

    AggregatorV3Interface private priceFeed; 

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender == owner) {revert  FundMe__NotOwner();}
        // doing the rest of the code
        _;
    }
 
    constructor(address priceFeedAddress) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }

    /**
     *  @notice This function funds this contract
     *  @dev This implements price feed as our library
     */

    function fund() public payable {
        require(
            msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
            "Didn't send enough!"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        //  reset the array
        funders = new address[](0);

        //  need to actually withdraw funds - 3 different ways: transfer, send, call
        // Transfer - the 3 methods

        // // payable(msg.sender) = payable adress
        // payable(msg.sender).transfer(address(this).balance);

        // // Send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");

        // Call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed");
        revert();
    }



}
