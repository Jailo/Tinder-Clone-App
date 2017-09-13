//
//  SwipingViewController.swift
//  Tinder
//
//  Created by Jaiela London on 9/6/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var displayedUserID = ""
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                //swiped left
                
                acceptedOrRejected = "rejected"
            
            } else if label.center.x > self.view.bounds.width - 100 {
                //swiped right
                
                acceptedOrRejected = "accepted"
                
            }
            
            
            if acceptedOrRejected != "" && displayedUserID != "" {
                
                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: acceptedOrRejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    
                    self.updateImage()
                    
                })
                
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        
            
        }
        
    }

    
    func updateImage() {
        
        let query = PFUser.query()
        
        query?.whereKey("isFemale", equalTo: (PFUser.current()?["isInterestedInWomen"])!)
        
        query?.whereKey("isInterestedInWomen", equalTo: (PFUser.current()?["isFemale"])!)
        
        var ignoredUsers = [""]
        
        ignoredUsers.remove(at: 0)
        
        if let acceptedUsers = PFUser.current()?["accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
        
        }
        
        if let rejectedUsers = PFUser.current()?["rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
            
        }
        
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
            
            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
                
            }
            
        }
        
        query?.limit = 1
        
        query?.countObjectsInBackground(block: { (count: Int32, error) in
            
            if error != nil {
                
                print(error)
            }
            
            var userCount = Int(count)
            
            print("Users left: \(userCount)")
            
            if userCount == 1 {
                
                if ignoredUsers.contains(self.displayedUserID) {
                
                    userCount = userCount - 1
                    
                }
                
                if (self.displayedUserID).isEmpty {
                    
                    print("DisplayedUserID Is empty")
                    
                    userCount = 0
                    
                }
           
            } else if userCount == 0 {
                
                self.imageView.image = UIImage(named: "person-icon.png")
        
                self.imageView.isUserInteractionEnabled = false
                
                self.errorLabel.text = "There are no more users in your area. Check back again later"
                
                self.errorLabel.textColor = UIColor.white
                
            } else {
                print("...Still swiping through users...")
            }
            

            
            query?.findObjectsInBackground(block: { (objects, error) in
                
                if let users = objects {
                    
                    for object in users {
                        
                        if let user = object as? PFUser {
                            
                            self.displayedUserID = user.objectId!
                            
                            let imageFile = user["photo"] as! PFFile
                            
                            let username = user["username"] as? String
                            print("username: \(username)")

                            
                            imageFile.getDataInBackground(block: { (data, error) in
                                
                        
                                if let imageData = data {
                                    
                                    self.imageView.image = UIImage(data: imageData)
                            
                                }
                                
                                
                            })

                            
                        }
                        
                    } //for - in loop ends
                    
                }
                
            })
            
            
        }) // end */
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(gesture)
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
            
            if let geopoint = geopoint {
            
                PFUser.current()?["location"] = geopoint
                
                PFUser.current()?.saveInBackground()
                
            }
            
        }
        
        updateImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logoutSegue" {
            
            PFUser.logOut()
    
            
        }
        
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
