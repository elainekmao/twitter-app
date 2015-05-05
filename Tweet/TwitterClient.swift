//
//  TwitterClient.swift
//  Tweet
//
//  Created by Elaine Mao on 5/4/15.
//  Copyright (c) 2015 Elaine Mao. All rights reserved.
//

import UIKit

let twitterConsumerKey = "zJnuU0tjuEgBTqgmPXfv7EuIp"
let twitterConsumerSecret = "qOwpiz7D7RwN37wkslzBaWClPbOregMc4YHAUm19W7AjeFzFGB"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweet://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }) {(error: NSError!) -> Void in
            println("Failed to get token: \(error)")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL (url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            //success
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                //println("user: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                println("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
        }) { (error: NSError!) -> Void in
            //failure
            println("Failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func composeTweet (params: NSDictionary?, completion: (tweet: NSDictionary?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("tweet posted")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error posting tweet")
        }
    }
}
