// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Flashloan, FlashloanBorrower} from "../src/SimpleFlashloan.sol";

contract SampleTest is Test {
    Flashloan lender;
    // address person = makeAddr("owner");
    FlashloanBorrower borrower;


    function setUp() public {
        // vm.prank(owner);
        lender = new Flashloan();
        vm.deal(address(lender), 100 ether);
        borrower = new FlashloanBorrower(address(lender));
    }

    function test_Lender_has_funds() public view {
        assertEq(address(lender).balance, 100 ether);
        assertEq(address(borrower).balance, 0);
    }

    function test_borrower_can_borrow() public {
        borrower.initiateBorrow();
        assertEq(address(borrower).balance, 1 ether);
        assertEq(address(lender).balance, 99 ether);
    }
}
