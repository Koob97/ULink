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
    var courseListingVC: TableViewController!
    var myCoursesVC: MyCoursesViewController!
    var dataDict = [String: Any]()
    var courseDict = [String: Any]()
    
    @IBOutlet weak var myCoursesButton: UIButton!
    func update(){
        getAllData(completion: {
            let userID = Auth.auth().currentUser?.uid
            let users = self.dataDict["users"] as! [String: Any]
            let user = users[userID!] as! [String: Any]
            let courses = user["courses"] as! [String]
            self.myCoursesVC.courseArray = courses.sorted(by: <)
            self.myCoursesVC.table.reloadData()
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
    
    @IBAction func presentMyCourses(_ sender: Any) {
        var targetVC = MyCoursesViewController()
        
        if self.myCoursesVC != nil {
            targetVC = self.myCoursesVC
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            targetVC = storyboard.instantiateViewController(withIdentifier: "myCourses") as! MyCoursesViewController
            
            let userID = Auth.auth().currentUser?.uid
            let users = dataDict["users"] as! [String: Any]
            let user = users[userID!] as! [String: Any]
            self.myCoursesVC = targetVC
            
            if let courses = user["courses"] as? [String]{
                self.myCoursesVC.courseArray = courses.sorted(by: <)
            }
            else {
                self.myCoursesVC.courseArray = []
            }

        
        }
        self.navigationController!.pushViewController(self.myCoursesVC, animated: true)
        
    }
    
    
    @IBAction func presentCourseListings(_ sender: UIButton){
        // print(courseDict["187"] as! [String: Any])
        var targetVC = TableViewController()
        
        if self.courseListingVC != nil {
            targetVC = self.courseListingVC
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            targetVC = storyboard.instantiateViewController(withIdentifier: "courseListings") as! TableViewController
            
            self.courseListingVC = targetVC
            self.courseListingVC.dictionary = courseDict
        }
        courseListingVC.homeView = self
        self.navigationController!.pushViewController(self.courseListingVC, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllData(completion: {
            return
        })
        let userID = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        if let receivedText = userID{
            ref.child("users").child(receivedText).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            
            self.greeting.text = "Welcome, " + username
            self.greeting.sizeToFit()
            })
        }
    }

    

}