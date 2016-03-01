//
//  User.swift
//  Twitter App
//
//  Created by Alex  Oser on 2/16/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: NSURL?
    var tagline: String?
    var dictionary: NSDictionary
    var followerCount: Int?
    var followingCount: Int?
    var tweetCount: Int?
    var coverImageUrl: NSURL?
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let imageUrl = dictionary["profile_image_url"] as? String
        if let imageUrl = imageUrl{
            profileImageUrl = NSURL(string: imageUrl)
        } else {
            coverImageUrl = nil
        }
        tagline = dictionary["description"] as? String
        let coverUrl = dictionary["profile_banner_url"] as? String
        if let coverUrl = coverUrl{
            coverImageUrl = NSURL(string: coverUrl)
        } else {
            coverImageUrl = nil
        }
        
        
        tagline = dictionary["description"] as? String
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetCount = dictionary["statuses_count"] as? Int
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
        
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
