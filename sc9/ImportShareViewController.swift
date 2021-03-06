//
//  ImportShareViewController.swift
//  SheetCheats
//
//  Created by william donner on 6/17/14.
//  Copyright (c) 2014 william donner. All rights reserved.
//

import UIKit

class ImportShareViewController: UIViewController {
    
    @IBOutlet weak var okButton: UIButton!
    @IBAction func okPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToModalMenu2ID", sender: self )
    }
    @IBOutlet weak var importStatus: UILabel!
    @IBOutlet weak var readcount: UILabel!
    
    @IBOutlet weak var dupecount: UILabel!
    
    @IBOutlet weak var actindicator: UIActivityIndicatorView!
    
    @IBOutlet weak var currentfilepath: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        self.navigationItem.title = "Import From iTunes"
        let	assim = Incorporator()
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.okButton.enabled = false
        self.okButton.setTitleColor(Colors.gray, forState: .Normal)
        assim.assimilateInBackground(documentsPath,
            each: { label,read,dupes,csv in
                let fresh = read - dupes
                  self.importStatus.text = "imported \(fresh) documents and \(csv) Configurations"
                
            self.readcount.text = "\(read)"
            self.dupecount.text = "\(dupes)"
            self.currentfilepath.text = label
            },
            completion: { label,read,dupes,csv in
                       let fresh = read - dupes
                self.importStatus.text = "just added \(fresh) shared iTunes documents and \(csv) Configurations"
            self.readcount.text = "\(read)"
            self.dupecount.text = "\(dupes)"
            self.currentfilepath.text = label 
            self.actindicator.hidden = true
            self.okButton.enabled = true
            self.okButton.setTitleColor(Colors.white, forState: .Normal)
        })
    }
}