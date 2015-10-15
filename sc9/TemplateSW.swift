//
//  TemplateSW.swift
//
//  Created by william donner on 9/27/15.
//

import UIKit

//use this to callback into parent view controllers
protocol TemplateSWDelegate{

}
extension TemplateSWDelegate{

}



//even if there is no customization, always wrap and refer to cells distinctly in Interface builder
final class TemplateSWCell: UITableViewCell{

}

// framework for view controller with or without TableView
final class TemplateSWViewController: UIViewController,ModelData {
	// if supplied, status and async return results can be posted
	var delegate:TemplateSWDelegate?


	let CELLID = "TemplateSWTableCellID"
	let NEXTSCENESEQUEID = "ShowContentSegueID"


	// if this is a tableview, include this line
	@IBOutlet weak var tableView: UITableView!


	// always call cleanup, it removes observers
	deinit {
		self.cleanupFontSizeAware(self)
	}

	// calling another viewcontroller is almost often done manuall
	// via performSegueWithIdentifier 

	// there is almost always a need to catch the segue in progress to pass along arguments





	override func viewDidLoad() {
		super.viewDidLoad()
		// respond to content size changes
		self.setupFontSizeAware(self)
		// for tables do the normal setup
		self.tableView.registerClass(TemplateSWCell.self, forCellReuseIdentifier: CELLID)

		self.tableView.dataSource = self
		self.tableView.delegate = self


		
	}
	// if you want to let storyboard flows come back here then include this line:
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {}

}
extension TemplateSWViewController :SegueHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}
extension TemplateSWViewController : FontSizeAware {
	func refreshFontSizeAware(vc:TemplateSWViewController) {
		vc.view.setNeedsDisplay()
	}
}

extension TemplateSWViewController:UITableViewDataSource {


	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// Return the number of sections.
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Return the number of rows in the section.
		return self.recentsCount()
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(CELLID, forIndexPath: indexPath) as! TemplateSWCell

		// Configure the cell...
		cell.configureCell(self.recentsData(indexPath.row))
		return cell
	}
}
extension TemplateSWViewController : UITableViewDelegate {//


	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.storeStringArgForSeque(    self.recentsData(indexPath.item).title )

		// the arguments for the next scene need to be stashed and the transition started

		self.presentAny(self,identifier:NEXTSCENESEQUEID)

	}
}