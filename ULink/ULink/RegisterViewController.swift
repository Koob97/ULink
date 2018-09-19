//
//  RegisterViewController.swift
//  ULink
//
//  Created by Jakob Herlitz on 9/16/18.
//  Copyright © 2018 Jakob Herlitz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        registerEmail.delegate = self
        registerPassword1.delegate = self
        registerPassword2.delegate = self
        registerUsername.delegate = self
        // Do any additional setup after loading the view.
    }
    
    //register fields
    @IBOutlet weak var registerEmail: UITextField!
    
    @IBOutlet weak var registerPassword1: UITextField!
    
    @IBOutlet weak var registerPassword2: UITextField!
    
    @IBOutlet weak var registerUsername: UITextField!
    
    @IBAction func registerUserButton(_ sender: Any) {
        let email = registerEmail.text
        let password = registerPassword1.text
        let username = registerUsername.text
        
        if(username == ""){
            displayAlertMessage(msg: "please enter a username")
        }
            
        else {
            Auth.auth().createUser(withEmail: email!, password: password!, completion: {
                (authResult, err) in
                print("made it inside")
                if let error = err{
                    print(error)
                }
                else {
                    let userID = Auth.auth().currentUser?.uid
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    ref.child("users").child(userID!).setValue(["username": username])
                    self.performSegue(withIdentifier: "segueToSignIn", sender: sender)
                }
            })
        }
    }
    
    func displayAlertMessage(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //close if somewhere outside of the keyboard is tapped
    @IBAction func onTapGestureRecognized(_ sender: Any!) {
        registerEmail.resignFirstResponder()
        registerPassword1.resignFirstResponder()
        registerPassword2.resignFirstResponder()
        registerUsername.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}
