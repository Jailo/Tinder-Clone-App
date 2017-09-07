/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true

    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var signupOrLoginButton: UIButton!
    
    @IBAction func signupOrLoginButtonPressed(_ sender: Any) {
            
        
        let users = PFUser()
        
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
        //checks if user entered in something in the text fields
            
            errorLabel.text = "Please enter in a valid username and password"
            
        } else {
            
        
        if signupMode {
        
            users.username = usernameTextField.text
            users.password = passwordTextField.text
            
            let acl = PFACL()
            
            acl.getPublicWriteAccess = true
            acl.getPublicReadAccess = true
            
            users.acl = acl
            
            users.signUpInBackground { (success, error) -> Void in
                
                // added test for success 11th July 2016
                
                if success {
                    
                    print("User has been saved.")
                    print("Signed up!")
                    self.performSegue(withIdentifier: "goToUserInfo", sender: self)
                    
                    
                } else {
                    
                    if error != nil {
                        
                        var errorMessage = "Signup failed. please try again"
                        
                        let error = error as NSError?
                        
                        if let parseError = error?.userInfo["error"] as? String {
                            
                            errorMessage = parseError
                        
                        }
                        
                        
                        self.errorLabel.text = errorMessage
                        
                    }  /*else {
                        
                        print("Signed up!")
                        self.performSegue(withIdentifier: "goToUserInfo", sender: self)
                        
                    } */
                    
                }
                
            }
            
            
        } else {
            //if in log in mode
            
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
            
                if error != nil {
                    
                    var errorMessage = "Signup failed. please try again"
                    
                    let error = error as NSError?
                    
                    if let parseError = error?.userInfo["error"] as? String {
                        
                        errorMessage = parseError
                        
                    }
                    
                    
                    self.errorLabel.text = errorMessage
                    
                } else {
                    
                    print("Logged In!")
                    self.redirectUser()
                }

                
            })
            
            
        }
            
        }
        
    }
    
    @IBOutlet var signupOrLoginLabel: UILabel!
    
    @IBAction func signupOrLoginModeChanger(_ sender: Any) {
        
        if signupMode {
            //switch to log in mode
        
        signupMode = false
        signupOrLoginLabel.text = "Don't have an account yet?"
        signupOrLoginModeChangerLabel.setTitle("Sign Up", for: [])
        signupOrLoginButton.setTitle("Log In", for: [])
        
        } else {
            
            //switch back to sign up mode
            
            signupMode = true
            signupOrLoginLabel.text = "Already have an account?"
            signupOrLoginModeChangerLabel.setTitle("Log in", for: [])
            signupOrLoginButton.setTitle("Sign up", for: [])
            
        }
        
        
    }
    
    @IBOutlet var signupOrLoginModeChangerLabel: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        redirectUser()
        
    }
    
    
    func redirectUser() {
        
        if PFUser.current() != nil {
            
            if PFUser.current()?["isFemale"] != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["photo"] != nil {
                
                performSegue(withIdentifier: "swipeFromItitialSegue", sender: self)
                
                
            } else {
                
                performSegue(withIdentifier: "goToUserInfo", sender: self)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
