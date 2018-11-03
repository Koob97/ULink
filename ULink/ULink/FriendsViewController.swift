//
//  FriendsViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 11/3/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    var friendsNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.1216, green: 0.1216, blue: 0.1216, alpha: 1.0)
        picker.delegate = self
        picker.dataSource = self
        //picker.setValue(UIColor.white, forKeyPath: "textColor")
        let tabController = tabBarController as! TabController
        let users = tabController.dataDict["users"] as! [String: [String: Any]]
        var friendsList = users[tabController.UUID]?["friends"] as! [String]
        friendsList = friendsList.sorted()
        for friend in friendsList {
            let username = users[friend]?["username"] as! String
            friendsNames.append(username)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return friendsNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let friend = friendsNames[row]
        let text = NSAttributedString(string: friend, attributes: [NSForegroundColorAttributeName: UIColor.white])
        return text
    }
    
    


}
