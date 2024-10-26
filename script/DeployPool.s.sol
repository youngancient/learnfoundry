// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Web3BridgeCXIPool} from "../src/Flashloan.sol";

contract PoolScript is Script {

    function setUp() public {}

    function run() public returns(Web3BridgeCXIPool pool) {
        vm.startBroadcast();

        pool = new Web3BridgeCXIPool();
        vm.deal(address(pool), 1000 ether);

        vm.stopBroadcast();
    }

}
