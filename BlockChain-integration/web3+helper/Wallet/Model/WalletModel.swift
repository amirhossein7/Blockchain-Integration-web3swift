//
//  WalletModel.swift
//  CarchainDriver
//
//  Created by amirhossein on 1/27/20.
//  Copyright © 2020 macq. All rights reserved.
//

import Foundation


struct WalletModel: Codable {
    let address: String
    let data: Data
    let name: String
    let mnemonic: String?
    let isSeed: Bool
    
}

struct HDKey {
    let name: String?
    let address: String
}

