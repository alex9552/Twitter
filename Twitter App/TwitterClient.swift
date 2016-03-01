//
//  TwitterClient.swift
//  Twitter App
//
//  Created by Alex  Oser on 2/15/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking


let twitterConsumerKey = "g26OhrDrARJ7q1JtNm7TpuyTs"
let twitterConsumerSecret = "OR3lAJ1CsiPw9q4kvkWHIlBA0OH0hrCMi7jpY1sXtB2zqQzvCm"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
        
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:  "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
            
                success(user)

            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                success(tweets)
                
                
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential (queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            
            self.loginSuccess?()
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
                })
            
            
            print("Received access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken) 
            
            }) { (error: NSError!) -> Void in
                print("Failed to recieve access token")
                self.loginFailure?(error)
        }
           
    }
    
    func retweet(tweet: Tweet){
        
        POST("https://api.twitter.com/1.1/statuses/retweet/\(tweet.id!).json", parameters: nil, progress: { (NSProgress) -> Void in
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("Retweeted")
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to retweet")
                print(error)
        }
        
    }
    
    func detweet(tweet: Tweet){
        POST("https://api.twitter.com/1.1/statuses/unretweet/\(tweet.id!).json", parameters: nil, progress: { (NSProgress) -> Void in
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("Unretweeted")
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to unretweet")
                print(error)
        }
    }
    
    func fav(tweet: Tweet){
        POST("https://api.twitter.com/1.1/favorites/create.json?id=\(tweet.id!)", parameters: nil, progress: {
            (NSProgress) -> Void in
            print("hih")
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("Favorited")
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to favorite")
                print(error)
        }
    }
    
    func unfav(tweet: Tweet){
        POST("https://api.twitter.com/1.1/favorites/destroy.json?id=\(tweet.id!)", parameters: nil, progress: {
            (NSProgress) -> Void in
            print("progress!")
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("Unfavorited")
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to unfavorite")
                print(error)
        }
    }
    
    func postStatus(text: String){
        POST("https://api.twitter.com/1.1/statuses/update.json?status=\(text)", parameters: nil, progress: { (NSProgress) -> Void in
            print("getting there")
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("success")
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("failed to post tweet")
        }
    }
}

