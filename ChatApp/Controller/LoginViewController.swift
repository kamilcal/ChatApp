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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BrandBlue")

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        super.viewDidLoad()
        spinner.hidesWhenStopped = true

    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            spinner.startAnimating()
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if authResult != nil, error == nil {
                    self.performSegue(withIdentifier: "loginToChat", sender: self)
                    self.spinner.stopAnimating()
                } else {
                    let alert = UIAlertController(title: "Log In Error",
                                                  message: "We were unable to log you in.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss",
                                                  style: .cancel ))
                    self.spinner.stopAnimating()
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
