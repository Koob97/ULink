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
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        let result = formatter.string(from: date)
        dateLabel.text = result
    }

    

}
