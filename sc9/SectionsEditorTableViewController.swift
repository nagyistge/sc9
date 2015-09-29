//
//  SectionsEditorViewController
//  Created by william donner on 9/23/15.
//

import UIKit
protocol SectionsEditorDelegate {
	func makeNewSection(i:Int)
	func deleteSection(i:Int)
	func moveSections(from:Int,to:Int)
}

final class SectionsEditorViewController:UITableViewController,ModelData {
	// these must be set by the caller as properties
	var delegate:SectionsEditorDelegate?
	//	var sectionOrdering:[Int]! // passed in and then back

	private var savedrightBBI:UIBarButtonItem!
	private var savedleftBBI:UIBarButtonItem!

	deinit {
		self.cleanupFontSizeAware(self)
	}
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
	}

	// @IBAction func startEditing(sender: UIBarButtonItem) {self.editing = !self.editing}

	override func setEditing(editing: Bool, animated: Bool) {
		// Toggles the edit button state
		super.setEditing(editing, animated: animated)
		// Toggles the actual editing actions appearing on a table view
		tableView.setEditing(editing, animated: true)
		// repaint top
		makeTop()
	}
	private func deleteSectionAt(indexPath:NSIndexPath ) {
		// Delete the row from the data source


		delegate?.deleteSection(indexPath.row)
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

		makeTop()
	}
	private func insertSectionAt(indexPath:NSIndexPath) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view


		delegate?.makeNewSection(indexPath.row)
		tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		makeTop()
	}
	func insertSectionAtEnd (){
		let shcount = self.sectCount()
		let nsipath = NSIndexPath(forRow: shcount, inSection: 0)
		insertSectionAt(nsipath)
	}
	func deleteSectionAtTop (){
		deleteSectionAt(NSIndexPath(forRow: 0, inSection: 0))
	}
	private func makeTop() {
		self.navigationItem.title = self.editing ? "Editing Sections" : "Sections"
		self.navigationItem.rightBarButtonItem = self.editButtonItem()
		if self.editing {
			self.navigationItem.rightBarButtonItem =
				UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Add,target: self, action: "insertSectionAtEnd")
			self.navigationItem.leftBarButtonItem = self.editButtonItem()
		} else {
			// not editing, put the original stuff back in place
			self.navigationItem.leftBarButtonItem = savedleftBBI
			self.navigationItem.rightBarButtonItem = savedrightBBI
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
	self.setupFontSizeAware(self)
		self.navigationItem.rightBarButtonItem = self.editButtonItem()
		savedrightBBI = self.navigationItem.rightBarButtonItem
		savedleftBBI = self.navigationItem.leftBarButtonItem
		makeTop()
	}
}


extension SectionsEditorViewController:SequeHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}

extension SectionsEditorViewController { //:UITableViewDelegate {

	//TODO: - adjust the character arrays

	override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

		delegate?.moveSections(fromIndexPath.row,to:toIndexPath.row)

	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			deleteSectionAt(indexPath)
		} else if editingStyle == .Insert {
			insertSectionAt(indexPath)
		}
		makeTop()
	}


	override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}

	override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {

		return .Delete
	}
}

extension SectionsEditorViewController {//: UITableViewDataSource {
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// Return the number of sections.
		return 1
	}
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Return the number of rows in the section.
		return self.sectCount()
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("SectionHeadersTableCellID", forIndexPath: indexPath)

		// Configure the cell...
		cell.textLabel?.text = self.sectHeader(indexPath.row)
		return cell
	}
}

extension SectionsEditorViewController : FontSizeAware {
	func refreshFontSizeAware(vc:SectionsEditorViewController) {
		vc.tableView.reloadData()
	}
}
