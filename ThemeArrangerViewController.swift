

//
//  ThemeMapperViewController
//  sc9
//
//  Created by bill donner on 12/19/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
final class   ThemeArrangerCell: UICollectionViewCell {
    @IBOutlet var alphabetLabel: UILabel!
}
final class ThemeArrangerViewController: UIViewController , SegueHelpers,FontSizeAware,ModelData {
    var colorIdx: Int = 0 // property
    private var colorIndex : Int = 0
    private var newColors: [UIColor] = []


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func unwinder() {
            self.performSegueWithIdentifier("unwindToThemePickerID", sender: self)
    }
    @IBAction func cancel(sender: AnyObject) {
        unwinder()
    }
    
    @IBAction func use(sender: AnyObject) {
        
        publishColors(  self.colorIndex)
        self.unwindFromHere(self)// try to go back to main meu
        //self.dismissViewControllerAnimated(true, completion: nil)
        //blow out the whole infrastructure
    }
    
    func publishColors(idx:Int, sg:Int = 0) {
        
        let basecolor = Colors.allColors[idx]
        switch  sg {
        case  0:      newColors  = ColorSchemeOf(ColorScheme.Complementary, color: basecolor, isFlatScheme: true)
        case 1:      newColors  = ColorSchemeOf(ColorScheme.Triadic, color: basecolor, isFlatScheme: true)
        default:      newColors  = ColorSchemeOf(ColorScheme.Analogous, color: basecolor, isFlatScheme: true)
        }
        
        // announce what we have done
        print("New colors \(newColors)")
        
        Globals.shared.mainColors = newColors
        Persistence.colorScheme = Colors.allColorNames[idx]
        NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceUpdatedSignal,object:nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupFontSizeAware(self)
        self.colorIndex = colorIdx

        self.navigationItem.title = "Mapping \(Colors.allColorNames[self.colorIndex])"
        newColors = ColorSchemeOf(ColorScheme.Complementary, color: Colors.allColors[colorIdx], isFlatScheme: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForHeader( frame:CGRect) -> UIView? {
        let h : CGFloat = 44.0
        let v = UIView(frame:CGRect(x:0,y:0,width:frame.width,height:h))
        v.backgroundColor = Colors.gray
        let w = frame.width / CGFloat(newColors.count)
        var pos : CGFloat  = 0.0
        for j in 0..<newColors.count {
            let lab = UILabel(frame:CGRect(x:pos,y:0,width:w,height:h))
            lab.text = Colors.typesofColor[j]
            lab.textAlignment = .Center
            lab.textColor = Colors.black
            v.addSubview(lab)
            pos += w
        }
        return v
    }
    func viewForFooter( frame:CGRect) -> UIView? {
        
        let h = frame.height
        let hh = h/10
        let tileh = 3*h/10
        
        let delta:CGFloat = 10
       
        
        let outer = UIView(frame:frame)
        outer.backgroundColor = Colors.white
        let v = UILabel(frame:CGRect(x:delta,y:delta,width:frame.width-2*delta,height:h-delta))
        v.backgroundColor = newColors[0]//
        v.textAlignment = .Right
        v.text = "background text"
        v.textColor = Colors.mainTextColor()

        
        var hpos :CGFloat = 0
         var ypos: CGFloat =  10
        let headerbody = UILabel(frame:CGRect(x:hpos,y:ypos,width:v.frame.width,height:hh))
        headerbody.backgroundColor = newColors[1]//Colors.headerColor()
        headerbody.text = "Header Text Goes Here"
        headerbody.textColor = UIColor(contrastingBlackOrWhiteColorOn:headerbody.backgroundColor, isFlat:true)
        v.addSubview(headerbody)
        ypos += headerbody.frame.height
       
        
        let tileA = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileA.backgroundColor = newColors[2]
        tileA.textAlignment = .Center
        tileA.text = "Tune Title"
        tileA.numberOfLines = 0
        tileA.textColor = UIColor(contrastingBlackOrWhiteColorOn:tileA.backgroundColor, isFlat:true)
        v.addSubview(tileA)
        hpos += tileh+delta
        
        let tileAP = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileAP.backgroundColor = newColors[2]
        tileAP.textAlignment = .Center
        tileAP.text = "Tune Fail"
        tileAP.numberOfLines = 0
        tileAP.textColor = Colors.gray //UIColor(contrastingBlackOrWhiteColorOn:tileA.backgroundColor, isFlat:true)
        v.addSubview(tileAP)
        hpos += tileh+delta
        
        let tileB = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileB.backgroundColor = newColors[3]
        tileB.textAlignment = .Center
        tileB.text = "Alt Tune"
         tileB.numberOfLines = 0
        tileB.textColor = UIColor(contrastingBlackOrWhiteColorOn:tileB.backgroundColor, isFlat:true)
        v.addSubview(tileB)
        hpos += tileh+delta
        
        let tileBP = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileBP.backgroundColor = newColors[3]
        tileBP.textAlignment = .Center
        tileBP.text = "Alt Fail"
        tileBP.numberOfLines = 0
        tileBP.textColor = Colors.gray //UIColor(contrastingBlackOrWhiteColorOn:tileA.backgroundColor, isFlat:true)
        v.addSubview(tileBP)
        hpos += tileh+delta
        
        let tileC = UILabel(frame:CGRect(x:hpos,y:ypos,width:tileh,height:tileh))
        tileC.backgroundColor = newColors[4]
        tileC.textAlignment = .Center
        tileC.text = "Spacer"
         tileC.numberOfLines = 0
        tileC.textColor = UIColor(contrastingBlackOrWhiteColorOn:tileC.backgroundColor, isFlat:true)
        v.addSubview(tileC)
        hpos += tileh+delta
        
        ypos += tileA.frame.height

        outer.addSubview(v)
        return outer
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionHeader:
                //3
                let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "collectionheaderid",
                    forIndexPath: indexPath)
                headerView.addSubview(viewForHeader(headerView.frame)!)
                return headerView
            case UICollectionElementKindSectionFooter:
                //3
                let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "collectionfooterid",
                    forIndexPath: indexPath)
                footerView.addSubview(viewForFooter(footerView.frame)!)
                return footerView
            default:
                //4
                assert(false, "Unexpected element kind")
            }
    }
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return  newColors.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThemeMapperCellID", forIndexPath: indexPath) as! ThemeMapperCell
        
        // Configure the cell
        
        let clr = newColors[indexPath.item]
            
            cell.contentView.backgroundColor = clr
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
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
