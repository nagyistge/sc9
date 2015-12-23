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
    
    @IBOutlet weak var editTilesButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var addContentButton: UIButton!
    @IBAction func choseSettings(sender: AnyObject) {
        self.presentSettings(self)
    }
	@IBAction func choseAllTitles(sender: AnyObject) {
		self.presentAllTitles(self)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let enabled =  !Globals.shared.openedByActivity
        // if opened specially dont allow any editing
        editTilesButton.enabled = enabled
         editTilesButton.setTitleColor(enabled ? Colors.white:Colors.gray, forState: .Normal)
        
        settingsButton.enabled = enabled
         settingsButton.setTitleColor(enabled ? Colors.white:Colors.gray, forState: .Normal)
        
        addContentButton.enabled = enabled
         addContentButton.setTitleColor(enabled ? Colors.white:Colors.gray, forState: .Normal)
    }
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupFontSizeAware(self)
	}
	@IBAction func unwindToModalMenu(segue: UIStoryboardSegue) {
		//print("Unwound to ModalMenuViewController")
	}
}

extension ModalMenuViewController :SegueHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}
extension ModalMenuViewController : FontSizeAware {
	func refreshFontSizeAware(vc:ModalMenuViewController) {
			vc.view.setNeedsDisplay()
	}
}