//
//  ABI_info.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/4/21.
//

import Foundation



let contractAddress = "0xD297F92b9Fb4676e4e36624A7C958B18DebcF251"
let contractABI = """
 [{
                "inputs": [],
                "stateMutability": "nonpayable",
                "type": "constructor"
            },
            {
                "anonymous": false,
                "inputs": [
                    {
                        "indexed": true,
                        "internalType": "uint256",
                        "name": "id",
                        "type": "uint256"
                    },
                    {
                        "indexed": false,
                        "internalType": "address",
                        "name": "owenr",
                        "type": "address"
                    }
                ],
                "name": "Register",
                "type": "event"
            },
            {
                "anonymous": false,
                "inputs": [
                    {
                        "indexed": true,
                        "internalType": "uint256",
                        "name": "id",
                        "type": "uint256"
                    },
                    {
                        "indexed": false,
                        "internalType": "address",
                        "name": "owenr",
                        "type": "address"
                    }
                ],
                "name": "UnRegister",
                "type": "event"
            },
            {
                "inputs": [
                    {
                        "internalType": "uint256",
                        "name": "_id",
                        "type": "uint256"
                    }
                ],
                "name": "getAddress",
                "outputs": [
                    {
                        "internalType": "address",
                        "name": "",
                        "type": "address"
                    }
                ],
                "stateMutability": "view",
                "type": "function"
            },
            {
                "inputs": [],
                "name": "register",
                "outputs": [],
                "stateMutability": "nonpayable",
                "type": "function"
            },
            {
                "inputs": [],
                "name": "unRegister",
                "outputs": [],
                "stateMutability": "nonpayable",
                "type": "function"
            }
        ]
"""
