//
//  EditTilesViewController.swift
//
//  Created by william donner on 9/29/15.

import UIKit

class  TileSequeArgs {
    var name:String = "",key:String = "",bpm:String = "",
        textColor:UIColor = Colors.tileTextColor(),
        backColor:UIColor = Colors.tileColor()
}


final class EditTilesViewController: UICollectionViewController ,  ModelData    {
    
    let formatter = NSDateFormatter() // create just once
    
    func refresh() { // DOES NOT SAVE DATAMODEL
        self.collectionView?.backgroundColor = Colors.mainColor()
        self.view.backgroundColor = Colors.mainColor()
        self.collectionView?.reloadData()
    }
    
    
    var addSectionBBI: UIBarButtonItem!
    @IBAction func editSections() {
        self.presentSectionEditor(self)
    }
    // total surrender to storyboards, everything is done thru performSegue and unwindtoVC
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        // print("Unwound to EditTilesViewController")
    }
    
    @IBAction func finallyDone(sender: AnyObject) {
        //  self.removeLastSpecialElements() // clean this up on way out
        self.unwindFromHere(self)
    }
    
    var  currentTileIdx:NSIndexPath?
    
    var observer1 : NSObjectProtocol?  // emsure ots retained
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(observer1!)
        self.cleanupFontSizeAware(self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      //  self.navigationItem.leftBarButtonItem?.enabled =
        if  self.sectCount() == 0 {
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .MediumStyle
        let sectitle = "autogenerated " + formatter.stringFromDate(NSDate())
        let ip = NSIndexPath(forRow:0, inSection:0)
        self.makeHeaderAt(ip , labelled: sectitle)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = Colors.mainColor()
        self.view.backgroundColor = Colors.mainColor()
        self.setupFontSizeAware(self)
        observer1 =  NSNotificationCenter.defaultCenter().addObserverForName(kSurfaceUpdatedSignal, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            print ("Surface was updated, edittilesviewController reacting....")
            self.refresh()
        }
    }
}

// MARK: - UICollectionViewDelegate

// these would be delegates but that is already done because using UICollectionViewController

extension EditTilesViewController {
    //: UICollectionViewDelegate{
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let tyle = self.tileData(indexPath)
        // prepare for seque here
        let tsarg = TileSequeArgs()
        // set all necessary fields
        tsarg.name = tyle.tyleTitle
        tsarg.key = tyle.tyleKey
        tsarg.bpm = tyle.tyleBpm
        tsarg.textColor = tyle.tyleTextColor
        tsarg.backColor = tyle.tyleBackColor
        
        self.storeIndexArgForSeque(indexPath)
        self.storeTileArgForSeque(tsarg)
        self.presentEditTile(self)
    }
}

// MARK: - UICollectionViewDataSource

extension EditTilesViewController {
    //: UICollectionViewDataSource {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.tileSectionCount()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tileCountInSection(section)
    }
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "sectionheaderid",
                    forIndexPath: indexPath)
                    as! TilesSectionHeaderView
   
                headerView.headerLabel.text = self.sectHeader(indexPath.section)[SectionProperties.NameKey]
                headerView.headerLabel.textColor = Colors.headerTextColor()
                headerView.headerLabel.backgroundColor = Colors.headerColor()
                headerView.headerLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                headerView.tag = indexPath.section
                // add a tap gesture recognizer
                
                let tgr = UITapGestureRecognizer(target: self,action:"headerTapped:")
                headerView.addGestureRecognizer(tgr)
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
    }
    
    
 
    func headerTapped(tgr:UITapGestureRecognizer) {
        let v = tgr.view
        if v != nil {
            let sec = v!.tag // numeric section number
            let max = tileCountInSection(sec)
            let indexPath = NSIndexPath(forItem:max,inSection:sec)
            
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Actions For This Section \(sec) ?", message: "Can not be undone", preferredStyle: .ActionSheet )
            //
            //	//Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //		  Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            
            //Create and add first option action
            actionSheetController.addAction(UIAlertAction(title: "New Tile", style: .Default ) { action -> Void in
                self.makeTileAt(indexPath,labelled:"\(sec) - \(max)")
                self.refresh()
                Globals.saveDataModel()
                // self.unwindFromHere(self)
                })
            //Create and add first option action
            actionSheetController.addAction(UIAlertAction(title: "Rename This Section", style: .Default ) { action -> Void in
                self.storeIntArgForSeque(sec)
                self.presentSectionRenamor(self)
                // self.unwindFromHere(self)
                })
            //  We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = tgr.view! as UIView
            
            //  Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EditingTileCell", forIndexPath: indexPath) as!   TileCell
        
        // Configure the cell
        cell.configureCellFromTile(self.tileData(indexPath))
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath,toIndexPath destinationIndexPath: NSIndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section {
            mswap2(sourceIndexPath, destinationIndexPath)
        }
        else {
            mswap(sourceIndexPath, destinationIndexPath)
        }
    }
    
}

