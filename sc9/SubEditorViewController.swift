//
//  SubEditorViewController.swift
//
//  Created by william donner on 9/24/15.
//
//
//  SubEditorViewController
//
//  Created by william donner on 9/23/15.
//

import UIKit
protocol SubEditorDelegate {
	func returningResults(data:String)
}
class SubEditorViewController: UIViewController {
	var delegate:SubEditorDelegate?


	// unwind to here from subordinate editors, passing back values via custom protocols for each

	deinit {
		self.cleanupFontSizeAware(self)
	}
//	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
//	}

	// MARK: - when the goback button is pressed, send some data and take us home

	@IBAction func gobackPressed(sender: AnyObject) {
			delegate?.returningResults("123456")
				self.unwindToMainMenu(self)

	}
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
	self.setupFontSizeAware(self)
	}
}
extension SubEditorViewController:SegueHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}
extension SubEditorViewController : FontSizeAware {
	func refreshFontSizeAware(vc:SubEditorViewController) {
		vc.view.setNeedsDisplay()
	}
}
