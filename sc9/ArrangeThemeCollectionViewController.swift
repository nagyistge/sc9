//
//  ArrangeThemeCollectionViewController.swift
//  sc9
//
//  Created by bill donner on 12/24/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit


final class   ThemeArrangerCell: UICollectionViewCell {
 @IBOutlet var alphabetLabel: UILabel!
}

final class ArrangeThemeCollectionViewController: UICollectionViewController {
    
    private var newColors : [UIColor] = []

    override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
        if  let pvc = self.parentViewController as? ThemeArrangerViewController {
            self.newColors = pvc.newColors
        }

        self.installsStandardGestureForInteractiveMovement = true
        
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  newColors.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThemeArrangerCellIDx", forIndexPath: indexPath) as! ThemeArrangerCell
        
        // Configure the cell

        cell.contentView.backgroundColor = newColors[indexPath.item]
      
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            
            print("Did select item in childviewcontroller")
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath,toIndexPath destinationIndexPath: NSIndexPath) {
        
        
        
        let temp = newColors[sourceIndexPath.item] // the character
        
        //shrink source array
        
        newColors.removeAtIndex(sourceIndexPath.item)
        
        //insert in dest array
        newColors.insert(temp, atIndex: destinationIndexPath.item)
        
        self.collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}
