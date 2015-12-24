//
//  ThemePickerViewController.swift
//  sc9
//
//  Created by bill donner on 12/11/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit


class ThemePickerCell:UITableViewCell {
    var outerView: UIView!
    override func prepareForReuse() {
        super.prepareForReuse()
        // remove subviews we added to contentview
        for j in 1...7// do them all
        {
            let v = viewWithTag(j)
            v?.removeFromSuperview()
        }
        self.outerView.removeFromSuperview()
    }
    func setupFromBaseColor(basecolor:UIColor,name:String) {
        
        let innerFrame = UIEdgeInsetsInsetRect(self.contentView.frame,UIEdgeInsetsMake(10.0, 10.0, 10.0,  10.0))
        let ov = UIView(frame:innerFrame)
        ov.backgroundColor = Colors.clear //temp
        
        self.outerView = ov
        
        self.contentView.addSubview(self.outerView)
        
        // now simplify down to just flat complimentary
        let colors:NSArray  = ColorSchemeOf(ColorScheme.Complementary, color: basecolor, isFlatScheme: true)
        
        //add to contentView
        let h = self.outerView.frame.height
        let w = self.outerView.frame.width / CGFloat(colors.count + 1)
        var pos:CGFloat = 0.0
        var inc  = 0
        // lay down a clear cell with plain white label
        
        let v = UIView(frame:CGRect(x: pos, y: 0, width:w,height: h))
        v.backgroundColor = Colors.clear
        v.tag = 2
        self.outerView.addSubview(v)
        let lab = UILabel(frame:CGRect(x:pos,y:0,width: w,height:h))
        lab.backgroundColor = Colors.clear
        
        // set the text to something contrasty
        lab.textColor =  Colors.black // cause broken
        lab.text = name
        lab.textAlignment = .Center
        lab.minimumScaleFactor = 0.3
        lab.adjustsFontSizeToFitWidth = true
        lab.numberOfLines = 0
        lab.tag = 1
        v.addSubview(lab)
        pos += w
        for c in colors {
            let v = UIView(frame:CGRect(x: pos, y: 0, width:w,height: h))
            if let cc = c as? UIColor {
            v.backgroundColor = cc
                 }
            v.tag = 3 + inc
            self.outerView.addSubview(v)
           
            pos += w
            inc += 1
        }
        
    }
}
protocol ThemePickerDelegate {
    func themePickerReturningResults(data:NSArray)
}

class ThemePickerViewController: UIViewController,SegueHelpers {
    var delegate:ThemePickerDelegate?
    //var colors: NSArray = NSArray()
    var selectedIndexPath: NSIndexPath?
    @IBAction func done(sender: AnyObject) {
        
        self.performSegueWithIdentifier("unwindToSettings", sender: self)
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    func repaint() {
        self.tableView.reloadData()
    }
    @IBAction func stylesegPushed(sender: AnyObject) {
        ()
    }
    
    @IBAction func flatGlossyPushed(sender: AnyObject) {
        repaint()
    }
    
    @IBOutlet weak var useItButton: UIBarButtonItem!
    
    @IBAction func nextPushed(sender: AnyObject) {
        let idx = self.selectedIndexPath!.row
        let basecolor = Colors.allColors[idx]
        let name = Colors.allColorNames[idx]
        print("Did select \(name) \(basecolor) for arrangement by user")
        
        // move to new viewcontroller passing only the index
        
        storeIntArgForSeque(idx)
        presentThemeMapper(self)
        
    }
    @IBAction func unwindToThemePickerViewController(segue: UIStoryboardSegue) {
      print("Unwound to unwindToThemePickerViewController")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.prepForSegue(segue , sender: sender)
        // theme mapper is now wrapped in nav yet needs argument
        if let nav = segue.destinationViewController as? UINavigationController {
        if let uiv = nav.topViewController as? ThemeMapperViewController {
            uiv.modalPresentationStyle = .FullScreen
         uiv.colorIdx = self.fetchIntArgForSegue()!
        }
}
    }
    
    func makeColors(idx:Int, sg:Int = 0) {


    let  newColors  = ColorSchemeOf(ColorScheme.Complementary, color: Colors.allColors[idx], isFlatScheme: true)

    
    // announce what we have done
    
    Globals.shared.mainColors = newColors
    NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceUpdatedSignal,object:nil)

    }


    @IBOutlet weak var tableView: UITableView!
    
    deinit {
        self.cleanupFontSizeAware(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.setStatusBarStyle(UIStatusBarStyleContrast)//
        
        self.navigationController?.navigationItem.rightBarButtonItem?.enabled = false
        // shudnt register when prototype cell is from storyboard
        //        self.tableView.registerClass(ThemePickerCell.self, forCellReuseIdentifier: "ThemePickerCellID")
        //self.tableView.estimatedRowHeight = 120
        // self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = Colors.clear
        self.view.backgroundColor = Colors.clear
        self.setupFontSizeAware(self)
        //styleSegCtl.removeFromSuperview()
        //flatGlossyCtl.removeFromSuperview()
        self.repaint()
    }
}
extension ThemePickerViewController:UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Colors.allColors.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ThemePickerCellID", forIndexPath: indexPath) as! ThemePickerCell
        
        let idx = indexPath.row
        cell.setupFromBaseColor(Colors.allColors[idx],name:Colors.allColorNames[idx])

        return cell
    }
}


extension ThemePickerViewController : UITableViewDelegate {//
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let h : CGFloat = 44.0
//        let v = UIView(frame:CGRect(x:0,y:0,width:tableView.frame.width,height:h))
//        v.backgroundColor = Colors.gray
//        let w = tableView.frame.width / CGFloat(colors.count)
//        var pos : CGFloat  = 0.0
//        for j in 0..<colors.count {
//            let lab = UILabel(frame:CGRect(x:pos,y:0,width:w,height:h))
//            lab.text = headers[j]
//            lab.textAlignment = .Center
//            lab.textColor = Colors.black
//            v.addSubview(lab)
//            pos += w
//        }
//        return v
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //ok, selected
        self.selectedIndexPath = indexPath
//        let idx = indexPath.row
//        let basecolor = Colors.allColors[idx]
//        let name = Colors.allColorNames[idx]
//        self.view.backgroundColor = basecolor
//        self.tableView.backgroundColor = basecolor
//        self.title = name
//        self.navigationController?.title = name
//        self.useItButton.enabled = true
        
        self.nextPushed(self)
        
    }
}
extension ThemePickerViewController : FontSizeAware {
    func refreshFontSizeAware(vc:ThemePickerViewController) {
        vc.tableView.reloadData()
    }
}