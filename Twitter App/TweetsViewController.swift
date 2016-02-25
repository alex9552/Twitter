//
//  TweetsViewController.swift
//  Twitter App
//
//  Created by Alex  Oser on 2/21/16.
//  Copyright © 2016 Alex Oser. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogoutButton(sender: UIBarButtonItem) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        let tweet = tweets[sender.tag]
        if(tweet.retweeted){
            tweet.retweetCount = tweet.retweetCount - 1
            tweet.retweeted = false
        } else{
            tweet.retweetCount = tweet.retweetCount + 1
            tweet.retweeted = true
        }
        
        tableView.reloadData()
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let tweet = tweets[sender.tag]
        if(tweet.favorited){
            tweet.favoritesCount = tweet.favoritesCount - 1
            tweet.favorited = false
        } else{
            tweet.favoritesCount = tweet.favoritesCount + 1
            tweet.favorited = true
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            print("we made it")
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = self.tweets![indexPath.row]
        let username = tweet.user?.name
        let tweetText = tweet.text!
        let profileImageUrl = tweet.user?.profileImageUrl
        let timestamp = tweet.createdAt!

        cell.selectionStyle = .None
        
        cell.usernameLabel.text = username
        cell.tweetLabel.text = tweetText
        cell.timeLabel.text = "\(timestamp)"
        
        
        
        if let profileImageUrl = profileImageUrl {
            cell.profileView.setImageWithURL(profileImageUrl)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.profileView.image = nil
        }
        
        cell.favoriteButton.setTitle("Fav: \(tweet.favoritesCount)", forState: .Normal)
        cell.retweetButton.setTitle("RT: \(tweet.retweetCount)", forState: .Normal)
        
        cell.favoriteButton.tag = indexPath.row
        cell.retweetButton.tag = indexPath.row
        
        cell.favoriteButton.addTarget(self, action: "onFavorite:", forControlEvents: .TouchUpInside)
        cell.retweetButton.addTarget(self, action: "onRetweet:", forControlEvents: .TouchUpInside)
        
        
        print("row \(indexPath.row)")
        
        return cell
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
