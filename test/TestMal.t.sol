// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.24;

import {Test, console, console2} from "forge-std/Test.sol";
import {ChallengeTwo} from "../src/ChallengeTwo.sol";

contract MalTest is Test {
    ChallengeTwo challenge;
    uint8 public counter = 0;

    address user = makeAddr("user");

    function setUp() public {
        vm.createSelectFork("https://eth-sepolia.g.alchemy.com/v2/o8P5Uj9ObttRRtuaWg-44jrSNnB1nX_9");
        challenge = new ChallengeTwo();
    }

    function test_passKey_reverts_if_invalid_key() public {
        vm.prank(user);
        vm.expectRevert();
        challenge.passKey(0);
    }

    function test_passKey_passes_if_valid_key() public {
        // vm.prank(user);
        test_bruteForceKey();
        assertEq(challenge.hasSolved1(msg.sender), true);
    }

    function test_bruteForceKey() public {
        bytes32 targetHash = 0xd8a1c3b3a94284f14146eb77d9b0decfe294c3ba72a437151caae86c3c8b2070;
        for (uint16 i = 0; i <= type(uint16).max; i++) {
            if (keccak256(abi.encode(i)) == targetHash) {
                challenge.passKey(i);
                break;
            }
        }
    }

    function test_get_enough_point_fails_if_has_not_solved1() public{
        vm.expectRevert();
        challenge.getENoughPoint("YoungAncient");
    }

    function test_get_enough_point_can_be_reentered() public{
        test_passKey_passes_if_valid_key();
        challenge.getENoughPoint("YoungAncient");
        assertEq(challenge.userPoint(msg.sender), 4);
        assertEq(challenge.hasSolved2(msg.sender), true);
        assertEq(challenge.Names(msg.sender), "YoungAncient");
    }


    function test_add_name_passes_if_get_enough_point_is_reentered() public{
        test_get_enough_point_can_be_reentered();
        challenge.addYourName();
        assertEq(challenge.hasCompleted(msg.sender), true);
        assertEq(challenge.champions(0), msg.sender);

    }

     function test_add_name_fails_if_completed_already() public{
        test_add_name_passes_if_get_enough_point_is_reentered();
        vm.expectRevert();
        challenge.addYourName();
    }

    receive() external payable {
        if (counter != 3) {
            ++counter;
            challenge.getENoughPoint("YoungAncient");
        }
    }
}
