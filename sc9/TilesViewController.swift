//
//  TilesViewController.swift
//

import UIKit

final class   TileCell: UICollectionViewCell {
    @IBOutlet var alphabetLabel: UILabel!
    @IBOutlet weak var track: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var bpm: UILabel!
    
    func configureCellFromTile(t:Tyle,invert:Bool = false) {
        let name = t.tyleTitle
        self.alphabetLabel.text = name
        self.track.text = "\(t.tyleID)"
        self.key.text = t.tyleKey
        self.bpm.text = t.tyleBpm
        self.notes.text = t.tyleNote
        
        let bc = t.tyleBackColor
        let fc =  Corpus.findFast(name) ? t.tyleTextColor : Colors.gray
        // if the title isnt found make the label a plain gray
        let frontcolor = invert ? bc : fc
        let backcolor = invert ? fc : bc
        
        self.contentView.backgroundColor = backcolor
        self.backgroundColor = backcolor
        
        self.alphabetLabel.textColor = frontcolor
        self.key.textColor = frontcolor
        self.bpm.textColor = frontcolor
        self.notes.textColor = frontcolor
        
    }
}

protocol TilesViewDelegate {
    func tilesViewControllerReturningResults(data:String)
}
extension TilesViewDelegate {
    func tilesViewControllerReturningResults(data:String) {
        //print("tilesViewControllerReturningResults ",data)
    }
}
extension TilesViewController  { //: UIScrollViewDelegate
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        dispatch_async(dispatch_get_main_queue(),{
            
            // get section from first visible cell
            
            let paths = self.collectionView?.indexPathsForVisibleItems()
            if (paths != nil) {
                let path = paths![0]
                let section = path.section
                let sectionHead = self.sectHeader(section)
                let sectionTitle = sectionHead[SectionProperties.NameKey]
                self.title = sectionTitle
            }
        })
    }
}

final class TilesViewController: UICollectionViewController ,  ModelData    {
    
    var delegate:TilesViewDelegate?
    var longPressOneShot = false
    var observer0 : NSObjectProtocol?  // emsure ots retained
    var observer1 : NSObjectProtocol?  // emsure ots retained
    var av  = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    var lastTapped : NSIndexPath?
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(observer0!)
        NSNotificationCenter.defaultCenter().removeObserver(observer1!)
        self.cleanupFontSizeAware(self)
    }
    
    @IBAction func mainMenuPressed(sender: AnyObject) {
        presentModalMenu(self)
    }
    func refresh() {
        self.collectionView?.backgroundColor = Colors.clear //Colors.mainColor()
        self.view.backgroundColor = Colors.clear //Colors.mainColor()
        self.collectionView?.reloadData()
        longPressOneShot = false // now listen to longPressAgain
        self.av.removeFromSuperview()
    }
    // total surrender to storyboards, everything is done thru performSegue and unwindtoVC
    @IBAction func unwindToTilesViewController( segue:// unwindToVC(segue:
        UIStoryboardSegue) {
    }
    
    @IBAction func modalMenuButtonPressed(sender: AnyObject) {
        self.presentModalMenu(self)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        longPressOneShot = false
        
        //  doesnt work
        
        //        if noTiles() { // no items
        //            // simulate a press if we get here with nothing
        //            NSTimer.scheduledTimerWithTimeInterval(0.01,    target: self, selector: "noItemsSimulatePress", userInfo: nil, repeats: false)
        //        }
    }
    func noItemsSimulatePress() {
        
        //self.navigationController?.popViewControllerAnimated(true)
        print("No Tiles")
        longPressOneShot = false
        presentTilesEditor(self) // if no items then put up tiles editor
        
    }
    func pressedLong() {
        // ensure not getting double hit
        let pvd = self.presentedViewController
        if pvd == nil {
            if longPressOneShot == false {
                //print ("Long Press Presenting Modal Menu ....")
                longPressOneShot = true
                self.presentModalMenu(self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView?.backgroundColor = Colors.clear //Colors.mainColor()
        self.view.backgroundColor = Colors.clear //Colors.mainColor()
        
        self.setupFontSizeAware(self)
        
        observer0 =  NSNotificationCenter.defaultCenter().addObserverForName(kSurfaceRestorationCompleteSignal, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            NSLog  ("Restoration Complete, tilesviewController reacting....")
            self.refresh()
            if self.noTiles()  { // no items
                NSTimer.scheduledTimerWithTimeInterval(0.1,    target: self, selector: "noItemsSimulatePress", userInfo: nil, repeats: false)
            }
        }
        observer1 =  NSNotificationCenter.defaultCenter().addObserverForName(kSurfaceUpdatedSignal, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            print ("Surface was updated, tilesviewController reacting....")
            self.refresh()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var indexPaths:[NSIndexPath]
        indexPaths = []
        // change colorization if a different cell than las
        if lastTapped != nil {
            indexPaths.append(lastTapped!) // record path of old cell
        }
        if indexPath != lastTapped { // if tapping new cell
            // now change this cell
            lastTapped = indexPath
            indexPaths.append(indexPath)
            if indexPaths.count != 0 {
                collectionView.reloadItemsAtIndexPaths(indexPaths)
            }
        }
        // ok show the document
        showDoc(self,named:self.tileData(indexPath).tyleTitle)
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
                
                headerView.headerLabel.text = self.sectHeader(indexPath.section)[SectionProperties.NameKey]
                headerView.headerLabel.textColor = Colors.gray//headerTextColor()
                headerView.headerLabel.backgroundColor = Colors.headerColor()
                // headerView.headerLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                let tgr = UITapGestureRecognizer(//UILongPressGestureRecognizer
                    
                    
                    target: self, action: "pressedLong")
                headerView.addGestureRecognizer(tgr)
                return headerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TileCellID", forIndexPath: indexPath) as!   TileCell
        
        let invert =
        lastTapped != nil && indexPath.section  == lastTapped!.section && indexPath.item  == lastTapped!.item
        // Configure the cell
        cell.configureCellFromTile(self.tileData(indexPath),invert:invert)
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
        longPressOneShot = false
    }
}
extension TilesViewController: FontSizeAware {
    func refreshFontSizeAware(vc: TilesViewController) {
        vc.collectionView?.reloadData()
    }
}

extension TilesViewController: ShowContentDelegate {
    func userDidDismiss() {
        // print("user dismissed Content View Controller")
    }
}
///////////////////////////////////////////////