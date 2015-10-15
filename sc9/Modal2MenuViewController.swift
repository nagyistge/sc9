//
//  ModalMenuViewController.swift
//
//  Created by william donner on 9/25/15.
//

import UIKit

// presents a bunch of choices as a transparent modal overlay controller
protocol ModalMenu2Delegate {
	func shootPhoto()
	func addPhotos()
	func importPhotos()
}

final class ModalMenu2ViewController: UIViewController, TodayReady {
	var delegate:ModalMenu2Delegate?
	deinit {
		self.cleanupFontSizeAware(self)
	}
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
		print("Unwound to ModalMenu2ViewController")
	}
	@IBAction func choseShoot(sender: AnyObject) {
		presentShootPhoto(self)
	}

	@IBAction func choseAddPhotos(sender: AnyObject) {
		presentAddPhotos(self)
	}

	@IBAction func choseImportItunes(sender: AnyObject) {
		presentImportItunes(self)
	}

	@IBAction func chooseDownloadFiles(sender: AnyObject) {
		presentDownloader(self)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupFontSizeAware(self)
  
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(
        animated
        )
        if Model.data.tiles.count == 0 {
            self.blurt(self,title: "You Have No Content", mess: "Please Add Some")
        }
    }
}

extension ModalMenu2ViewController : SegueHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
		let id = segue.identifier
		if id == "ModalShootPhotoFromMenu" {
			print("Prepping to Shoot")
		}

	}
}
extension ModalMenu2ViewController : FontSizeAware {
	func refreshFontSizeAware(vc:ModalMenu2ViewController) {
		vc.view.setNeedsDisplay()
	}
}

