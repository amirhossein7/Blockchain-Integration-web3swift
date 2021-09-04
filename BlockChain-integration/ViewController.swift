//
//  ViewController.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/4/21.
//

import UIKit
import web3swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        run()
    }

    
    private func run(){
        let seeds = "enter your seed words ... ... ..."
        
        // we should run this method in background thread because wait() from PromiseKit shouldn't run in main thread.
        DispatchQueue.global(qos: .userInitiated).async {
            let dispathGroup = DispatchGroup()
            dispathGroup.enter()
            do {
                let instance = try Web3Service(seedWords: seeds)
                
//                try instance.register()
//                try instance.unRegister()
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

