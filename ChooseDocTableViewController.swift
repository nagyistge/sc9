//
//  ChooseDocTableViewController.swift
//  stories
//
//  Created by bill donner on 7/10/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit


// cache the documentChooser controller

var chooseDocTableViewController : ChooseDocTableViewController?
func chooseDocVC () -> ChooseDocTableViewController {
    if chooseDocTableViewController == nil {
        chooseDocTableViewController = UIStoryboard(name:"Main",bundle:nil).instantiateViewControllerWithIdentifier("ChooseDocTableViewControllerID") as? ChooseDocTableViewController
    }
    return chooseDocTableViewController!
}


class ChooseDocTableViewController: TitlesTableViewControllerInternal {
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    //    @IBAction func addStuff(sender: AnyObject) {
    //        return itunesImport()
    //    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//      		let idx = matcoll[indexPath.section][indexPath.row]
//        backData = incoming[idx].title
//        print("Tapped row \(indexPath.row) title \(backData)")
//        self.performSegueWithIdentifier("unwindFromChooseDoc", sender: self)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}