//
//  SearchingViewController.swift
//
//  Created by william donner on 9/24/15.
//

import UIKit

protocol SearchingViewDelegate {
	func searchingReturningResults(data:String)
}
extension SearchingViewDelegate {
	func searchingReturningResults(data:String) {
		print("Default searchingReturningResults should not be called")
	}
}
class SearchingCell:UITableViewCell {

}

final class SearchingViewController: UIViewController, ModelData { // modal
	var delegate:SearchingViewDelegate?
	// prepare for segue

	@IBOutlet weak var searchField: UITextField!

	@IBOutlet weak var tableView: UITableView!

	deinit {
		self.cleanupFontSizeAware(self)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.searchField.delegate = self
		self.searchField.becomeFirstResponder()

		self.tableView.registerClass(SearchingCell.self, forCellReuseIdentifier: "SearchingTableCellID")

		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.setupFontSizeAware(self)

	}

	//@IBAction func unwindToVC(segue: UIStoryboardSegue) {
	//}
}

extension SearchingViewController:SegueHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}

extension SearchingViewController : UITableViewDelegate {//
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showDoc(self,named: self.recentsData( indexPath.item ).title)
	}
}
extension SearchingViewController:UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// Return the number of sections.
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Return the number of rows in the section.
		return self.recentsCount()
	}
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("SearchingTableCellID", forIndexPath: indexPath) as! SearchingCell

		// Configure the cell...

		// for this simple data model just cycle around

		cell.configureCell(self.recentsData(indexPath.row).title)
		return cell
	}
}
extension SearchingViewController: UITextFieldDelegate {
	@IBAction func fieldEditingEnded(sender: AnyObject) {
		searchField.resignFirstResponder()
	}

	@IBAction func fieldChanged(sender: AnyObject) {
		print("Search is \(searchField.text!)")
	}

	// this doesnt work
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if textField == self.searchField {
			textField.resignFirstResponder()
			return false
		}
		return true
	}

	func textFieldDidEndEditing(textField: UITextField) {
		textField.resignFirstResponder()
	}
	
}

extension SearchingViewController : FontSizeAware {
	func refreshFontSizeAware(vc:SearchingViewController) {
		vc.tableView.reloadData()
	}
}