//
//  ComposeViewController.swift
//  Tweet
//
//  Created by Elaine Mao on 5/5/15.
//  Copyright (c) 2015 Elaine Mao. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = User.currentUser?.name
        usernameLabel.text = User.currentUser?.screenname
        profileImageView.setImageWithURL(NSURL(string: User.currentUser?.profileImageUrl as String!))
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSubmit(sender: AnyObject) {
        let status = textField.text
        TwitterClient.sharedInstance.composeTweet(NSDictionary(dictionary: ["status" : status]), completion: { (params, error) -> () in
            println("successfully tweeted")
        })
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
