// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/Bank.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() external {
        vm.startBroadcast();

        VIP_Bank vIP_Bank = new VIP_Bank();

        console.log(
            "VIP_Bank Contract has beend deployed to  => ",
            address(vIP_Bank)
        );

        vm.stopBroadcast();
    }
}
