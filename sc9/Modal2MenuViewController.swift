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

final class ModalMenu2ViewController: UIViewController, StashPhotoOps , TodayReady {
    var delegate:ModalMenu2Delegate?
    deinit {
        self.cleanupFontSizeAware(self)
    }
    
    @IBAction func xButtonWasPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToTilesViewControllerID", sender: self)
 
    }
    
    @IBAction func unwindToModalMenu2(segue: UIStoryboardSegue) {
       // print("Unwound to ModalMenu2ViewController")
    }
    func stashPhoto(image:UIImage) {
        // someone wants to stash a photo via delegate protocol
        let bits =  UIImagePNGRepresentation(image)
        let title = NSDate().description
        let (notdupe,normalTitle,hint) =
        Corpus.addDocumentWithBits(bits!,title:title as String,type:"png")
        if notdupe {
            print("Notdupe \(normalTitle) hint \(hint)")
        }
        else {
            print("Dupe \(normalTitle) hint \(hint)")
        }
        
        Corpus.shared.save()
        Addeds.shared.save()
        
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