//
//  ViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 9/12/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        emailField.delegate = self
        passwordField.delegate = self
        UIApplication.shared.statusBarStyle = .lightContent
        view.backgroundColor = UIColor(red: 0.1216, green: 0.1216, blue: 0.1216, alpha: 1.0)
        if(isLoggedIn()){
            performSegue(withIdentifier: "segueToHome", sender: self)
        }
    }
    
    func isLoggedIn() -> Bool {
        print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    //close if somewhere outside of the keyboard is tapped
    @IBAction func onTapGestureRecognized(_ sender: Any!) {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func displayAlertMessage(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onButtonPressed(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        if email != "" && password != "" {
            Auth.auth().signIn(withEmail: email!, password: password!, completion: {
                (user, err) in
                if(user != nil){
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    let uuid = Auth.auth().currentUser?.uid
                    UserDefaults.standard.set(uuid, forKey: "currentUser")
                    UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: "segueToHome", sender: sender)
                }
                else {
                    let error = err! as NSError
                    self.displayAlertMessage(msg: error.localizedDescription)
                }
            })
        }
        
        else {
            displayAlertMessage(msg: "Please enter both your email and your password")
        }
    }
    
    


}

