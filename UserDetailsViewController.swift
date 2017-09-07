//
//  UserDetailsViewController.swift
//  Tinder
//
//  Created by Jaiela London on 9/3/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var completedProfile = false
    
    @IBOutlet var userImage: UIImageView!
    
    @IBAction func updateProfileImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            userImage.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var genderSwitch: UISwitch!
    @IBOutlet var interestedInSwitch: UISwitch!
    @IBAction func update(_ sender: Any) {
        
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedInSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(userImage.image!)
        
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                
                var errorMessage = "Update failed. please try again"
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                    
                }
                
                self.errorLabel.text = errorMessage
                
            } else {
                
                print("Updated!")
                
                self.performSegue(withIdentifier: "showSwipeView", sender: self)
                
                self.completedProfile = true
            }
            
            
        })
        
        
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
        
            genderSwitch.setOn(isFemale, animated: false)
            
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            
            interestedInSwitch.setOn(isInterestedInWomen, animated: false)
            
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            
            photo.getDataInBackground(block: { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        
                        self.userImage.image = downloadedImage
                    }
                }
                
            })
            
        }
        
        
       //Add female users 
        
        /*
        let urlArray = ["http://d39ya49a1fwv14.cloudfront.net/wp-content/uploads/2013/11/superheroe-crimson-avenger.jpg", "https://i.pinimg.com/originals/4e/69/62/4e696257797b01708300b7bd0aae9306.jpg", "https://upload.wikimedia.org/wikipedia/en/e/e2/Unbeatable_Squirrel_Girl.jpg", "http://comicsalliance.com/files/2015/08/storm-feat-630x420.jpg", "https://news.marvel.com/wp-content/uploads/sites/28/2016/11/5821ee7607491.jpg", "https://i.annihil.us/u/prod/marvel/i/mg/c/90/57e005bcd9d7e/portrait_incredible.jpg", "http://pre02.deviantart.net/24c8/th/pre/f/2013/176/3/9/jubilee_by_aaronpage-d6anooj.jpg", "http://www.okayafrica.com/wp-content/uploads/comic-republic-nigerian-superhero-Ireti.jpg"]
        
        var counter = 0
        
        for urlString in urlArray {
            
            counter += 1
            
            let url = URL(string: urlString)!
            
            do {
                
            let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "photo.png", data: data)
                
                let user = PFUser()
                
                user["photo"] = imageFile
                
                user.username = String(counter)
                
                user.password = "password"
                
                user["isInterestedInWomen"] = false
                
                user["isFemale"] = true
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if success {
                        
                        print("User signed up")
                    }
                    
                })
                
                
                
            } catch {
                
                print("Couldn't get data")
            }
            
        } 
 */
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
