// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Multisig {
    address[3] public owners;
    uint public requiredApprovals = 2;
    mapping (address => bool) isOwner;
    mapping(uint => mapping(address => bool)) public approvals;

    struct Transaction {
        address to;
        uint value;
        bool executed;
        uint confirmations;
    }

    Transaction[] public transactions;

    event TransactionSubmitted(uint transactionId, address to, uint256 value);
    event TransactionConfirmed(uint transactionId);
    event TransactionExecuted(uint transactionId);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    constructor (address[3] memory _owners) { 
        for (uint8 i = 0; i < _owners.length; i++) {
            require(_owners[i] != address(0), "Invalid owner");
            isOwner[_owners[i]] = true;
        }
        owners = _owners;
    }

    function submitTransaction(address _to, uint _value) public onlyOwner {
        uint transactionId = transactions.length;
        transactions.push(Transaction({
            to: _to,
            value: _value,
            executed: false,
            confirmations: 0
        }));
        emit TransactionSubmitted(transactionId, _to, _value);
    }

    function approveTransaction(uint _transactionId) public onlyOwner {
        require(!transactions[_transactionId].executed, "Transaction already executed");
        require(!approvals[_transactionId][msg.sender], "Transaction already approved by this signer");

        approvals[_transactionId][msg.sender] = true;
        transactions[_transactionId].confirmations += 1;

        if (transactions[_transactionId].confirmations >= requiredApprovals) {
            executeTransaction(_transactionId);
        }
        
        emit TransactionConfirmed(_transactionId);
    }

    function executeTransaction(uint _transactionId) internal {
        require(transactions[_transactionId].confirmations >= requiredApprovals, "Not enough approvals");
        require(!transactions[_transactionId].executed, "Transaction already executed");

        (bool success, ) = transactions[_transactionId].to.call{value: transactions[_transactionId].value}("");
        require(success, "Transaction failed");

        transactions[_transactionId].executed = true;
        emit TransactionExecuted(_transactionId);
    }
}