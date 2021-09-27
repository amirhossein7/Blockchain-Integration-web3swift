//
//  Web3Manager.swift
//  CarchainDriver
//
//  Created by amirhossein on 1/27/20.
//  Copyright © 2020 macq. All rights reserved.
//

import Foundation
import web3swift


protocol WalletManagerDelegate: AnyObject {
    func didReceivedWallet(wallet: WalletModel)
    func didFailedWallet(error: String)
}


class WalletManager {
    
    var delegate: WalletManagerDelegate
    
    init(_ delegate: WalletManagerDelegate) {
        self.delegate = delegate
    }
    
    static func isValid(seedPhrase mnemonics: String) -> Bool {
        return BIP39.mnemonicsToEntropy(mnemonics, language: .english) != nil
    }
    
    
    func createWallet(name: String = "New Wallet", password: String = "") {
        guard let mnemonics = generateMnemonics(bitsOfEntropy: 256) else {return}
        guard let wallet = makeWalletModel(seedPhrase: mnemonics, password: password, name: name) else {return}
        delegate.didReceivedWallet(wallet: wallet)
    }
        

    func restoreWallet(_ seedPhrase: String, name: String = "Load Wallet", password: String = ""){
        if WalletManager.isValid(seedPhrase: seedPhrase) {
            guard let wallet = makeWalletModel(seedPhrase: seedPhrase, password: password, name: name) else {return}
            delegate.didReceivedWallet(wallet: wallet)
        }else {
            print("invalid seed words!!")
        }
    }


    
    private func generateMnemonics(bitsOfEntropy: Int) -> String?{
        // bitsOfEntropy is a measure of password strength. Usually used 128 or 256 bits.
        do {
            return try BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
        }catch {
            delegate.didFailedWallet(error: "Error in generating mnemonics")
            return nil
        }
    }
    
    private func makeWalletModel(seedPhrase: String, password: String, name: String) -> WalletModel?{
        do {
            let keystore = try BIP32Keystore(
                mnemonics: seedPhrase,
                password: password,
                mnemonicsPassword: "",
                language: .english)!
            let keyData = try JSONEncoder().encode(keystore.keystoreParams)
            let address = keystore.addresses!.first!.address
            
            return WalletModel(address: address, data: keyData, name: name, mnemonic: seedPhrase,isSeed: true)
        }catch{
            delegate.didFailedWallet(error: error.localizedDescription)
            return nil
        }
    }
    
}
