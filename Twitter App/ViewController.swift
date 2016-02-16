//
//  ViewController.swift
//  Twitter App
//
//  Created by Alex  Oser on 2/15/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class ViewController: UIViewController {

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstace.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstace.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:  "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got request token")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
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