extension EditTilesViewController:SegueHelpers {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.prepForSegue(segue , sender: sender)
        if let uiv = segue.destinationViewController as? ThemePickerViewController {
            uiv.modalPresentationStyle = .FullScreen
            uiv.delegate  =    self
        }
        if let uiv = segue.destinationViewController as? SectionRenamorViewController {
            uiv.modalPresentationStyle = .FullScreen
            uiv.sectionNum =     self.fetchIntArgForSegue()
        }
        
        
        if let uiv = segue.destinationViewController as? SectionsEditorViewController {
            uiv.modalPresentationStyle = .FullScreen
            uiv.delegate = self
        }
        if let uiv = segue.destinationViewController as?
            TilePropertiesEditorViewController {
                // record which cell we are sequeing away from even if we never tell the editor
                
                self.currentTileIdx = self.fetchIndexArgForSegue()
                uiv.modalPresentationStyle = .FullScreen
                uiv.tileIncoming = self.fetchTileArgForSegue()
                uiv.tileIdx = self.currentTileIdx
                uiv.delegate = self
        }
        
    }
}
extension EditTilesViewController: FontSizeAware {
    func refreshFontSizeAware(vc: TilesViewController) {
        vc.collectionView?.reloadData()
    }
}
extension EditTilesViewController:ThemePickerDelegate {
    
    func themePickerReturningResults(data:NSArray) {
        print ("In edittiles theme returned \(data)")
    }
    
}
extension EditTilesViewController: ShowContentDelegate {
    func userDidDismiss() {
        print("user dismissed Content View Controller")
    }
}

// only the editing version of this controller gets these extra elegates
extension EditTilesViewController:TilePropertiesEditorDelegate {
    func deleteThisTile() {
        if self.currentTileIdx != nil {
            self.tileRemove(self.currentTileIdx!)
            
            Globals.saveDataModel()
            refresh()
        }
    }
    func tileDidUpdate(name name:String,key:String,bpm:String,textColor:UIColor, backColor:UIColor){
        
        if self.currentTileIdx != nil {
            
            let tyle = elementFor(self.currentTileIdx!)
            tyle.tyleTitle = name
            tyle.tyleBpm = bpm
            tyle.tyleKey = key
            tyle.tyleTextColor = textColor
            tyle.tyleBackColor = backColor
            
            setElementFor(self.currentTileIdx!, el: tyle)
            
            
            if let cell = self.collectionView?.cellForItemAtIndexPath(self.currentTileIdx!) as? TileCell {
                //
//                print ("updating tile at \(self.currentTileIdx!) ")
//                
//                cell.alphabetLabel.text  = name
//                cell.alphabetLabel.backgroundColor = backColor
//                cell.alphabetLabel.textColor = textColor
                
                cell.configureCellFromTile(tyle)
                
                
            }
            Globals.saveDataModel()
            
            refresh()
        }
    }
}



extension EditTilesViewController: SectionsEditorDelegate {
    func makeNewSection(i:Int) {
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .MediumStyle
        let sectitle = formatter.stringFromDate(NSDate())
        let ip = NSIndexPath(forRow:i, inSection:0)
        self.makeHeaderAt(ip , labelled: sectitle)
        
        Globals.saveDataModel()
        refresh()
    }
    func deleteSection(i: Int) { // removes whole section without a trace
        self.deleteSect(i)
        
        Globals.saveDataModel()
        refresh()
    }
    func moveSections(from:Int,to:Int) {
        self.moveSects(from, to)
        
        Globals.saveDataModel()
        refresh()
    }
}
/// all the IB things need to be above here in the final classes

