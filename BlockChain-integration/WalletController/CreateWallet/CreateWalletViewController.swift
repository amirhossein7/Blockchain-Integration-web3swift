//
//  CreateWalletViewController.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/20/21.
//

import UIKit

class CreateWalletViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = "please wait ..."
            textView.isEditable = false
        }
    }
    
    @IBOutlet weak var buttonCopy: UIButton!{
        didSet{
            buttonCopy.layer.cornerRadius = 10
            buttonCopy.backgroundColor = .lightGray
            buttonCopy.alpha = 0.5
            buttonCopy.isUserInteractionEnabled = false
            buttonCopy.addTarget(self, action: #selector(copySeedWords), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var buttonBack: UIButton!{
        didSet{
            buttonBack.layer.cornerRadius = 20
            buttonBack.alpha = 0.5
            buttonBack.isUserInteractionEnabled = false
            buttonBack.addTarget(self, action: #selector(backToWalletController), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.create { seeds in
            self.activateView(seeds)
        }
    }

    
    private func create(completion: @escaping (_ seeds: String) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            let wallet = Web3Manager.createWallet()
            completion(wallet.mnemonic ?? "failed")
        }
    }
    
    private func activateView(_ seeds: String){
        DispatchQueue.main.async {
            self.textView.text = seeds
            self.buttonCopy.alpha = 1
            self.buttonCopy.backgroundColor = .systemGreen
            self.buttonCopy.isUserInteractionEnabled = true
            self.buttonBack.alpha = 1
            self.buttonBack.isUserInteractionEnabled = true
        }
    }
    
    @objc
    private func copySeedWords(){
        UIPasteboard.general.string = textView.text
        copySuccessDialog()
    }
    private func copySuccessDialog() {
        let dialogMessage = UIAlertController(title: "Copied", message: "Your seed words copied successfully", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @objc
    private func backToWalletController(){
        self.dismiss(animated: true, completion: nil)
    }

}
