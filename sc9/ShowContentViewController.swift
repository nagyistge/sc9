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
protocol ShowContentDelegate {
    func userDidDismiss()
}

class ShowContentViewController:  QLPreviewController ,QLPreviewProt,DetailViewOnly {
    // either set uniqueIdentifier
    var uniqueIdentifier: String?// set by caller, looks like a title now
    // or pre-load a url list
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
    var fileURL : NSURL!

    var showdelegate: ShowContentDelegate?
    var name: String?
    deinit {
        self.cleanupFontSizeAware(self)
    }
    
    @IBAction func allDone(sender: AnyObject) {
        showdelegate?.userDidDismiss()
        self.unwindToMainMenu(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupFontSizeAware(self)
        if self.uniqueIdentifier != nil {
            self.urlList = Corpus.lookup(self.uniqueIdentifier!)
            self.navigationItem.title = self.uniqueIdentifier
            self.qltitle = self.uniqueIdentifier!
        } else {
            if self.urlList != nil {
                let name = "#" + (self.urlList![0] as NSString).lastPathComponent
                self.navigationItem.title = name
                self.qltitle = name
            } else {
                fatalError("ShowContent needs uniqueID or urlList")
            }
 }
        // if we can find a hint, then set the preview item to that
        var idx = 0
        let hint = Recents.shared.hintFromRecents(self.qltitle )  // O(n)
        
        for url in urlList! {
            let lp = url as NSString
            let qp = lp.lastPathComponent
            if qp == hint {
                break
            }
          idx++
        }
        
        self.currentPreviewItemIndex = idx < urlList!.count ? idx : 0
        
        self.delegate = self
        self.dataSource = self
        let item = self.navigationController?.navigationItem.leftBarButtonItem
        if item != nil {
        self.navigationController?.navigationItem.leftBarButtonItems = [item!,UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "allDone:")]
        } else {
                  self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "allDone:")
        }
    }
}

extension ShowContentViewController: FontSizeAware {
    func refreshFontSizeAware(vc: UIViewController) {
        self.view.setNeedsDisplay()
    }
}
extension ShowContentViewController:SegueHelpers {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.prepForSegue(segue , sender: sender)
    }
}

extension ShowContentViewController : QLPreviewControllerDelegate {
    
    func previewControllerWillDismiss(controller: QLPreviewController) {
        
                func saveInBack() {
                    doThis({ Recents.shared.save()},thenThat:{
                    // tell the delegate we finished saving
                     self.showdelegate?.userDidDismiss()
                    })
                }
                if qltitle != "" {
                    let hintID = fileURL.lastPathComponent
                
                    let t = RecentListEntry(list:Recents.Configuration.label,title:qltitle, hint:hintID ?? "nohint")
                Recents.shared.add(t)
        
                saveInBack()
                }
        
    }
}

extension ShowContentViewController : QLPreviewControllerDataSource {
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return urlList!.count //5
    }
    // MARK: - Quick Look Preview Controller Delegates
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
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

final class ContinueUserActivityViewController:ShowContentViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard uniqueIdentifier != nil
            else
        {
            fatalError("must invoke ContinueUserActivityViewController with uniqueIdentifier")
        }
        // get all the files that match
        showDoc(self,named:uniqueIdentifier!)
    }
}