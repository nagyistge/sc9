//
//  ShowContentViewController.swift
//
//  Created by william donner on 9/24/15.
//

import UIKit
import QuickLook

@objc protocol QLPreviewProt:QLPreviewControllerDataSource,QLPreviewControllerDelegate {
	var urlList :[String]? { get set }
	var qlp : QLP? { get set }
	var didPushQLP: Bool { get set }
	var qltitle: String { get set }
	//func presentPreviewController(title:String,urls:[String])
	// func pushPreviewController(title:String,urls:[String])
	func previewControllerWillDismiss(controller: QLPreviewController)
}

final class QLP: NSObject, QLPreviewItem {

	var previewItemURL: NSURL
	var previewItemTitle: String?

	init(url:NSURL,title:String?) {
		previewItemTitle = title
		previewItemURL = url
	}

}
protocol DetailViewOnly {
	// just used as a marker
}
final class MyQLPreviewController: QLPreviewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
protocol ShowContentDelegate {
	func userDidDismiss()
}

final class ShowContentViewController:  QLPreviewController ,QLPreviewProt,DetailViewOnly {
		// required properties from QLPreviewProt
	var uniqueIdentifier: String?// set by caller, looks like a title now

	var urlList :[String]? // set by caller
	var qlp: QLP?
	var didPushQLP: Bool = false
	var qltitle: String = ""

	override func prefersStatusBarHidden() -> Bool {
		return false
	}
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

	var showdelegate: ShowContentDelegate?
	var name: String?
	deinit {
		self.cleanupFontSizeAware(self)
	}

	@IBAction func allDone(sender: AnyObject) {
		showdelegate?.userDidDismiss()
		self.unwindFromHere(self)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupFontSizeAware(self)
		self.navigationItem.title = self.uniqueIdentifier
		self.delegate = self
		self.dataSource = self
		self.currentPreviewItemIndex = 0
		self.qltitle = self.uniqueIdentifier!
	}
}

extension ShowContentViewController: FontSizeAware {
	func refreshFontSizeAware(vc: UIViewController) {
		self.view.setNeedsDisplay()
	}
}
extension ShowContentViewController:SequeHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		self.prepForSegue(segue , sender: sender)
	}
}

extension ShowContentViewController : QLPreviewControllerDelegate {

	func previewControllerWillDismiss(controller: QLPreviewController) {

		//        func saveInBack() {
		//            doThis({
		//                Recents.shared.save()
		//                },thenThat:{ })
		//        }
		//        if qltitle != "" {
		//        let hintID = ";hint123456"
		//        print("*** MUST FIX recents hint \(hintID) for \(qltitle)")
		//        let t = CRecent(title:qltitle, hint:hintID)
		//        Recents.shared.add(t)
		//
		//        saveInBack()
		//        }

	}
}

extension ShowContentViewController : QLPreviewControllerDataSource {
	func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
		return urlList!.count //5
	}
	// MARK: - Quick Look Preview Controller Delegates
	func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
		let fileURL : NSURL
		if urlList?.count > 1 {
			let filePath = urlList?[index]
			fileURL = NSURL(fileURLWithPath: filePath!)
		}
		else if urlList?.count == 1 {
			let filePath = urlList?[index]
			fileURL = NSURL(fileURLWithPath: filePath!)
		}
		else {
			// really screwed up , put something up
			fileURL = NSBundle.mainBundle().URLForResource( "FileIsMissing", withExtension:"png")!
			qltitle = ""  //clear this out
		}
		//        let title =   fileURL.absoluteString as NSString
		//        let s = title.stringByDeletingPathExtension as NSString
		//        let ss = s.lastPathComponent

		return QLP(url:fileURL,title:self.uniqueIdentifier!) // 6
	}
}
//extension ShowContentViewController {

//	func presentPreviewController(title:String,urls:[String]) {
//		// ugh shovel into instance variable to wait for delegate to utilize
//		urlList = urls
//		qltitle = title
//		didPushQLP = false
//		let qv =    self // QLPreviewController()// dont need to create this
//		qv.dataSource = self
//		qv.delegate = self
//		qv.currentPreviewItemIndex = 0
//		//background is always white

//
//		qv.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//		qv.navigationItem.leftItemsSupplementBackButton = true
		//
		//        // assign this to our splitview
		////
		////        if Globals.shared.splitViewController != nil {
		////
		////            print("QLPreviewReadyViewController splitViewController before ", Globals.shared.splitViewController!.viewControllers)
		////            let count =  Globals.shared.splitViewController!.viewControllers.count
		////            if count == 1 {
		//                 presentViewController(qv, animated: true , completion: nil)
		//                // Globals.shared.splitViewController!.viewControllers.append(qv)
		//            } else if count == 2 {
		//                let nav = UINavigationController(rootViewController: qv)
		//            Globals.shared.splitViewController!.viewControllers[1] = nav
		//            }
		//            else
		//            {
		//                fatalError("no viewcontrollersin splitview!")
		//            }
		//
		//        } else {



		//presentViewController(qv, animated: false , completion: nil)
//	}
	//    func pushPreviewController(title:String,urls:[String]) {
	//        // ugh shovel into instance variable to wait for delegate to utilize
	//        urlList = urls
	//        qltitle = title
	//        didPushQLP = true
	//        let qv = QLPreviewController()
	//        qv.dataSource = self
	//        qv.delegate = self
	//        qv.currentPreviewItemIndex = 0
	//        self.navigationController?.pushViewController(qv, animated: true )
	//    }

//}


//final class ContinueUserActivityViewController:ShowContentViewController {
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		guard uniqueIdentifier != nil
//			else
//		{
//			fatalError("must invoke ContinueUserActivityViewController with uniqueIdentifier")
//		}
//		// get all the files that match
//		//        let list = Corpus.lookup(uniqueIdentifier!)
//		//        // assemble into a qlpreviewcontroller
//		//        presentPreviewController("fix",urls:list)
//	}
//}