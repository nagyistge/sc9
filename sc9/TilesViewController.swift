//
//  TilesViewController.swift
//

import UIKit

protocol TilesViewDelegate {
    func tilesViewControllerReturningResults(data:String)
}
extension TilesViewDelegate {
    func tilesViewControllerReturningResults(data:String) {
        print("tilesViewControllerReturningResults ",data)
    }
}

final class TilesViewController: UICollectionViewController ,  ModelData    {
 
    var delegate:TilesViewDelegate?
    var longPressOneShot = false
    var observer0 : NSObjectProtocol?  // emsure ots retained
    var observer1 : NSObjectProtocol?  // emsure ots retained
    deinit{

        NSNotificationCenter.defaultCenter().removeObserver(observer0!)
        NSNotificationCenter.defaultCenter().removeObserver(observer1!)

        self.cleanupFontSizeAware(self)
    }
    
    func refresh() {
        self.collectionView?.reloadData()
        longPressOneShot = false // now listen to longPressAgain
    }
    // total surrender to storyboards, everything is done thru performSegue and unwindtoVC
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        // unwinding
       // print("Unwound to TilesViewController")
        if Model.data.tiles.count == 0 { // no items
            // simulate a press if we get here with nothing
            NSTimer.scheduledTimerWithTimeInterval(0.1,    target: self, selector: "noItemsSimulatePress", userInfo: nil, repeats: false)
        } else {
            self.refresh()
        }
    }
    
    @IBAction func modalMenuButtonPressed(sender: AnyObject) {
        self.presentModalMenu(self)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // self.navigationController?.presentTransparentNavigationBar()
        if Model.data.tiles.count == 0 { // no items
            // simulate a press if we get here with nothing
            NSTimer.scheduledTimerWithTimeInterval(0.1,    target: self, selector: "noItemsSimulatePress", userInfo: nil, repeats: false)
        }
    }
    func noItemsSimulatePress() {

        //self.navigationController?.popViewControllerAnimated(true)
        print("No Tiles")
        longPressOneShot = false
              presentTilesEditor(self) // if no items then put up tiles editor
        
    }
    func pressedLong() {
        if longPressOneShot == false {
           // print ("Long Press Presenting Modal Menu ....")
            self.presentModalMenu(self)
            longPressOneShot = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "T I L E S"
        
        
        self.removeLastSpecialElements()
        //Model.data.describe()
        self.setupFontSizeAware(self)

        let tgr = UILongPressGestureRecognizer(target: self, action: "pressedLong")
        self.view.addGestureRecognizer(tgr)
        observer0 =  NSNotificationCenter.defaultCenter().addObserverForName(kSurfaceRestorationCompleteSignal, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            print ("Restoration Complete, tilesviewController reacting....")
            self.refresh()
            
            if Model.data.tiles.count == 0 { // no items
    
                NSTimer.scheduledTimerWithTimeInterval(0.1,    target: self, selector: "noItemsSimulatePress", userInfo: nil, repeats: false)
            }
        }
        
        observer1 =  NSNotificationCenter.defaultCenter().addObserverForName(kSurfaceUpdatedSignal, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
           // print ("Surface was updated, tilesviewController reacting....")
            self.refresh()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // in this case, show content
        self.storeStringArgForSeque(    self.tileData(indexPath).0[ElementProperties.NameKey]! )
        self.presentContent(self)
    }
}
extension TilesViewController {
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
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "sectionheaderid",
                    forIndexPath: indexPath)
                    as! TilesSectionHeaderView
                
                headerView.headerLabel.text = self.sectHeader(indexPath.section)[ElementProperties.NameKey]
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
}

extension TilesViewController:SegueHelpers {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == nil {
            // unwinding
            self.refresh()
        } else {
            self.prepForSegue(segue , sender: sender)
        }
    }
}
extension TilesViewController: FontSizeAware {
    func refreshFontSizeAware(vc: TilesViewController) {
        vc.collectionView?.reloadData()
    }
}

extension TilesViewController: ShowContentDelegate {
    func userDidDismiss() {
        print("user dismissed Content View Controller")
    }
}
///////////////////////////////////////////////