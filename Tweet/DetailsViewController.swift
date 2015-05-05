//
//  DetailsViewController.swift
//  Tweet
//
//  Created by Elaine Mao on 5/5/15.
//  Copyright (c) 2015 Elaine Mao. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var tweet: Tweet?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var replyIcon: UIImageView!
    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = tweet?.user?.name
        usernameLabel.text = "@\(tweet?.user?.screenname as String!)"
        tweetLabel.text = tweet?.text
        profileImageView.setImageWithURL(NSURL(string: tweet?.user?.profileImageUrl as String!))
        
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
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
