//
//  LoginViewController.swift
//  ChatApp
//
//  Created by kamilcal on 12.11.2022.
//

import Foundation
import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
   
    override func viewDidLoad() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BrandBlue")// your colour here

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        super.viewDidLoad()
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "loginToChat", sender: self)
                }
            }
        }
    }
}
