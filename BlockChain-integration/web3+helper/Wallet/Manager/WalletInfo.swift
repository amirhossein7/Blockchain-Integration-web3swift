//
//  WalletEntity.swift
//  CarchainDriver
//
//  Created by amirhossein on 1/27/20.
//  Copyright © 2020 macq. All rights reserved.
//

import Foundation
import web3swift


class WalletInfo: ProtocolWalletInfo {


    fileprivate var wallet: WalletModel
    fileprivate let seedPhares: String
    fileprivate let password: String = ""
    
    init(seeds: String) throws {
        self.seedPhares = seeds
        do {
            wallet = try Web3Manager.laodWalletBy(seedPhares, password: password)
        }
    }
    
    func getKeyStoreManager() -> KeystoreManager{
        let data = self.wallet.data
        let keystoreManager: KeystoreManager
        if self.wallet.isSeed {
            let keystore = BIP32Keystore(data)!
            keystoreManager = KeystoreManager([keystore])
        }else{
            let keystore = EthereumKeystoreV3(data)!
            keystoreManager = KeystoreManager([keystore])
        }
        return keystoreManager
        
    }
    
    func getAddress() -> String {
        return wallet.address
    }
    
    func getPrivateKey() -> Data {
        let ethereumAddress = EthereumAddress(self.wallet.address)!
        let pkData = try! getKeyStoreManager().UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress)
        return pkData
    }
    
    func getPrivateKey() -> String {
        let ethereumAddress = EthereumAddress(self.wallet.address)!
        let pkData = try! getKeyStoreManager().UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress)
        return pkData.toHexString()
    }
    
    func getPublicKey() -> String {
        guard let publicKey = Web3Utils.privateToPublic(getPrivateKey()) else {return ""}
        return publicKey.toHexString()
    }
    
    func getMnemonics() -> String {
        return self.wallet.mnemonic ?? "Error: mnemonic is empty."
    }
    
    // generate JSON File for wallet & save to user's phone
    func generateJSONKey() {
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        FileManager.default.createFile(atPath: userDir+"/keystore/"+"key.json", contents: wallet.data, attributes: nil)
        print("> json file generated")
    }
    
    func getSign() -> String{
        do {
            let signiture = try Web3Signer.signPersonalMessage(Data(), keystore: getKeyStoreManager(), account: EthereumAddress(getAddress())!, password: "")
            return (signiture?.toHexString() ?? "")
        }catch{
            return ""
        }

    }

}
