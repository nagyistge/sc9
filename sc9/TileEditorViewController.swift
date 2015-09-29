//
//  TileEditor.swift
//
//  Created by william donner on 9/23/15.
//

import UIKit
protocol TileEditorDelegate {
	func deleteThisTile(path:NSIndexPath)
}

class TileEditorViewController: UIViewController {
	var delegate:TileEditorDelegate?
	// These must be set by caller
	var tileIdx: NSIndexPath!
	var tileName: String!


	// unwind to here from subordinate editors, passing back values via custom protocols for each

	deinit {
		self.cleanupFontSizeAware(self)
	}
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
		print("Unwound to TileEditorViewController")
	}

	// MARK: - deleting the tile requires confirmation takes us back

	@IBAction func trashThisTile(sender: AnyObject) {

		//Create the AlertController
		let actionSheetController: UIAlertController = UIAlertController(title: "Delete this tile \(tileName) ?", message: "Can not be undone", preferredStyle: .Alert)
		//
		//	//Create and add the Cancel action
		let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
			//		  Just dismiss the action sheet
		}
		actionSheetController.addAction(cancelAction)

		//Create and add first option action
		actionSheetController.addAction(UIAlertAction(title: "Delete This Tile", style: .Destructive) { action -> Void in
			self.delegate?.deleteThisTile(self.tileIdx!)
			self.unwindFromHere(self)
			})
		//  We need to provide a popover sourceView when using it on iPad
		actionSheetController.popoverPresentationController?.sourceView = sender as? UIView;

		//  Present the AlertController
		self.presentViewController(actionSheetController, animated: true, completion: nil)
	}
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		// if the fontsize changes refresh everthing
		self.setupFontSizeAware(self)
		self.navigationItem.title = self.tileName
	}

}

extension TileEditorViewController: SequeHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let uiv = segue.destinationViewController as? SubEditorViewController {
			uiv.delegate = self
		}
	}
}

extension TileEditorViewController: SubEditorDelegate {
	func returningResults(data:String){
		print("SubEditor returned ",data)
	}
}
extension TileEditorViewController : FontSizeAware {
	func refreshFontSizeAware(vc:TileEditorViewController) {
		vc.view.setNeedsDisplay()
	}
}
