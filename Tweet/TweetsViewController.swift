//
//  TweetsViewController.swift
//  Tweet
//
//  Created by Elaine Mao on 5/4/15.
//  Copyright (c) 2015 Elaine Mao. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!

    func refresh(sender: AnyObject) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        if tweets != nil {
            let data = tweets![indexPath.row]
            cell.nameLabel.text = data.user?.name
            cell.usernameLabel.text = "@\(data.user?.screenname as String!)"
            cell.tweetLabel.text = data.text
            cell.profileImageView.setImageWithURL(NSURL(string: data.user?.profileImageUrl as String!))
            
            //cell.timestampLabel.text = NSDate().timeIntervalSinceDate(data.createdAt!)
            let interval = NSDate().timeIntervalSinceDate(data.createdAt!)
            switch interval {
            case 0...60:
                cell.timestampLabel.text = "\(Int(round(interval))) s"
            case 61...1440:
                cell.timestampLabel.text = "\(Int(round(interval / 60))) h"
            default:
                cell.timestampLabel.text = "\(Int(round(interval / 360))) d"
            }

        } else {
            println("no tweets")
        }
        
        return cell
    }
    
    @IBAction func onCompose(sender: AnyObject) {
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "composeSegue" {
            return;
        } else {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            
            let tweet = tweets![indexPath.row]
            
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            
            detailsViewController.tweet = tweet
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
