//
//  Recents.swift
//
//  Created by william donner on 9/25/15.
//

import UIKit


protocol RecentsViewDelegate {
	func recentsReturningResults(data:String)
}

extension RecentsViewDelegate {
	func recentsReturningResults(data:String) {
		print("Default recentsReturningResults should not be called")
	}
}
class RecentsCell:UITableViewCell {

}
final class RecentsViewController: UIViewController,ModelData { // modal
	var delegate:RecentsViewDelegate?
	@IBOutlet weak var tableView: UITableView!
	deinit {
		self.cleanupFontSizeAware(self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.registerClass(RecentsCell.self, forCellReuseIdentifier: "RecentsTableCellID")
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.setupFontSizeAware(self)
		
	}
}
extension RecentsViewController : FontSizeAware {
	func refreshFontSizeAware(vc:RecentsViewController) {
		vc.tableView.reloadData()
	}
}
extension RecentsViewController : SequeHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}
extension RecentsViewController : UITableViewDelegate {//
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.storeStringArgForSeque( self.recentsData( indexPath.item )[ElementProperties.NameKey]!)
		self.presentContent(self)
	}
}
extension RecentsViewController:UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.recentsCount()
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("RecentsTableCellID", forIndexPath: indexPath) as! RecentsCell
		cell.configureCell(self.recentsData(indexPath.item))
		return cell
	}
}

