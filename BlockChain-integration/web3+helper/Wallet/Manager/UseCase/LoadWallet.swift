//
//  ImportWallet.swift
//  CarchainDriver
//
//  Created by amirhossein on 1/27/20.
//  Copyright © 2020 macq. All rights reserved.
//

import Foundation


class LoadWallet {
    
    let walletHelper: ProtocolLoadWallet
    let seedPhrase: String
    
    init(_ seedPhrase: String) {
        
        self.walletHelper = Web3Manager()
        self.seedPhrase = seedPhrase
    }
    
    func run(password: String = "") throws -> WalletModel{
        do {
            return try walletHelper.laodWalletBy(seedPhrase, password: password)
        }catch{
            throw error
        }
    }
}
