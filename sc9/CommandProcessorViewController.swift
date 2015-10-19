//
//  CommandProcessorViewController.swift
//  stories
//
//  Created by bill donner on 7/22/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

// MARK: - (abstract) Surface Model Objects drive ViewController

// MARK: CommandTodayViewController is called to handle OpenURL

class CommandProcessorViewController: UIViewController  { //PagedListViewController {
    var command: String?
    
    override func viewDidLoad() {
        func parse(s:String) -> [String] {
            return s.componentsSeparatedByString("/")
        }
        
        super.viewDidLoad()

        if let s = command {
            print("Command: \(s)")
            if s.hasPrefix("sheets://") {
                let ns = s as NSString
                let parts = parse(ns.substringFromIndex(9))
                print ("Parts: \(parts)")
                
                // turn it into a title
               let titl = parts[2] as NSString
                let _ = titl.stringByReplacingOccurrencesOfString("+", withString: " ")
                
               // presentPreviewController(s,urls: Corpus.lookup(s))
                

            }
        }
        
    }
    
   }
