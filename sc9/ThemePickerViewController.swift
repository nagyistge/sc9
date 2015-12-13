//
//  ThemePickerViewController.swift
//  sc9
//
//  Created by bill donner on 12/11/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit


class ThemePickerCell:UITableViewCell {
    override func prepareForReuse() {
        // throw out old colors, etc
        self.contentView.backgroundColor = nil
        self.textLabel?.backgroundColor = nil
        self.textLabel?.textColor = nil
        // remove subviews we added to contentview
        for j in 1...6// do them all
        {
            let v = viewWithTag(j)
            v?.removeFromSuperview()
        }
        
    }
}
protocol ThemePickerDelegate {
    func themePickerReturningResults(data:NSArray)
}

class ThemePickerViewController: UIViewController {
    var delegate:ThemePickerDelegate?
    var colors: NSArray = NSArray()
    var headers = ["Nav","Tile","Marked","Back","Ground"]
    var selectedIndexPath: NSIndexPath?
    
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func repaint() {
        styleSegCtl.tintColor =  UIColor(contrastingBlackOrWhiteColorOn:styleSegCtl.backgroundColor , isFlat:true)
        flatGlossyCtl.tintColor =  UIColor(contrastingBlackOrWhiteColorOn:flatGlossyCtl.backgroundColor , isFlat:true)
        self.tableView.reloadData()
        
    }
    @IBAction func stylesegPushed(sender: AnyObject) {
        ()
    }
    
    @IBAction func flatGlossyPushed(sender: AnyObject) {
        repaint()
    }
    
    @IBOutlet weak var useItButton: UIBarButtonItem!
    
    @IBAction func useItPushed(sender: AnyObject) {
        useScheme()
        self.dismissViewControllerAnimated(true,completion:nil)
    }
    func useScheme() {
        if  let indexPath = self.selectedIndexPath {
            let fg = flatGlossyCtl.selectedSegmentIndex
            let sg = styleSegCtl.selectedSegmentIndex
            let idx = indexPath.row
            let basecolor = Colors.allColors[idx]
            let name = Colors.allColorNames[idx]
            print("Did select \(name) \(basecolor)")
            
            var newColors : NSArray
            
            switch  sg {
            case  0:      newColors  = ColorSchemeOf(ColorScheme.Analogous, color: basecolor, isFlatScheme: fg == 0 )
            case 1:      newColors  = ColorSchemeOf(ColorScheme.Triadic, color: basecolor, isFlatScheme: fg == 0 )
            default:      newColors  = ColorSchemeOf(ColorScheme.Complementary, color: basecolor, isFlatScheme: fg == 0 )
          
            
          Globals.shared.mainColors = newColors
            // announce what we have done
            NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceUpdatedSignal,object:nil)
            }
            
            
        }
    }
    @IBOutlet weak var flatGlossyCtl: UISegmentedControl!
    @IBOutlet weak var styleSegCtl: UISegmentedControl!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    deinit {
        self.cleanupFontSizeAware(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStatusBarStyle(UIStatusBarStyleContrast)//
        
        self.navigationController?.navigationItem.rightBarButtonItem?.enabled = false
        // shudnt register when prototype cell is from storyboard
        //        self.tableView.registerClass(ThemePickerCell.self, forCellReuseIdentifier: "ThemePickerCellID")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupFontSizeAware(self)
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
        
        let fg = flatGlossyCtl.selectedSegmentIndex
        let idx = indexPath.row
        let basecolor = Colors.allColors[idx]
        cell.contentView.backgroundColor = basecolor
        // now generate the whole family of five colors
        
        switch  styleSegCtl.selectedSegmentIndex {
        case  0:      colors  = ColorSchemeOf(ColorScheme.Analogous, color: basecolor, isFlatScheme: fg == 0 )
        case 1:      colors  = ColorSchemeOf(ColorScheme.Triadic, color: basecolor, isFlatScheme: fg == 0 )
        default:      colors  = ColorSchemeOf(ColorScheme.Complementary, color: basecolor, isFlatScheme: fg == 0 )
        }
        
        
        //add to contentView
        let h = cell.contentView.frame.height
        let w = cell.contentView.frame.width / CGFloat(colors.count)
        var pos:CGFloat = 0.0
        var inc  = 0
        for c in colors {
            let v = UIView(frame:CGRect(x: pos, y: 0, width:w,height: h))
            v.backgroundColor = c as? UIColor
            v.tag = 1 + inc
            cell.contentView.addSubview(v)
            let lab = UILabel(frame:CGRect(x:pos,y:0,width: w,height:h))
            lab.backgroundColor = Colors.clear
            
            // set the text to something contrasty
            lab.textColor =  UIColor(contrastingBlackOrWhiteColorOn:v.backgroundColor , isFlat:fg==0)
            lab.text = Colors.allColorNames[idx]
            lab.textAlignment = .Center
            lab.minimumScaleFactor = 0.3
            lab.adjustsFontSizeToFitWidth = true
            lab.numberOfLines = 0
            lab.tag = 1
            cell.contentView.addSubview(lab)
            pos += w
            inc += 1
        }
        return cell
    }
}


extension ThemePickerViewController : UITableViewDelegate {//
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let h : CGFloat = 44.0
        let v = UIView(frame:CGRect(x:0,y:0,width:tableView.frame.width,height:h))
        v.backgroundColor = Colors.gray
        let w = tableView.frame.width / CGFloat(colors.count)
        var pos : CGFloat  = 0.0
        for j in 0..<colors.count {
            let lab = UILabel(frame:CGRect(x:pos,y:0,width:w,height:h))
            lab.text = headers[j]
            lab.textAlignment = .Center
            lab.textColor = Colors.black
            v.addSubview(lab)
            pos += w
        }
        return v
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //ok, selected
        self.selectedIndexPath = indexPath
        let idx = indexPath.row
        let basecolor = Colors.allColors[idx]
        let name = Colors.allColorNames[idx]
        self.view.backgroundColor = basecolor
        self.tableView.backgroundColor = basecolor
        self.title = name
        self.navigationController?.title = name
        self.useItButton.enabled = true
        
    }
}
extension ThemePickerViewController : FontSizeAware {
    func refreshFontSizeAware(vc:ThemePickerViewController) {
        vc.tableView.reloadData()
    }
}