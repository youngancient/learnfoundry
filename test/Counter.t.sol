// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract SampleTest is Test {
    Counter counter;
    address owner = makeAddr("owner");


    function setUp() public {
        vm.prank(owner);
        counter = new Counter();
    }

    function test_Owner() public view {
        assertEq(counter.owner(), owner);
    }
}
