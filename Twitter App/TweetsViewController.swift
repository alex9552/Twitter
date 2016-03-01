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
        
            TwitterClient.sharedInstance.detweet(tweet)
            tweet.retweetCount = tweet.retweetCount - 1
            tweet.retweeted = false
            
        } else{
            TwitterClient.sharedInstance.retweet(tweet)
            tweet.retweetCount = tweet.retweetCount + 1
            tweet.retweeted = true
        }
        
        tableView.reloadData()
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let tweet = tweets[sender.tag]
        if(tweet.favorited){
            TwitterClient.sharedInstance.unfav(tweet)
            tweet.favoritesCount = tweet.favoritesCount - 1
            tweet.favorited = false
        } else{
            TwitterClient.sharedInstance.fav(tweet)
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
        tableView.estimatedRowHeight = 140

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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
        cell.profileView.addGestureRecognizer(tapGesture)
        cell.profileView.userInteractionEnabled = true
        cell.profileView.tag = indexPath.row
        
        return cell
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView{
            print("image tapped")
            let vc = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            vc.user = tweets[imageView.tag].user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = self.tweets[indexPath!.row]
        
            let detailViewController = segue.destinationViewController as! TweetDetailViewController
            detailViewController.tweet = tweet
        }
    }


}
