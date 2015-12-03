//
//  EditTilesViewController.swift
//
//  Created by william donner on 9/29/15.

import UIKit

class  TileSequeArgs {
    var name:String = "",key:String = "",bpm:String = "",textColor:UIColor = .whiteColor(),backColor:UIColor = .blackColor() }

//protocol EditTilesViewDelegate {
//    func editTilesViewControllerReturningResults(data:TileSequeArgs)
//}
//extension EditTilesViewDelegate {
//    func editTilesViewControllerReturningResults(data:TileSequeArgs) {
//        print("editTilesViewControllerReturningResults ",data)
//    }
//}


final class EditTilesViewController: UICollectionViewController ,  ModelData    {
    
    let formatter = NSDateFormatter() // create just once
    
    func refresh() { // DOES NOT SAVE DATAMODEL
        ////  Globals.saveDataModel()
//        self.removeLastSpecialElements()
//        addLastSpecialElements()
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
//        self.removeLastSpecialElements()
//        addLastSpecialElements()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // dont allow editing the last element in a section because its a "+" marker tile
        
        if self.tileData(indexPath).0[ElementProperties.NameKey]! == "+" {return false}
        
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // did select item goes off differently depending on whether editable or not
        if  let c = self.tileData(indexPath).0[ElementProperties.NameKey] {
//            if c == "+" {
//                let cc: String = "\(indexPath.section) - \(indexPath.item)"
//                let el = self.makeElementFrom(cc)
//                self.tileInsert(indexPath,newElement:el)
//                
//                refresh()
//                Globals.saveDataModel()
//            }
//                
//            else {
                // call single tile editor, telling it where we are
               // self.storeStringArgForSeque(c)
                
                let tyle = self.tileData(indexPath).1
                // prepare for seque here
                let tsarg = TileSequeArgs()
                // set all necessary fields
                tsarg.name = c
            tsarg.key = tyle.tyleKey
            tsarg.bpm = tyle.tyleBpm
            tsarg.textColor = tyle.tyleTextColor
            tsarg.backColor = tyle.tyleBackColor
            
                self.storeIndexArgForSeque(indexPath)
                self.storeTileArgForSeque(tsarg)
                self.presentEditTile(self)
            //}
        }
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
                
                headerView.headerLabel.text = self.sectHeader(indexPath.section)[ElementProperties.NameKey]!
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
            let el = self.makeElementFrom("\(sec) - \(max)")
            self.tileInsert(indexPath,newElement:el)
            
            refresh()
            Globals.saveDataModel()
            
        }
     
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TileCell", forIndexPath: indexPath) as!   TileCell
        
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
        
        if let uiv = segue.destinationViewController as? SectionsEditorViewController {
            uiv.modalPresentationStyle = .FullScreen
            uiv.delegate = self
        }
        if let uiv = segue.destinationViewController as?
            TileEditorViewController {
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

extension EditTilesViewController: ShowContentDelegate {
    func userDidDismiss() {
        print("user dismissed Content View Controller")
    }
}

// only the editing version of this controller gets these extra elegates
extension EditTilesViewController:TileEditorDelegate {
    func deleteThisTile() {
        if self.currentTileIdx != nil {
        self.tileRemove(self.currentTileIdx!)
        
        Globals.saveDataModel()
        refresh()
        }
    }
    func     tileDidUpdate(name name:String,key:String,bpm:String,textColor:UIColor, backColor:UIColor){
        
         if self.currentTileIdx != nil {
            
            let el = elementFor(self.currentTileIdx!)
            let tyle = el.1
            tyle.tyleTitle = name
            tyle.tyleBpm = bpm
            tyle.tyleKey = key
            tyle.tyleTextColor = textColor
            tyle.tyleBackColor = backColor
            
           setElementFor(self.currentTileIdx!, el: el)

        
        if let cell = self.collectionView?.cellForItemAtIndexPath(self.currentTileIdx!) as? TileCell {
            //
            print ("updating tile at \(self.currentTileIdx!) ")
            
            cell.alphabetLabel.text  = name
            cell.alphabetLabel.backgroundColor = backColor
            cell.alphabetLabel.textColor = textColor
            
           
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
        let hdr = self.makeHeaderFrom(sectitle)
        self.makeNewSect(i,hdr:hdr)
        
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

