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
    event TransactionConfirmed(uint transactionId, address owner);
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
}