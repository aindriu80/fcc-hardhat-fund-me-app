// SPDX-License-Identifier: MIT
// Pragma
pragma solidity ^0.8.8;
// Imports
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

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
    // address[] public funders;
    
    // State Variables
    // mapping(address => uint256) public addressToAmountFunded;
   mapping(address => uint256) public s_addressToAmountFunded;
   
    address  private immutable i_owner;
    address[] private s_funders;

    // address public immutable owner;

    // 21,508 gas - immutable
    // 23,644 - non immutable

    AggregatorV3Interface public priceFeed; 

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender != i_owner) revert FundMe__NotOwner();
        // doing the rest of the code
        _;
    }
 
    constructor(address priceFeedAddress) {
        priceFeed = AggregatorV3Interface(priceFeedAddress);
        i_owner = msg.sender;
    }

    // receive() external payable{
    //     fund();
    // }

    // fallback() external payable{
    //     fund();
    // }

    /**
     *  @notice This function funds this contract
     *  @dev This implements price feed as our library
     */

    function fund() public payable {
        require(
            msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
            "Didn't send enough!"
        );
        s_addressToAmountFunded[msg.sender] = msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // Transfer vs call vs Send
        // payable(msg.sender).transfer(address(this).balance);
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }


    function cheaperWithdraw() public onlyOwner{
        address[] memory funders = s_funders;
        // mappings can't be in memory, 
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        //  reset the array
        s_funders = new address[](0);


        // Call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Transfer Failed");
    }
      function getAddressToAmountFunded(address fundingAddress)
        public
        view
        returns (uint256)
    {
        return s_addressToAmountFunded[fundingAddress];
    }
    

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

   
}



