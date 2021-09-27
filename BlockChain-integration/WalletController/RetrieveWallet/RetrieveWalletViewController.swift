//
//  RetrieveWalletViewController.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/20/21.
//

import UIKit
import web3swift

class RetrieveWalletViewController: UIViewController {
    
    fileprivate let placeholder = "please enter your seed words"
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = ""
            textView.keyboardDismissMode = .onDrag
            textView.backgroundColor = .white
            textView.layer.cornerRadius = 10
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            textView.delegate = self
        }
    }
    
    @IBOutlet weak var buttonRetrieve: UIButton!{
        didSet{
            buttonRetrieve.layer.cornerRadius = 10
            buttonRetrieve.addTarget(self, action: #selector(retrieveWallet), for: .touchUpInside)
        }
    }

    @IBOutlet weak var buttonBack: UIButton!{
        didSet{
            buttonBack.layer.cornerRadius = 20
            buttonBack.addTarget(self, action: #selector(backToWalletController), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var wallet: WalletManager! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wallet = WalletManager(self)
        stopAnimating()
    }

    
    @objc
    private func retrieveWallet(){
        
        textView.endEditing(true)
        startAnimating()

        if (textView.text != "") && (textView.text != placeholder) {
            wallet.restoreWallet(textView.text)
        }else {
            errorDialog(title: "Warning", desc: "please enter your seed words")
        }
    }
    
    
    @objc
    private func backToWalletController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func retrieveSuccessDialog(_ address: String) {
        stopAnimating()
        
        let dialogMessage = UIAlertController(title: "Wallet Retrieved", message: "address: \(address)", preferredStyle: .alert)
        
        let copyAddress = UIAlertAction(title: "copy", style: .default, handler: { (action) -> Void in
            UIPasteboard.general.string = address
         })
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        
        dialogMessage.addAction(copyAddress)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    private func errorDialog(title: String, desc: String) {
        let dialogMessage = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
    private func startAnimating(){
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
        }
    }
    private func stopAnimating(){
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        textView.endEditing(true)
    }
}

extension RetrieveWalletViewController: WalletManagerDelegate {
    func didReceivedWallet(wallet: WalletModel) {
        retrieveSuccessDialog(wallet.address)
    }
    
    func didFailedWallet(error: String) {
        stopAnimating()
        errorDialog(title: "error", desc: error)
    }
    
    
}

extension RetrieveWalletViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = placeholder
            textView.textColor = UIColor.lightGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
