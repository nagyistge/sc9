//
//  ThemeMapperViewController
//  sc9
//
//  Created by bill donner on 12/19/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
final class   ThemeMapperCell: UICollectionViewCell {
    @IBOutlet var alphabetLabel: UILabel!
}
final class ThemeMapperViewController: UICollectionViewController , SegueHelpers,FontSizeAware,ModelData {
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
        
        let fg = 1
        let basecolor = Colors.allColors[idx]
        switch  sg {
        case  0:      newColors  = ColorSchemeOf(ColorScheme.Complementary, color: basecolor, isFlatScheme: fg == 0 )
        case 1:      newColors  = ColorSchemeOf(ColorScheme.Triadic, color: basecolor, isFlatScheme: fg == 0 )
        default:      newColors  = ColorSchemeOf(ColorScheme.Analogous, color: basecolor, isFlatScheme: fg == 0 )
        }
        
        // announce what we have done
        print("New colors \(newColors)")
        
        Globals.shared.mainColors = newColors
        NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceUpdatedSignal,object:nil)
        
    }
    
//    func useTheColorPressed() {
//        
//        publishColors(  self.colorIndex)
//        
//    unwinder()
//        
//    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupFontSizeAware(self)
        self.colorIndex = colorIdx
      //  print("Mapping \(Colors.allColorNames[self.colorIndex]) \(Colors.allColors[self.colorIndex])")
        self.navigationItem.title = "Mapping \(Colors.allColorNames[self.colorIndex])"
        newColors = ColorSchemeOf(ColorScheme.Complementary, color: Colors.allColors[colorIdx], isFlatScheme: true)
        
        
        //        // Register cell classes
        //        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ThemeMapperCellID")
        
        // Do any additional setup after loading the view.
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
//                headerView.headerLabel.text = self.sectHeader(indexPath.section)[SectionProperties.NameKey]
//                headerView.headerLabel.textColor = Colors.headerTextColor()
//                headerView.headerLabel.backgroundColor = Colors.headerColor()
//                headerView.headerLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                return headerView
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
//        } else {
//            cell.contentView.backgroundColor = Colors.clear
//        }
        
        //print("COLOR \(cell.contentView.backgroundColor!)")
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
