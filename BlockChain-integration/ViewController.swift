//
//  ViewController.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/4/21.
//

import UIKit
import web3swift

class ViewController: UIViewController {
    
    
    var socketProvider: InfuraWebsocketProvider?
    
    @IBOutlet weak var buttonWallet: UIButton!{
        didSet{
            buttonWallet.layer.cornerRadius = 10
            buttonWallet.addTarget(self, action: #selector(presentWalletController), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var buttonSmartContract: UIButton!{
        didSet{
            buttonSmartContract.layer.cornerRadius = 10
            buttonSmartContract.addTarget(self, action: #selector(contract), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        contract()
    }
    
    @objc
    private func presentWalletController(){
//        let controller = WalletViewController(nibName: "WalletViewController", bundle: nil)
//        controller.modalPresentationStyle = .fullScreen
//        self.present(controller, animated: true, completion: nil)
    }

    @objc
    private func contract(){
        let seeds = "enter your seed words ... ... ..."
        
        // we should run this method in background thread because wait() from PromiseKit shouldn't run in main thread.
        DispatchQueue.global(qos: .userInitiated).async {
            let dispathGroup = DispatchGroup()
            dispathGroup.enter()
            do {
                let instance = try Web3Service(seedWords: seeds)
                
                try instance.register()
                try instance.unRegister()
//                _ = try instance.getAddress(79)
                
//                instance.getEvent("Register")
                dispathGroup.leave()
            }catch{
                print("run error: \(error)")
                dispathGroup.leave()
            }

        }
        
    }
    

}
