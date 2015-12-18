//
//  ShootPhoto.swift
//
//  ShootPhoto.swift
//
//  Created by william donner on 9/27/15.
//

import UIKit

//use this to callback into parent view controllers
protocol ShootPhotoDelegate{
	func willExit()
}
extension ShootPhotoDelegate{
	func willExit() {
print("PhotoShooterExiting")
	}
}

// framework for view controller with or without TableView
final class ShootPhotoViewController: UIViewController {

	let NEXTSCENESEQUEID = "ShowContentSegueID"

	// if supplied, status and async return results can be posted
	var delegate:ShootPhotoDelegate?


	// always call cleanup, it removes observers
	deinit {
		self.cleanupFontSizeAware(self)
	}

	// calling another viewcontroller is almost often done manuall
	// via performSegueWithIdentifier

	override func viewDidLoad() {
		super.viewDidLoad()
		// respond to content size changes
		self.setupFontSizeAware(self)

	}
	// if you want to let storyboard flows come back here then include this line:
	@IBAction func unwindToShootPhoto(segue: UIStoryboardSegue) {}//unwindToVC(segue: UIStoryboardSegue) {}

}
extension ShootPhotoViewController:SegueHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}

extension ShootPhotoViewController : FontSizeAware {
	func refreshFontSizeAware(vc:ShootPhotoViewController) {
		vc.view.setNeedsDisplay()
	}
}