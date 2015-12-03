//
//  ImportShareViewController.swift
//  SheetCheats
//
//  Created by william donner on 6/17/14.
//  Copyright (c) 2014 william donner. All rights reserved.
//

import UIKit

class ImportShareViewController: UIViewController {
    
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
        assim.assimilateInBackground(documentsPath,
            each: { label,read,dupes in
            self.readcount.text = "\(read)"
            self.dupecount.text = "\(dupes)"
            self.currentfilepath.text = label
            },
            completion: { label,read,dupes in
            self.readcount.text = "\(read)"
            self.dupecount.text = "\(dupes)"
            self.currentfilepath.text = label 
            self.actindicator.hidden = true
            self.navigationItem.leftBarButtonItem?.enabled = true
        })
    }
}