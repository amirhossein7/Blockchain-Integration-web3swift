//
//  Web3Manager.swift
//  CarchainDriver
//
//  Created by amirhossein on 1/27/20.
//  Copyright © 2020 macq. All rights reserved.
//

import Foundation
import web3swift


class Web3Manager: ProtocolWalletHelper {
    
    

    func createWalletBySeedPhrase(password: String = "") -> WalletModel {
        
        let bitsOfEntropy: Int = 128 // Entropy is a measure of password strength. Usually used 128 or 256 bits.
        let mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
        let keystore = try! BIP32Keystore(
             mnemonics: mnemonics,
             password: password,
             mnemonicsPassword: "",
             language: .english)!
        let name = "New HD Wallet"
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
        let address = keystore.addresses!.first!.address
        let wallet = WalletModel(address: address, data: keyData, name: name, mnemonic: mnemonics, isSeed: true)
        saveSeedPhrase(mnemonics)
        return wallet
    }
        
    func laodWalletBy(_ seedPhrase: String, password: String = "") throws -> WalletModel {
        if isValid(seedPhrase: seedPhrase) {
            do {
                let keystore = try BIP32Keystore(
                    mnemonics: seedPhrase,
                    password: password,
                    mnemonicsPassword: "",
                    language: .english)!
                let name = "Load HD Wallet"
                let keyData = try! JSONEncoder().encode(keystore.keystoreParams)
                let address = keystore.addresses!.first!.address
                let wallet = WalletModel(address: address, data: keyData, name: name, mnemonic: seedPhrase,isSeed: true)
                saveSeedPhrase(seedPhrase)
                
                return wallet
            }catch {
                throw Web3Error.processingError(desc: error.localizedDescription)
            }
        }else {
            throw Web3Error.inputError(desc: "Error: seed words incorrected !!")
        }
        
    }
    

    func isValid(seedPhrase mnemonics: String) -> Bool {
        return BIP39.mnemonicsToEntropy(mnemonics, language: .english) != nil
    }
    
    
    private func saveSeedPhrase(_ seeds: String){
        // save your seed words in any way if you want
    }

    
    
}