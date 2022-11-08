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

contract YulERC20 {
    
    event Transfer(address indexed sender, address indexed receiver, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    error InsufficientBalance();
    error InsufficientAllowance(address owner, address spender);

    // account -> balance
    // `slot = keccak(account, 0x00))`
    mapping(address => uint256) internal _balances;

    // owner -> spender -> allowance
    // `slot = keccak256(owner, keccak256(spender, 0x01))`
    mapping(address => mapping(address => uint256)) internal _allowances;

    // `slot = 0x02`
    uint256 internal _totalSupply;

        // Mint maxUint256 tokens to the `msg.sender`.
    constructor() {
        assembly {
            // store the caller address at memory index zero
            mstore(0x00, caller())

            // store zero (storage index) at memory index 32
            mstore(0x20, 0x00)

            // hash the first 64 bytes of memory to generate the balance slot
            let slot := keccak256(0x00, 0x40)

            // store maxUint256 as caller's balance
            sstore(slot, maxUint256)

            // store maxUint256 as total supply
            sstore(0x02, maxUint256)

            // store maxUint256 in memory to log
            mstore(0x00, maxUint256)

            // log transfer event
            log3(0x00, 0x20, transferHash, 0x00, caller())
        }
    }

    function name() public pure returns (string memory) {
        assembly {
            // get free memory pointer from memory index `0x40`
            let memptr := mload(0x40)

            // store string pointer (0x20) in memory
            mstore(memptr, 0x20)
            
            // store string length in memory 32 bytes after the pointer
            mstore(add(memptr, 0x20), nameLength)
            
            // store string data 32 bytes after the length
            mstore(add(memptr, 0x40), nameData)
            
            // return from memory the three 32 byte slots (ptr, len, data)
            return(memptr, 0x60)
        }
    }

    function symbol() public pure returns (string memory) {
        assembly {
            // get free memory pointer from memory index `0x40`
            let memptr := mload(0x40)

            // store string pointer (0x20) in memory
            mstore(memptr, 0x20)
            
            // store string length in memory 32 bytes after the pointer
            mstore(add(memptr, 0x20), symbolLength)
            
            // store string data 32 bytes after the length
            mstore(add(memptr, 0x40), symbolData)
            
            // return from memory the three 32 byte slots (ptr, len, data)
            return(memptr, 0x60)
        }
    }

    function decimals() public pure returns (uint8) {
        assembly {
            // store `18` in memory at slot zero
            mstore(0, 18)

            // return 32 bytes from memory at slot zero
            return(0x00, 0x20)
        }
    }

}