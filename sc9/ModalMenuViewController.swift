//
//  ModalMenuViewController.swift
//
//  Created by william donner on 9/25/15.
//

import UIKit

// presents a bunch of choices as a transparent modal overlay controller
protocol ModalMenuDelegate {

}

final class ModalMenuViewController: UIViewController {
	var delegate:ModalMenu2Delegate?

	deinit {
		self.cleanupFontSizeAware(self)
	}
	@IBAction func choseSearch(sender: AnyObject) {
		self.presentSearch(self)
	}
	@IBAction func choseAddeds(sender: AnyObject) {
		self.presentAddeds(self)
	}
	@IBAction func choseRecents(sender: AnyObject) {
		self.presentRecents(self)
	}
	@IBAction func choseMegaList(sender: AnyObject) {
		self.presentMegaList(self)
	}
	@IBAction func choseMore(sender: AnyObject) {
		self.presentMore(self)
	}
	@IBAction func choseEdit(sender: AnyObject) {
		self.presentTilesEditor(self)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupFontSizeAware(self)
	}
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
		print("Unwound to ModalMenuViewController")
	}
}

extension ModalMenuViewController :SequeHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}
extension ModalMenuViewController : FontSizeAware {
	func refreshFontSizeAware(vc:ModalMenuViewController) {
			vc.view.setNeedsDisplay()
	}
}