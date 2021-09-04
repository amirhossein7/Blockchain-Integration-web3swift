//
//  CreateWallet.swift
//  CarchainDriver
//
//  Created by amirhossein on 1/27/20.
//  Copyright © 2020 macq. All rights reserved.
//

import Foundation


class CreateWallet {
    
    let walletHelper: ProtocolCreateWallet
    
    init() {
        self.walletHelper = Web3Manager()
    }
    
    func run(password: String = "") -> WalletModel{
        let wallet = walletHelper.createWalletBySeedPhrase(password: password)
        return wallet
    }
    
}
