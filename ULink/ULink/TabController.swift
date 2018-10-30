//
//  TabController.swift
//  ULink
//
//  Created by Jakob Herlitz on 10/29/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TabController: UITabBarController {
    
    var dataDict = [String: Any]()  // entire grab of data
    var courseDict = [String: Any]()  // for course listings page
    var courseArray = [String]() // for schedule and my courses
    
    var username: String! // username to be referenced in the views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData(completion: {
            // get the courses for the user
            let userID = Auth.auth().currentUser?.uid
            let users = self.dataDict["users"] as! [String: Any]
            let user = users[userID!] as! [String: Any]
            if let courses = user["courses"] as? [String]{
                self.courseArray = courses.sorted(by: <)
            }
            return
        })
        let userID = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        // grab the username
        if let receivedText = userID{
            ref.child("users").child(receivedText).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                self.username = value?["username"] as? String ?? ""
            })
        }
    }
    
    func update(){
        getAllData(completion: {
            // get the courses for the user
            let userID = Auth.auth().currentUser?.uid
            let users = self.dataDict["users"] as! [String: Any]
            let user = users[userID!] as! [String: Any]
            if let courses = user["courses"] as? [String]{
                self.courseArray = courses.sorted(by: <)
            }
            
            let controllers = self.viewControllers
            for controller in controllers! {
                switch(controller){
                case is MyCoursesViewController: (controller as! MyCoursesViewController).courseArray = self.courseArray
                case is ScheduleViewController: (controller as! ScheduleViewController).courseArray = self.courseArray
                    (controller as! ScheduleViewController).updateData(controller: self)
                default: print("default")
                }
            }
            
        })
    }
    
    func getAllData(completion: @escaping ()->()){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        //Read in ALL firebase data
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if !snapshot.exists(){
                return
            }
            let data = snapshot.value as! [String: Any]
            self.dataDict = data
            self.courseDict = self.dataDict["course_info"] as! [String: Any]
            completion()
        })
    }



}
