//
//  ChatViewController.swift
//  ChatApp
//
//  Created by kamilcal on 12.11.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messagetextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title =  "🕊ChatApp"
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadMessage()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BrandPurple")// your colour here

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

    }
    
    func loadMessage() {
        
        
        db.collection("messages")
            .order(by: "date")
            .addSnapshotListener { querySnapshot, error in
                
                self.messages = []
                
                if let err = error {
                    print("Error getting documents: \(err)")
                } else {
                    if let document = querySnapshot?.documents {
                        for doc in document {
                            let data = doc.data()
                            if let messageSender = data["sender"] as? String,
                               let messageBoddy = data["body"] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBoddy)
                                self.messages.append(newMessage)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                        
                    }
                }
            }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messagetextField.text,
           let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: [
                "sender": messageSender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
            ]) { err in
                if let err = err {
                    print("Error addin g document: \(err)")
                } else {
                    print("Document added with ID:blablabla")
                    DispatchQueue.main.async {
                        self.messagetextField.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mes = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = mes.body
        
        if mes.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: "BrandLightPurple")
            cell.label.textColor = UIColor(named: "BrandPurple")
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBuble.backgroundColor = UIColor(named: "BrandPurple")
            cell.label.textColor = UIColor(named: "BrandLightPurple")
        }
        return cell
    }
    
    
}

