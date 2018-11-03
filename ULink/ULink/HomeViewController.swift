//
//  HomeViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 9/12/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    @IBOutlet weak var greeting: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
   
    @IBOutlet weak var userSearch: UITextField!
    
    @IBAction func signOutPressed(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "toLogin", sender: sender)
    }
    @IBAction func addFriendButton(_ sender: Any) {
        let username = userSearch.text
        let tabController = tabBarController as! TabController
        var friendUuid: String!
        let currentUUID = tabController.UUID
        let users = tabController.dataDict["users"] as! [String: [String: Any]]
        
        // find the uuid of the friend
        for (uuid, info) in users{
            if(info["username"] as? String == username){
                friendUuid = uuid
            }
        }
        
        //check if the user already has this person as a friend
        let friends = users[currentUUID!]?["friends"]
        if(friends != nil){
            if(!(friends as! [String]).contains(friendUuid)){
                //add friend
                addFriendToDatabase(sender: currentUUID!, receiver: friendUuid, users: users)
            }
            else {
                print("already friends with that person")
            }
        }
        else {
            addFriendToDatabase(sender: currentUUID!, receiver: friendUuid, users: users)
        }
        
    }
    
    func addFriendToDatabase(sender: String, receiver: String, users: [String: [String:Any]]){
        var senderFriends = [String]()
        var receiverFriends = [String]()
        let senderInfo = users[sender]
        let receiverInfo = users[receiver]
        
        if senderInfo?["friends"] != nil {
                senderFriends = senderInfo?["friends"] as! [String]
        }
        if receiverInfo?["friends"] != nil {
            receiverFriends = receiverInfo?["friends"] as! [String]
        }
        senderFriends.append(receiver)
        receiverFriends.append(sender)
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(sender)/friends").setValue(senderFriends, withCompletionBlock: { (err, dbRef) in
                //let controller = self.tabBarController as! TabController
                //controller.update()
        })
        ref.child("users/\(receiver)/friends").setValue(receiverFriends, withCompletionBlock: { (err, dbRef) in
            let controller = self.tabBarController as! TabController
            controller.update()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1216, green: 0.1216, blue: 0.1216, alpha: 1.0)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        let result = formatter.string(from: date)
        dateLabel.text = result
    }

    

}
