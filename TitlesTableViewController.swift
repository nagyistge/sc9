//
//  TitlesTableViewController.swift
//  stories
//
//  Created by bill donner on 8/22/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit



extension TitlesTableViewControllerInternal: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AdjustableFonts.rowHeightForTextStyle (UIFontTextStyleHeadline) * 1.5
    }
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
      		let idx = matcoll[indexPath.section][indexPath.row]
        backData = incoming[idx].title
       	self.storeStringArgForSeque(backData) // Corpus.lookup(backData))
        self.presentContent(self)
    }
}
extension TitlesTableViewControllerInternal: UITableViewDataSource {
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        //assert(section < sectionTitles.count,"bad section in titlefor header")
        if matcoll[section].count > 0 {
            return CollationSupport.shared.collation.sectionIndexTitles[section] as String
        }
        return ""
    }
    //		override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    //			return 50 // without this we are lost
    //		}
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matcoll[section].count //TitlesConcordance.shared.gDict.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(ruid, forIndexPath:indexPath) as UITableViewCell
        let idx = matcoll[indexPath.section][indexPath.row]
        let tune = incoming[idx].title
        cell.textLabel?.text = tune
        cell.textLabel?.font = AdjustableFonts.fontForTextStyle (UIFontTextStyleHeadline)
        cell.textLabel?.textColor = UIColor.blackColor()
        //        if SearchEngine.haveTitle(tune) {
        //            cell.accessoryType = .DisclosureIndicator
        //        }
        //let ids = SearchEngine.idsForTitle(tune)
        //	let s = ",".join(map(ids){String($0)})
        //cell.detailTextLabel.text = s
        //
        //	println("got { \(s) } \(TitlesConcordance.shared)")
        return cell
    }
}

// MARK: - View Controller with side index
//  MARK: - Titles with Side Index

 class TitlesTableViewControllerInternal: UIViewController,ModelData,SegueHelpers {
    var tableView: UITableView!
    var backData = ""
    let ruid = "ChooseDocTableViewControllerCellID"
    var matcoll: Sideinfo = []
    var incoming: [SortEntry] = []
    
    func ticked() {
        self.navigationItem.prompt = nil
    }
    func setPrompt(s:String) {
        self.navigationItem.prompt = s
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "ticked", userInfo: nil, repeats: false)
    }
//    func itunesImport() {
//        presentStoryboardControllerFrom(self,
//            story:Story(name: "itunesimportpanel", storyboardName: "Main", storyboardID: "iTunesImportID"))
//    }
    
    override func viewDidLoad() {
        
        func ticked() {
            self.navigationItem.prompt = nil
        }
        func setPrompt(s:String) {
            self.navigationItem.prompt = s
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "ticked", userInfo: nil, repeats: false)
        }
        
        super.viewDidLoad()
        incoming = Corpus.uniques(Corpus.sorted())
        matcoll = CollationSupport.matrixOfIndexes(&incoming) //
            self.tableView = UITableView(frame:self.view.frame)
            self.view.addSubview(self.tableView)
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ruid)
            
            self.tableView.estimatedRowHeight = 100// new
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.navigationItem.title = "Titles (\(incoming.count))"
          
        //}
    }// view did load
}

