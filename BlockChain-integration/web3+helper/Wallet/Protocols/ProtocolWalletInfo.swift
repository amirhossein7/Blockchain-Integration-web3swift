//
//  ProtocolWalletInfo.swift
//  CarchainDriver
//
//  Created by amirhossein on 1/27/20.
//  Copyright © 2020 macq. All rights reserved.
//

import Foundation



protocol ProtocolWalletInfo {
        
    func getAddress() -> String
    func getPrivateKey() -> Data
    func getPrivateKey() -> String
    func getPublicKey() -> String
    func getMnemonics() -> String
    func getSign() -> String
    func generateJSONKey()

}


