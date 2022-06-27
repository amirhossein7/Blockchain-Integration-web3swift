//
//  Web3Service.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/4/21.
//

import Foundation
import web3swift
import BigInt

protocol Web3ServiceProtocol {}

/// a class for facilities working with smart-contract
class Web3Service: Web3ServiceProtocol {
    
    private var wallet: WalletInfo
    private var provider: web3
    private var contract: web3.web3contract
    
    
    private let checkTXminedInterval: TimeInterval = 10 //second
    
    init(seedWords: String) throws {
        //Set provider
        do {
            wallet = try WalletInfo(seeds: seedWords)
        }
        provider = Web3.InfuraRopstenWeb3()
        provider.addKeystoreManager(wallet.getKeyStoreManager())
        //Set contract
        let contractAddress = EthereumAddress(contractAddress)!
        contract = provider.contract(contractABI, at: contractAddress)!
    }
    
    
    /// send transaction with register method  (write)
    func register() throws {
        var options = TransactionOptions.defaultOptions
        
        guard let walletAddress = EthereumAddress(wallet.getAddress()) else { throw Web3Error.inputError(desc: "wallet address error") }
        guard let gp = Web3.Utils.parseToBigUInt("5", units: .Gwei) else {throw Web3Error.dataError} // Gas price

        do {
            options.from = walletAddress
            options.value = Web3.Utils.parseToBigUInt("0", units: .eth)
            options.nonce = .manual(try provider.eth.getTransactionCount(address: walletAddress))
            options.gasLimit = .manual(BigUInt(2100000))
            options.gasPrice = .manual(gp)
        }catch{
            throw Web3Error.processingError(desc: "nonce error")
        }
        
        do {
            // Write transaction
            guard let wtx = contract.method("register", parameters: [], extraData: Data(), transactionOptions: options) else {
                throw Web3Error.inputError(desc: "write contract error")
            }
            // Get EthereumTransaction
            var tx = try wtx.assemble()
            // Sign the transaction
            try Web3Signer.signTX(transaction: &tx, keystore: wallet.getKeyStoreManager(), account: walletAddress, password: "")
            // Send Raw transaction
            provider.eth.sendRawTransactionPromise(tx).done { res in
                self.waitUntilTXminde(provider: self.provider, txHash: res.hash) { receipt in
                    let topicsHex = "0x\(receipt.logs[0].topics[1].toHexString())"
                    let id = Web3Utils.hexToBigUInt(topicsHex)
                    print("⬆️ register successfull with id: \(id ?? 0)")
                }
                
            }
            .catch({ err in
                print("fell in catch: \(err)")
            })

        }catch {
            throw error
        }
    }
    
    
    
    
    /// send transaction with unRegister method (write)
    func unRegister() throws {
        
        var options = TransactionOptions.defaultOptions
        
        guard let walletAddress = EthereumAddress(wallet.getAddress()) else { throw Web3Error.inputError(desc: "wallet address error") }
        guard let gp = Web3.Utils.parseToBigUInt("5", units: .Gwei) else {throw Web3Error.dataError}

        do {
            options.from = walletAddress
            options.value = Web3.Utils.parseToBigUInt("0", units: .eth)
            options.nonce = .manual(try provider.eth.getTransactionCount(address: walletAddress))
            options.gasLimit = .manual(BigUInt("2100000"))
            options.gasPrice = .manual(gp)
        }catch{
            throw Web3Error.dataError
        }
        
        do {
            // Write transaction
            guard let wtx = contract.write("unRegister", parameters: [], extraData: Data(), transactionOptions: options) else {
                throw Web3Error.inputError(desc: "write contract error")
            }
            // Get EthereumTransaction
            var tx = try wtx.assemble()
            // Sign the transaction
            try Web3Signer.signTX(transaction: &tx, keystore: wallet.getKeyStoreManager(), account: walletAddress, password: "")
            // Send Raw transaction
            provider.eth.sendRawTransactionPromise(tx).done {  res in
                self.waitUntilTXminde(provider: self.provider, txHash: res.hash) { receipt in
                    print("⬇️ unregister successfully done")
                }
                
            }.catch({ err in
                print("fell in catch: \(err)")
            })
            
        }catch{
            throw error
        }
        
    }
    
    
    /// Get wallet address with that id get after register
    func getAddress(_ number: Int) throws -> Any{
        let params = [number] as [AnyObject]
        // Read transaction
        guard let rtx = contract.method("getAddress", parameters: params, extraData: Data(), transactionOptions: nil) else {
            throw Web3Error.inputError(desc: "read contract error")
        }
        
        do {
            let call = try rtx.call()
            guard let address = call["0"] as? EthereumAddress else {throw Web3Error.processingError(desc: "error in result!")}
            print("address: \(address)")
            return address
        }catch(_){
            throw Web3Error.nodeError(desc: "error in calling getAddress method!")
        }
    }
    
    
    /// Get historical event from the smart-contract
    func getEvent(_ eventName: String){
        
        let provider = Web3.InfuraRopstenWeb3()
        guard let contractAddress = EthereumAddress(contractAddress) else {return}
        guard let contract = provider.contract(contractABI, at: contractAddress) else {return}
       
        
        DispatchQueue.global(qos: .userInitiated).async {
            let dispatch = DispatchGroup()
            dispatch.enter()
            
            var filter = EventFilter()
            filter.fromBlock = .blockNumber(UInt64(0))
            filter.toBlock = .latest
            filter.addresses = [contractAddress]
            
            _ = contract.getIndexedEventsPromise(eventName: eventName, filter: filter).done({ res in
                if !res.isEmpty{
                    // get id from topics
                    let id = Web3Utils.hexToBigUInt((res[0].eventLog?.topics[1].toHexString())!)
                    print("event: \(id ?? 0)")
                    print("responce count: \(res.count)")
                }else {
                    print("response is empty!")
                }
            }).catch({ err in
                print("catch getEvent: \(err)")
            })
            
            dispatch.leave()
        }

        
    }
    
    
}


private extension Web3Service {
    
    /// get tx hash and check it until transaction mined
    func waitUntilTXminde(provider: web3, txHash: String, completion: @escaping (_ result: TransactionReceipt) -> Void){
        Timer.scheduledTimer(withTimeInterval: self.checkTXminedInterval, repeats: true) { timer in
            do {
                let receipt = try provider.eth.getTransactionReceipt(txHash)
                switch receipt.status {
                case .ok :
                    timer.invalidate()
                    completion(receipt)
                    break
                case .failed:
                    timer.invalidate()
                    print("transaction failed")
                    break
                case .notYetProcessed:
                    print("transaction not yet processed")
                    break
                }
            }catch Web3Error.nodeError {
                print("block not mined yet!")
            }catch {
                print("timer bad error: \(error)")
                timer.invalidate()
            }
        }
    }
    
}
