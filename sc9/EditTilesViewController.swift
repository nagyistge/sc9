//
//  EditTilesViewController.swift
//
//  Created by william donner on 9/29/15.

import UIKit


protocol EditTilesViewDelegate {
    func editTilesViewControllerReturningResults(data:String)
}
extension EditTilesViewDelegate {
    func editTilesViewControllerReturningResults(data:String) {
        print("editTilesViewControllerReturningResults ",data)
    }
}
struct sequeArgs {
    let name:String,key:String,bpm:String,textColor:UIColor,backColor:UIColor
}

final class EditTilesViewController: UICollectionViewController ,  ModelData    {
    
    let formatter = NSDateFormatter() // create just once
    
    func refresh() { // DOES NOT SAVES DATAMODEL
      ////  Globals.saveDataModel()
        self.removeLastSpecialElements()
        addLastSpecialElements()
        
        self.collectionView?.reloadData()
    }
    deinit {
        self.cleanupFontSizeAware(self)
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
        self.removeLastSpecialElements() // clean this up on way out
        self.unwindFromHere(self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.removeLastSpecialElements()
        addLastSpecialElements()
    }
    override func viewDidLoad() {
        super.viewDidLoad()  
        self.setupFontSizeAware(self)

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
        if c == "+" {
            let cc: String = "\(indexPath.section) - \(indexPath.item)"
            let el = self.makeElementFrom(cc)
            self.tileInsert(indexPath,newElement:el)
          
            refresh()
                    Globals.saveDataModel()
        }
       
        else {
            // call single tile editor, telling it where we are
            self.storeStringArgForSeque(c)
            self.storeIndexArgForSeque(indexPath)
            

            
            self.presentEditTile(self)
            }
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
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
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
                uiv.modalPresentationStyle = .FullScreen
                uiv.tileIdx = self.fetchIndexArgForSegue()
                uiv.tileName = self.fetchStringArgForSegue()
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
    func deleteThisTile(path:NSIndexPath) {
        print("Will delete tile at \(path)")
        self.tileRemove(path)
        
        Globals.saveDataModel()
        refresh()
    }
    func     tileDidUpdate(path:NSIndexPath,name:String,key:String,bpm:String,textColor:UIColor,backColor:UIColor){
       let tile = Model.data.tiles[path.section][path.item]
        tile.1.tyleKey = key
        tile.1.tyleBpm = bpm
        tile.1.tyleTextColor = textColor
        tile.1.tyleBackColor = backColor
        tile.1.tyleTitle = name
        
        print("EditTilesViewController is saving  \(tile) \(name) \(key) \(bpm) to: \(path)")
        
        if let cell = self.collectionView?.cellForItemAtIndexPath(path) as? TileCell {
            cell.alphabetLabel.text  = name
            cell.alphabetLabel.backgroundColor = backColor
            cell.alphabetLabel.textColor = textColor
   
            Globals.saveDataModel()
        }
        
        
        refresh()
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

