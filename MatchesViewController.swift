//
//  MatchesViewController.swift
//  Tinder
//
//  Created by Jaiela London on 9/11/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var images = [UIImage]()
    var userIds = [String]()
    var messages = [String]()
    var usernames = [String]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFUser.query()
        
        //check if other users have accepted current user
        query?.whereKey("accepted", contains: PFUser.current()?.objectId)
        
        //check if current user has accepted other user
        query?.whereKey("objectId", containedIn: PFUser.current()?["accepted"] as! [String])
        
        
        query?.findObjectsInBackground(block: { (objects, error) in
           
            if objects! == [] {
                
                let alert = UIAlertController(title: "You don't have any matches...yet", message: "Don't feel discouraged, you'll find your bae one day. Check back in later", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                    
                    action in self.performSegue(withIdentifier: "backSegue", sender: self)
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }

            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        let username = user["username"] as? String
                        
                        let imageFile = user["photo"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                            
                            if let imageData = data {
                                
                                
                                let messageQuery = PFQuery(className: "Message")
                                
                                messageQuery.whereKey("recipient", equalTo: (PFUser.current()?.objectId!)!)
                                
                                messageQuery.whereKey("sender", equalTo: user.objectId!)
                                
                                messageQuery.findObjectsInBackground(block: { (objects, error) in
                                    
                                    var messageText = "No message from this user yet. Check back in later."
                                    
                                    if let objects = objects {
                                        
                                        for message in objects {
                                        
                                                if let messageContent = message["content"] as? String {
                                                    
                                                    messageText = messageContent
                                                    
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    self.messages.append(messageText)
                                    
                                    self.images.append(UIImage(data: imageData)!)
                                    
                                    self.userIds.append(user.objectId!)
                                    
                                    self.usernames.append(username!)
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                })
                              
                            }
                           
                        })
                        
                    }
                    
                }
                
            }

        })
        
        
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
    }
    
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MatchesTableViewCell
        
        cell.userImageView.image = images[indexPath.row]
        
        cell.messagesLabel.text = "You haven't recived a message yet"
        
        cell.userIdLabel.text = userIds[indexPath.row]
        
        cell.messagesLabel.text = messages[indexPath.row]
        
        cell.matchesUsernameLabel.text = usernames[indexPath.row]
        
        return cell
        
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
