//
//  WalletViewController.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/20/21.
//

import UIKit

class WalletViewController: UIViewController {
    
    var walletConnect: WalletConnect!
    
    @IBOutlet weak var buttonCreate: UIButton!{
        didSet{
            buttonCreate.layer.cornerRadius = 10
            buttonCreate.addTarget(self, action: #selector(showCreateController), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var buttonRetreive: UIButton!{
        didSet{
            buttonRetreive.layer.cornerRadius = 10
            buttonRetreive.addTarget(self, action: #selector(showRetreiveController), for: .touchUpInside)
        }
    }
    
    /// This button is disable now go in xib file and then in Show the Attributes inspector tab and check the installed check box
    @IBOutlet weak var buttonConnect: UIButton!{
        didSet{
            buttonConnect.layer.cornerRadius = 10
            buttonConnect.addTarget(self, action: #selector(connectToWallet), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            backButton.layer.cornerRadius = 20
            backButton.addTarget(self, action: #selector(backToMainViewController), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @objc
    private func showCreateController(){
        let controller = CreateWalletViewController(nibName: "CreateWalletViewController", bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc
    private func showRetreiveController(){
        let controller = RetrieveWalletViewController(nibName: "RetrieveWalletViewController", bundle: nil)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc
    private func connectToWallet(){
        let connectionUrl = walletConnect.connect()
            
        openWallet(url: connectionUrl)
    }
    
    private func configWalletConnect(){
        walletConnect = WalletConnect(delegate: self)
        walletConnect.reconnectIfNeeded()
    }
    
    private func openWallet(url: String){
//        let deepLinkUrl = "wc://wc?uri=\(url)"
//        let universalLink = "https://metamask.app.link/wc?uri=\(url)"
        
        onMainThread {
            if let mainUrl = URL(string: url) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                    UIApplication.shared.open(mainUrl, options: [:], completionHandler: nil)
                }
            } else {
                print("url error")
            }
        }

    }
    
    @objc
    private func backToMainViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}


extension WalletViewController: WalletConnectDelegate {
    
    func didConnect(url: String) {
        print("~~~~")
    }
    
    
    func failedToConnect() {
        print("~ failedToConnect")
    }
    
    func didConnect() {
        print("~ didConnect")
    }
    
    func didDisconnect() {
        print("~ didDisconnect")
    }
    
    
}
