// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Flashloan{
    receive() external payable {}

    function borrow() external{
        uint256 bal = address(this).balance;
        (bool success,) = msg.sender.call{value: 1 ether}("");
        require(success);
        // require(ret == keccak256("BorrowMoney"),"Invalid call");
        require(address(this).balance >= bal,"Flashloan not returned");
    }
}


contract FlashloanBorrower{
    Flashloan public lender;
    constructor(address _lender){
        lender = Flashloan(payable(_lender));
    }

    // ask for loan
    function initiateBorrow() external{
        lender.borrow();
    }

    function onFlashLoan(uint256 amount) external returns(bytes32){
        // do something with loan

        // return loan
        (bool success,) = address(lender).call{value: amount}("");
        require(success, "transfer failed");
        return keccak256("BorrowMoney");
    }

    receive() external payable{}
}