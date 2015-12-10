//
//  Addeds.swift
//
//  Created by william donner on 9/25/15..
//

import UIKit


protocol AddedsViewDelegate {
	func addedsReturningResults(data:String)
}
extension AddedsViewDelegate {
	func addedsReturningResults(data:String) {
		print("Default addedsReturnResults should not be called")
	}
}
class AddedsCell:UITableViewCell {
    func configureCell(s:String) {
        self.textLabel!.text  = s
        self.textLabel!.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        self.textLabel!.textColor = Colors.white
        self.backgroundColor = Colors.clear
        self.contentView.backgroundColor = Colors.clear
    }
}

final class AddedsViewController: UIViewController, ModelData { // modal
	var delegate:AddedsViewDelegate?

	deinit {
		self.cleanupFontSizeAware(self)
	}

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.registerClass(AddedsCell.self, forCellReuseIdentifier: "AddedsTableCellID")
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.setupFontSizeAware(self)
	}
}
extension AddedsViewController : FontSizeAware {
	func refreshFontSizeAware(vc:AddedsViewController) {
		vc.tableView.reloadData()
	}
}
extension AddedsViewController :SegueHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}
extension AddedsViewController : UITableViewDelegate {//
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.storeStringArgForSeque(self.addedsData( indexPath.item).title)
		self.presentContent(self)
	}
}
extension AddedsViewController:UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.addedsCount()
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("AddedsTableCellID", forIndexPath: indexPath) as! AddedsCell
		cell.configureCell(self.addedsData(indexPath.item).title)
		return cell
	}
}