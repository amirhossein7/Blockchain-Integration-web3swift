//
//  ProtocolWalletHelper.swift
//  CarchainDriver
//
//  Created by amirhossein on 1/27/20.
//  Copyright © 2020 macq. All rights reserved.
//

import Foundation

protocol ProtocolWalletHelper: ProtocolCreateWallet , ProtocolLoadWallet {
    func isValid(seedPhrase mnemonics: String) -> Bool
}


protocol ProtocolCreateWallet {
    func createWalletBySeedPhrase(password: String) -> WalletModel
}


protocol ProtocolLoadWallet {
    func laodWalletBy(_ seedPhrase: String, password: String) throws -> WalletModel
}

