// Log-in page 
//  ViewController.swift
//  CollegeParty
//
//  Created by Christopher Kang on 9/27/18.
//  Copyright © 2018 Christopher Kang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn:Bool = true
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
       
        //flip boolean
        isSignIn = !isSignIn
        
        //check bool and set the button and sign in labels
        if isSignIn{
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        }
        else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
        
    }
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        //Do some form of validation on email and pass
        //TO DO
        if let email = emailTextField.text, let pass = passTextField.text {
            
            //check if sign in or register is selected
            if isSignIn {
                
                //sign in the user with firebase
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    // check that user isnt nill
                    if user != nil {
                        //user is found... proceed
                    
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                   else if error != nil {
                        // Handle the error (i.e notify the user of the error)
                        
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            
                            var code:String = ""
                            
                            switch errCode {
                            case .invalidEmail:
                                code = "Invalid email"
                            case .emailAlreadyInUse:
                                code = "Email already in use"
                            case .wrongPassword:
                                code = "Incorrect password"
                            case .userNotFound:
                                code = "User not found"
                            case .weakPassword:
                                code = "Please input a stronger password"
                            default:
                                code = "We've encountered an error, please try again"
                            }
                            
                            //alert view message if error
                            let alertView = UIAlertController(title: "", message: code, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                
                            })
                            alertView.addAction(action)
                            self.present(alertView, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
            else {
                //register user with firebase
                Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in

                    //guard let user = authResult?.user else { return }
                    //check that user isnt nill
                    if authResult != nil {
                        //user has valid email..
                        //send email confirmation link
                        //*** confirm email link
                        
                        
                        //if email confirmed, create new user in database
                        let userID = Auth.auth().currentUser!.uid
                        self.ref?.child("Users").child(userID)
                        self.ref?.child("Users").child(userID).child("Email").setValue(email)
                        
                        
                        self.performSegue(withIdentifier: "profile", sender: self)
                    }
                    else {
                        //check error and show message
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            
                            var code:String = ""
                            
                            switch errCode {
                            case .invalidEmail:
                                code = "Invalid email"
                            case .emailAlreadyInUse:
                                code = "Email already in use"
                            case .wrongPassword:
                                code = "Incorrect password"
                            case .userNotFound:
                                code = "User not found"
                            case .weakPassword:
                                code = "Please input a stronger password"
                            default:
                                code = "We've encountered an error, please try again"
                            }
                            
                            //alert view message if error
                            let alertView = UIAlertController(title: "", message: code, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                                
                            })
                            alertView.addAction(action)
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismiss text field when screen is touched elsewhere
        emailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
