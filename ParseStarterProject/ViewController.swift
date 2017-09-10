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

    @IBOutlet var ebaeLogo: UILabel!
    
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
        
      /*
        //Add users
        
        
        let femaleUrlArray = ["http://d39ya49a1fwv14.cloudfront.net/wp-content/uploads/2013/11/superheroe-crimson-avenger.jpg", "https://i.pinimg.com/originals/4e/69/62/4e696257797b01708300b7bd0aae9306.jpg", "https://upload.wikimedia.org/wikipedia/en/e/e2/Unbeatable_Squirrel_Girl.jpg", "http://comicsalliance.com/files/2015/08/storm-feat-630x420.jpg", "https://news.marvel.com/wp-content/uploads/sites/28/2016/11/5821ee7607491.jpg", "https://i.annihil.us/u/prod/marvel/i/mg/c/90/57e005bcd9d7e/portrait_incredible.jpg", "http://pre02.deviantart.net/24c8/th/pre/f/2013/176/3/9/jubilee_by_aaronpage-d6anooj.jpg", "http://www.okayafrica.com/wp-content/uploads/comic-republic-nigerian-superhero-Ireti.jpg"]
        
        let maleUrlArray = ["https://i.pinimg.com/originals/ba/63/69/ba63695b4367e2c671a209b667147509.jpg", "https://static.comicvine.com/uploads/original/2/28247/1686832-superman.jpg", "https://static.comicvine.com/uploads/scale_small/10/100647/3998727-638504-22.jpg", "https://i.ytimg.com/vi/3qP2nJvomK0/maxresdefault.jpg", "http://www.therobotsvoice.com/wp-content/uploads/2012/03/namor1covercmykcrop_thumb-thumb-440x662.jpg", "https://imgix.ranker.com/user_node_img/50010/1000192049/original/nightcrawler-comic-book-characters-photo-u1?w=650&q=50&fm=jpg&fit=crop&crop=faces", "https://i.embed.ly/1/image?url=http%3A%2F%2Fak-hdl.buzzfed.com%2Fstatic%2F2015-02%2F5%2F17%2Fenhanced%2Fwebdr12%2Fenhanced-6712-1423173728-23.jpg&key=f34571a3c472496b89650475c5352926", "https://img0.etsystatic.com/111/1/9423850/il_570xN.919116020_ck7b.jpg"]
        
        let lesbianUrlArray = ["https://www.advocate.com/sites/advocate.com/files/2015/07/06/1Batwoman_0.jpg", "https://static.comicvine.com/uploads/scale_small/6/63459/5555748-0765257915-3301a.jpg", "https://vignette1.wikia.nocookie.net/marveldatabase/images/0/00/Roxanne_Washington_%28Earth-616%29_from_X-Men_Vol_4_10.NOW_001.png/revision/latest?cb=20150605190239", "https://i.pinimg.com/originals/e8/6d/17/e86d1705055f79898a77121a35eba73c.jpg", "https://vignette1.wikia.nocookie.net/marvelcomicsfanon/images/1/13/Karolina_Dean.png/revision/latest?cb=20151006194548", "https://i.pinimg.com/736x/92/2c/1b/922c1b1820cd653ed27c63d897516ae2--marvel-universe-geek-stuff.jpg"]
        
        let gayMenUrlArray = ["https://www.advocate.com/sites/advocate.com/files/2015/07/06/2Midnighter.jpg", "https://upload.wikimedia.org/wikipedia/en/thumb/3/30/Apollox.jpg/205px-Apollox.jpg", "http://www.dccomics.com/sites/default/files/HJFLC_Cv1_R3_gallery_57fc3635f2c6a2.45566872.jpg", "https://i.pinimg.com/originals/f6/23/e2/f623e2df64c2040f5f8115f808ec85e8.jpg", "https://i.pinimg.com/originals/ea/39/d5/ea39d568acb135db6f01e848e655abae.jpg", "http://img09.deviantart.net/a8b4/i/2012/141/d/5/wiccan_by_misterfee-d50mj6l.png"]
        
        var counter = 23
        
        for urlString in gayMenUrlArray {
            
            counter += 1
            
            let url = URL(string: urlString)!
            
            do {
                
                let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "photo.png", data: data)
                
                let user = PFUser()
                
                user["photo"] = imageFile
                
                user.username = String(counter)
                
                user.password = "password"
                
                //set to = gay man
                user["isInterestedInWomen"] = false
                
                user["isFemale"] = false
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if success {
                        
                        print("User signed up \(user["username"])")
                    }
                    
                })
                
                
                
            } catch {
                
                print("Couldn't get data")
            }
            
        } */

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
