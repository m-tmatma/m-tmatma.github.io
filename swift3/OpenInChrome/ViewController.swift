//
//  ViewController.swift
//  OpenChrome
//
//  Created by tsuchiyamamasaru on 2016/12/25.
//  Copyright © 2016年 tsuchiyamamasaru. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if OpenInChromeController.sharedInstance.isChromeInstalled() {
            self.label.text = "Installed"
        }
        else {
            self.label.text = "Not Installed"  
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Open(_ sender: Any) {
        let url = URL(string: "http://www.google.co.jp")
        let callbackURL = URL(string: "opcsample://")
        if OpenInChromeController.sharedInstance.openInChrome(url!, callbackURL: callbackURL, createNewTab: true) {
            print("success")
        }
        else {
            print("fail")
        }
    }

}

