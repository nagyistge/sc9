
//
//  MegaListViewController.swift
//
//  Created by william donner on 9/24/15.
//

import UIKit
class MegaListCell:UITableViewCell {
}

final class MegaListViewController: UIViewController, ModelData{

	let CELLID = "MegaListViewControllerTableCellID"

	@IBOutlet weak var tableView: UITableView!

	deinit {
		self.cleanupFontSizeAware(self)
	}

	@IBAction func modalMenuButtonPressed(sender: AnyObject) {
		self.presentModalMenu(self)
	}



	override func viewDidLoad() {
		super.viewDidLoad()
		// if the fontsize changes refresh everthing
		self.setupFontSizeAware(self)
		// for tables do the normal setup
		self.tableView.registerClass(MegaListCell.self, forCellReuseIdentifier: CELLID)
		self.tableView.dataSource = self
		self.tableView.delegate = self
	}

}
extension MegaListViewController:SegueHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}
extension MegaListViewController : FontSizeAware {
	func refreshFontSizeAware(vc:MegaListViewController) {
		vc.tableView.reloadData()
	}
}
extension MegaListViewController : UITableViewDataSource {//
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// Return the number of sections.
		return tileSectionCount()
	}
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 80
	}
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let vframe  = CGRect(x:0,y:0,width:tableView.frame.width,height:80)
		let v = UIView(frame: vframe)
		v.backgroundColor = Colors.clear
		let lframe = CGRect(x:0,y:1,width:v.frame.width,height:v.frame.height-1)
		let l = UILabel(frame:lframe)
		l.text = self.sectHeader(section)[SectionProperties.NameKey]! as String
        l.textColor = Colors.white
		l.backgroundColor = Colors.clear
		l.textAlignment = .Center
		//l.center = v.center
		v.addSubview(l)
		return v
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Return the number of rows in the section.
		return self.tileCountInSection(section)
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(CELLID, forIndexPath: indexPath) as! MegaListCell
		cell.configureCell(self.tileData(indexPath).tyleTitle)
		return cell
	}
}
extension MegaListViewController: ShowContentDelegate {
	func userDidDismiss() {
		print("user dismissed Content View Controlle")
	}
}
extension MegaListViewController : UITableViewDelegate {
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            showDoc(self,named:self.tileData(indexPath).tyleTitle)
	}
}
