//
//  WalletViewController.swift
//  BlockChain-integration
//
//  Created by Amirhossein on 9/20/21.
//

import UIKit

class WalletViewController: UIViewController {
    
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
    
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            backButton.layer.cornerRadius = 20
            backButton.addTarget(self, action: #selector(backToMainViewController), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    private func backToMainViewController(){
        self.dismiss(animated: true, completion: nil)
    }
}
