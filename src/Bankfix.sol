// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract VIP_Bank_Fix {
    address public manager;
    mapping(address => uint) public balances;
    mapping(address => bool) public VIP;
    uint public maxETH = 0.5 ether;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "you are not manager");
        _;
    }

    modifier onlyVIP() {
        require(VIP[msg.sender] == true, "you are not our VIP customer");
        _;
    }

    function addVIP(address addr) public onlyManager {
        VIP[addr] = true;
    }

    function deposit() public payable onlyVIP {
        require(
            msg.value <= 0.05 ether,
            "Cannot deposit more than 0.05 ETH per transaction"
        );
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public onlyVIP {


        uint256 caBal = address(this).balance;

        require(
            _amount <= caBal,
            "Cannot withdraw more than what contract holds"
        );
        require(balances[msg.sender] >= _amount, "Not enough ether");
        balances[msg.sender] -= _amount;
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Withdraw Failed!");
    }

    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}
