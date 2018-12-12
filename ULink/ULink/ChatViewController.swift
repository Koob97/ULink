//
//  ChatViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 12/11/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var messages = [Message]()
    var offset = 0
    var friend = String()
    var friendName = String()
    
    @IBOutlet weak var friendLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        friendLabel.text = friendName
        navigationItem.title = "Messages"
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        observeMessages()
        
        textField.attributedPlaceholder = NSAttributedString(string:"enter message here ...", attributes: [NSForegroundColorAttributeName: UIColor.white])
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1500)
        view.bringSubview(toFront: sendButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func observeMessages(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                let user = UserDefaults.standard.value(forKey: "currentUser")
                if(self.msgIsForUser(user: user as! String, msg: message)){
                    self.messages.append(message)
                    self.addToScrollView(msg: message)
                }
            }
        }, withCancel: nil)
        
       
    }
    
    func estimateMsgWidth(msg: String) -> Int{
        let length = msg.characters.count
        if(length > 25){
            return 200
        }
        else {
            return Int((Double(length)/Double(25))*200)
        }
    }
    
    func addToScrollView(msg: Message){
       let user = UserDefaults.standard.value(forKey: "currentUser") as! String
        
        var color: UIColor = .gray
        var x = 5
        if(msg.from == user){
            color = .green
            x = Int(view.frame.width) - estimateMsgWidth(msg: msg.text!) - 10
        }
        
        let msgView = UIView(frame: CGRect(x: x, y:offset, width: estimateMsgWidth(msg: msg.text!), height: 50))
        let textView = UITextView(frame: CGRect(x: 0, y:0, width: estimateMsgWidth(msg: msg.text!), height: 50))
        
        textView.text = msg.text
        textView.isEditable = false
        textView.backgroundColor = color
        msgView.addSubview(textView)
        msgView.clipsToBounds = true
        msgView.layer.cornerRadius = 10.0
        
        scrollView.addSubview(msgView)
        offset += 75
    }
    
    func msgIsForUser(user: String, msg: Message) -> Bool{
        return ((msg.from == user && msg.to == friend) || (msg.to == user && msg.from == friend)) ? true:false
    }
    
    func sendAlert(){
        print(messages)
        let msg = "Please type some text before pressing send!"
        
        let alert = UIAlertController(title: "Invalid Text", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "close", style: .destructive, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func handleSend(){
        if textField.text == nil || textField.text == "" {
            sendAlert()
        }
        else {
            let ref = Database.database().reference().child("messages")
            let timestamp = Int(Date().timeIntervalSince1970)
            let user = UserDefaults.standard.value(forKey: "currentUser")
            let values = ["text": textField.text!, "from": user, "to": friend, "time": timestamp]
            let childRef = ref.childByAutoId()
            childRef.updateChildValues(values)
            
            //reset relevant values
            textField.text = ""
        }
    }
    

}
