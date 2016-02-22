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
        TwitterClient.sharedInstance.login({ () -> () in
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }) { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
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

