//
//  ArrangeThemeCollectionViewController.swift
//  sc9
//
//  Created by bill donner on 12/24/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit


final class   ArrangerCell: UITableViewCell {
    @IBOutlet var alphabetLabel: UILabel!
}
extension ArrangeThemeTableViewController //: UITableViewDelegate
{//
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("tapped color \(newColors[indexPath.item])")
    }
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

        let temp = newColors[fromIndexPath.item] // the character
        
        //shrink source array
        
        newColors.removeAtIndex(fromIndexPath.item)
        
        //insert in dest array
        newColors.insert(temp, atIndex: toIndexPath.item)
        
        self.tableView?.reloadData()
    }
}
extension ArrangeThemeTableViewController{
  override  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
  override  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newColors.count
    }
    
    
  override  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
     let cell = tableView.dequeueReusableCellWithIdentifier(
        "ThemeArrangerCellID", forIndexPath: indexPath) as!ArrangerCell
  
        
        // Configure the cell
        
        cell.contentView.backgroundColor = newColors[indexPath.item]
          return cell

    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}
final class ArrangeThemeTableViewController: UITableViewController {
    
    var nuColors : [UIColor]? // via button
    
    private var newColors : [UIColor] = []
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
          self.tableView.setEditing(editing, animated: true)
        if nuColors != nil {
            newColors = nuColors!
        }
        else
        
        if  let pvc = self.parentViewController as? ThemeArrangerViewController {
            newColors = pvc.newColors
        }
        
        
    }
    
}



   