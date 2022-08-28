// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18; // 1 * 10 * 18
    // 21,415 - using a constant
    // 23,515 - not using a constant
    // 21,415 * 141000000000 = $9.058545 with Ethereum at around $3k
    // 23,515 * 141000000000 = $9.946845

    // Keeping track of people who send money
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    // 21,508 gas - immutable
    // 23,644 - non immutable

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
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

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if(msg.sender == i_owner) {revert NotOwner();}
        // doing the rest of the code
        _;
    }
    // What happens if someone sends this contract ETH without call the fun funding

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }

}
