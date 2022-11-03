// Implementation inspired by Joshua Riley at DevCon Bogota. 
// https://archive.devcon.org/archive/watch/6/demystifying-ethereum-assembly

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
 
// All these constants are written outside the contract so that they don't become part of the contract ABI

// Used in the `name()` function
// "MONSOON RAINDROPS"
bytes32 constant nameLength = 0x0000000000000000000000000000000000000000000000000000000000000017;
// strings are right padded
bytes32 constant nameData = 0x4d4f4e534f4f4e205241494e44524f5053000000000000000000000000000000;

// Used in the `symbol()` function
// "RAIN"
bytes32 constant symbolLength = 0x0000000000000000000000000000000000000000000000000000000000000004;
// strings are right padded
bytes32 constant symbolData = 0x5241494e00000000000000000000000000000000000000000000000000000000;
// `bytes4(keccak256("InsufficientBalance()"))`
bytes32 constant insufficientBalanceSelector = 0xf4d678b800000000000000000000000000000000000000000000000000000000;

// `bytes4(keccak256("InsufficientAllowance(address,address)"))`
bytes32 constant insufficientAllowanceSelector = 0xf180d8f900000000000000000000000000000000000000000000000000000000;

// max uint256 value, mints everything to the deployer
uint256 constant maxUint256 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

// `keccak256("Transfer(address,address,uint256)")`
bytes32 constant transferHash = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;

// `keccak256("Approval(address,address,uint256)")`
bytes32 constant approvalHash = 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
