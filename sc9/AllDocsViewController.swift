//
//  AllDocsViewController.swift
//  stories
//
//  Created by bill donner on 7/10/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
class AllTitlesCell:UITableViewCell {
    
}
extension AllDocsViewController: UITableViewDelegate {
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return AdjustableFonts.rowHeightForTextStyle (UIFontTextStyleHeadline) * 1.5
//    }
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return CollationSupport.shared.collation.sectionForSectionIndexTitleAtIndex(index)
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return CollationSupport.shared.collation.sectionIndexTitles
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CollationSupport.shared.collation.sectionIndexTitles.count
    }
    
    // todo - check on other side
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let idx = Globals.shared.matcoll![indexPath.section][indexPath.row]
        backData = Globals.shared.incoming![idx].title
        showDoc(self,named:backData)
    }
}
extension AllDocsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        //assert(section < sectionTitles.count,"bad section in titlefor header")
        if Globals.shared.matcoll![section].count > 0 {
            return CollationSupport.shared.collation.sectionIndexTitles[section] as String
        }
        return ""
    }
    //		override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    //			return 50 // without this we are lost
    //		}
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   Globals.shared.matcoll![section].count //TitlesConcordance.shared.gDict.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(ruid, forIndexPath:indexPath) as! AllTitlesCell
        let idx =   Globals.shared.matcoll![indexPath.section][indexPath.row]
        let tune = Globals.shared.incoming![idx].title
        cell.configureCell(tune)
        
        return cell
    }
}

// MARK: - View Controller with side index
//  MARK: - Titles with Side Index

final class AllDocsViewController: UIViewController,ModelData,SegueHelpers,FontSizeAware {
    var backData = ""
    let ruid = "ChooseDocCellID"
    // moved into globals as a cache
    //var matcoll: Sideinfo = []
    //var incoming: [SortEntry] = []
    
    func ticked() {
        self.navigationItem.prompt = nil
    }
    func setPrompt(s:String) {
        self.navigationItem.prompt = s
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "ticked", userInfo: nil, repeats: false)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var auxView: UIView!
    deinit {
        self.cleanupFontSizeAware(self)
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Globals.cacheLoad()
        self.tableView.registerClass(AllTitlesCell.self, forCellReuseIdentifier: ruid)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupFontSizeAware(self)
        
        //}
    }// view did load
}