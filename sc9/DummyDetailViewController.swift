//
//  DummyDetailViewController.swift
//  stories
//
//  Created by bill donner on 9/21/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

class DummyDetailViewController: UIViewController {
    var s: Startup?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Globals.shared.restored == false {
            // if we are not restored, probably because the detail view controller has never been shown, then push to a detail view to run the initial animations, etc
            
            //            let vc =  DummyDetailViewController()
            //            self.navigationController?.pushViewController(vc, animated: true)
       
        self.navigationItem.leftBarButtonItem?.enabled = false
        s = Startup()
        print("Startup Animations beginning...")
        let animationView = s!.startup(self) {
            print("Startup Sequence ending...")
            self.s!.finish(self)
            self.navigationItem.leftBarButtonItem?.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil) // bug out
        }
           
        self.view.addSubview(animationView)
        } else {
            print ("Restore flag was already set at startup")
        }
 }
}
    


