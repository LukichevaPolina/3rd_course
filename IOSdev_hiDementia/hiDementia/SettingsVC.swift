//
//  SettingsVC.swift
//  hiDementia
//
//  Created by Сапожников Андрей Михайлович on 24.12.2021.
//

import Foundation
import UIKit
import FirebaseAuth

final class SettingsViewController: UIViewController {
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign out", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(signOutLogic),
            for: .touchUpInside
        )
        return button
    }()
    
    @objc
    func signOutLogic() {
        do {
            try Auth.auth().signOut()
            let authVC = PhoneNumberVC()
            authVC.title = "Sign In"
            let authNav = UINavigationController(rootViewController: authVC)
            authNav.modalPresentationStyle = .fullScreen
            self.present(authNav, animated: true)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(sendButton)
        sendButton.becomeFirstResponder()
        sendButton.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 50)
        sendButton.center = view.center
    }
}
