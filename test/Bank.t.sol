// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Bank.sol";

contract BankTest is Test {
    VIP_Bank vIP_Bank;

    address A = address(0xa);
    address B = address(0xb);
    address C = address(0xc);

    function setUp() public {
        vIP_Bank = new VIP_Bank();

        vIP_Bank.addVIP(A);
        vIP_Bank.addVIP(C);
        fundUserCOntract(address(vIP_Bank));
    }

    function testAddVipAndFund() public {
        switchSigner(A);
        fundUserEth(A);

        vIP_Bank.deposit{value: 0.05 ether}();
        uint256 bal = vIP_Bank.contractBalance();

        assertEq(bal, 0.5 ether);
    }

    function testFudWithnonVIP() public {
        switchSigner(B);
        fundUserEth(B);
        vm.expectRevert();
        vIP_Bank.deposit{value: 0.01 ether}();
    }

    function testAddVipAndFundAndWithdraw() public {
        switchSigner(A);
        fundUserEth(A);

        vIP_Bank.deposit{value: 0.05 ether}();

        vIP_Bank.withdraw(0.02 ether);

        //check contract balance
        uint256 bal = vIP_Bank.contractBalance();
        console.log("balance", bal);

        uint256 ethBalAfter = address(A).balance;
        console.log("A balance", ethBalAfter);
    }

    function testAddVIp() public {
        switchSigner(B);
        vm.expectRevert();
        vIP_Bank.addVIP(C);
    }

    function switchSigner(address _newSigner) public {
        address foundrySigner = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
        if (msg.sender == foundrySigner) {
            vm.startPrank(_newSigner);
        } else {
            vm.stopPrank();
            vm.startPrank(_newSigner);
        }
    }

    function testNultipleFund() public {
        switchSigner(A);
        fundUserEth(A);

        vIP_Bank.deposit{value: 0.05 ether}();

        switchSigner(C);
        fundUserEth(C);

        vIP_Bank.deposit{value: 0.05 ether}();

        uint256 bal = vIP_Bank.contractBalance();
        console.log("balance", bal);

        switchSigner(A);
        vm.expectRevert();
        vIP_Bank.withdraw(0.05 ether);
        // assertEq(bal, 0.05 ether);
    }

    function testNultipleFundWithdraw() public {
        switchSigner(A);
        fundUserEth(A);

        vIP_Bank.deposit{value: 0.01 ether}();

        switchSigner(C);
        fundUserEth(C);

        vIP_Bank.deposit{value: 0.02 ether}();

        uint256 bal = vIP_Bank.contractBalance();
        console.log("balance", bal);

        switchSigner(C);
        vm.expectRevert();
        vIP_Bank.withdraw(0.1 ether);
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    function fundUserEth(address userAdress) public {
        vm.deal(address(userAdress), 0.05 ether);
    }

    function fundUserCOntract(address userAdress) public {
        vm.deal(address(userAdress), 0.45 ether);
    }
}
