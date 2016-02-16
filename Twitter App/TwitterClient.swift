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
    class var sharedInstace: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
}

