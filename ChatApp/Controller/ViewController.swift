//
//  ViewController.swift
//  ChatApp
//
//  Created by kamilcal on 12.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "🕊ChatApp"
        for i in titleText {
            Timer.scheduledTimer(withTimeInterval: charIndex * 0.1 , repeats: false) { (time) in
                self.titleLabel.text?.append(i)
            }
            charIndex += 1

        }
    }


}

