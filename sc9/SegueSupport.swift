//
//  SegueSupport.swift
//
//  Created by william donner on 9/27/15.

import UIKit

protocol TuneCellHelper {
     func configureCell(name:String)
}
extension UITableViewCell:TuneCellHelper {

    func configureCell(name:String) {
        self.textLabel!.text  = name
        self.textLabel!.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        self.textLabel!.textColor =  Corpus.findFast( name ) ? Colors.white : Colors.gray
        self.backgroundColor = Colors.clear//Colors.tileColor()
        self.contentView.backgroundColor = Colors.clear
    }
}


final class TilesSectionHeaderView: UICollectionReusableView {
    @IBOutlet weak var headerLabel: UILabel!
}

protocol SegueHelpers {
    func storeTileArgForSeque(s:TileSequeArgs)
    func fetchTileArgForSegue()  -> TileSequeArgs?
    
    func storeStringArgForSeque(s:String)
    func fetchStringArgForSegue()  -> String?
    
    func storeIndexArgForSeque(s:NSIndexPath)
    func fetchIndexArgForSegue()  -> NSIndexPath?
    
    mutating func sequeTo(vc:UIViewController,to:String,data:String)
    func presentDownloader(vc:UIViewController)
    func presentModalMenu(vc:UIViewController)
    func presentSectionEditor (vc:UIViewController)
    func presentLinear (vc:UIViewController)
    func presentMegaList(vc:UIViewController)
    func presentAddeds(vc:UIViewController)
    func presentRecents(vc:UIViewController)
    func presentAllTitles(vc:UIViewController)
    func presentMore(vc:UIViewController)
    func presentSectionRenamor(vc:UIViewController)
    
    func presentImportItunes(vc:UIViewController)
    func presentEditTile(vc:UIViewController)
    func presentTilesEditor(vc:UIViewController)
    func presentAny(vc:UIViewController,identifier:String)
    
    func unwindFromHere(vc:UIViewController)
    func prepForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    
    func presentShootPhoto<V:UIViewController where V:StashPhotoOps>(vc:V)
    func presentAddPhotos<V:UIViewController where V:StashPhotoOps>(vc:V)
    
}
extension SegueHelpers {
    func storeTileArgForSeque(s:TileSequeArgs) {
        Globals.shared.segueargs["TileParam1"] = s
    }
    func fetchTileArgForSegue()  -> TileSequeArgs? {
        let m =  Globals.shared.segueargs["TileParam1"]
        if (m as? TileSequeArgs != nil) {
            return m! as? TileSequeArgs
        }
        return nil
    }
    
    func storeStringArgForSeque(s:String) {
        Globals.shared.segueargs["StringParam1"] = s
        
    }
    func fetchStringArgForSegue()  -> String? {
        let m =  Globals.shared.segueargs["StringParam1"]
        if (m as? String != nil) {
            return m! as? String
        }
        return nil
    }
    func storeIntArgForSeque(i:Int) {
        Globals.shared.segueargs["IntParam1"] = i
    }
    func fetchIntArgForSegue()  -> Int? {
        let m = Globals.shared.segueargs["IntParam1"]
        if (m as? Int != nil) {
            return m! as? Int
        }
        return nil
    }
    
    func storeIndexArgForSeque(s:NSIndexPath) {
        Globals.shared.segueargs["IndexParam1"] = s
    }
    func fetchIndexArgForSegue()  -> NSIndexPath? {
        let m = Globals.shared.segueargs["IndexParam1"]
        if (m as? NSIndexPath != nil) {
            return m! as? NSIndexPath
        }
        return nil
    }
    func prepForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        //
        
        if segue.identifier != nil { // nil means unwind
            if let nav  = segue.destinationViewController as? UINavigationController
            {
                
                if let uiv = nav.topViewController as? PhotoGrabberViewController {
            uiv .modalPresentationStyle = .FullScreen
                } else
                    if let uiv = nav.topViewController as? CameraRollGrabberViewController {
                   uiv .modalPresentationStyle = .FullScreen
                    } else
                        if let uiv = nav.topViewController as? ShowContentViewController {
                            uiv.name = self.fetchStringArgForSegue()
                            // set variables in our superclass
                            uiv.uniqueIdentifier = uiv.name //looks like a title now
                            
                        } else if let uiv = nav.topViewController {
                            uiv.modalPresentationStyle = .OverCurrentContext
                            uiv.modalTransitionStyle = .CrossDissolve
                }
            } else { // not wrapped as nav
                let con = segue.destinationViewController as UIViewController
                
                if let uiv = con as? PhotoGrabberViewController {
                    uiv .modalPresentationStyle = .FullScreen
                } else
                    if let uiv = con as? CameraRollGrabberViewController{
                            uiv .modalPresentationStyle = .FullScreen
                    } else
                        if let uiv = con as? ShowContentViewController {
                            uiv.name = self.fetchStringArgForSegue()
                            // set variables in our superclass
                            uiv.uniqueIdentifier = uiv.name //
                            
                        } else {// not showcontent
                            con.modalPresentationStyle = .OverCurrentContext
                            con.modalTransitionStyle = .CrossDissolve
                }
            }
        }
    }
    
    
    mutating func sequeTo(vc:UIViewController,to:String,data:String) {
        self.storeStringArgForSeque(    data )
        vc.performSegueWithIdentifier(to, sender: nil)
    }
    func presentAny(vc:UIViewController,identifier:String){
        vc.performSegueWithIdentifier(identifier, sender: nil)
    }
    
    func presentEditTile(vc:UIViewController){
        vc.performSegueWithIdentifier("TileEditSegueInID", sender: nil)
    }
    func presentDownloader(vc:UIViewController) {
        vc.performSegueWithIdentifier("ModalDownloadFileSequeID", sender: nil)
    }
    
    
    
    func presentShootPhoto<V:UIViewController where V:StashPhotoOps>(vc:V){

        let uiv = PhotoGrabberViewController()
        uiv.stashDelegate = vc
        vc.presentViewController(uiv , animated: true, completion: nil)
        //3vc.performSegueWithIdentifier("ModalShootPhoto", sender: nil)
        
    }
    func presentThemePickerSegueFromSettings(vc:UIViewController){
        vc.performSegueWithIdentifier("ThemePickerSegueFromSettings", sender: nil)
    }
    func presentThemePicker(vc:UIViewController){
        vc.performSegueWithIdentifier("ThemePickerSegueID", sender: nil)
    }
    func presentAddPhotos<V:UIViewController where V:StashPhotoOps>(vc:V){
        let uiv = CameraRollGrabberViewController()
        uiv.stashDelegate = vc
        vc.presentViewController(uiv, animated: true, completion: nil)
        //vc.performSegueWithIdentifier("ModalAddPhotos", sender: nil)
    }
    func presentImportItunes(vc:UIViewController){
        vc.performSegueWithIdentifier("ModalImportItunes", sender: nil)
    }
    func presentModalMenu(vc:UIViewController) {
        vc.performSegueWithIdentifier("IntoModalMenuSegueID", sender: nil)
    }
    
    private func presentContent(vc:UIViewController) {
        
        // this is made as a fake inline seque to avoid duble pushing of controllers
        
        let target = ShowContentViewController() // make one
        target.uniqueIdentifier = self.fetchStringArgForSegue()
        
        vc.presentViewController(target, animated: true, completion: nil)
        //     }
        //vc.performSegueWithIdentifier("ShowContentSegueID", sender: nil)
    }
    
    func showDoc(vc:UIViewController, named:String) {
        if Corpus.findFast(named) { // return s bool
            self.storeStringArgForSeque(named)
            self.presentContent(vc)
        }
    }
    
    func presentSectionEditor (vc:UIViewController) {
        vc.performSegueWithIdentifier("EditDelSegueInID", sender: nil)
    }
    func presentLinear (vc:UIViewController) {
        vc.performSegueWithIdentifier("LinearSegueInID", sender: nil)
    }
    func presentTilesEditor(vc:UIViewController){
        vc.performSegueWithIdentifier("EditTilesSequeId", sender: nil)
    }
    func presentMegaList(vc:UIViewController){
    
        vc.performSegueWithIdentifier("ModalMegaList", sender: nil)
    
    }
    func presentAddeds(vc:UIViewController){
        vc.performSegueWithIdentifier("ModalAddeds", sender: nil)
    }
    func presentRecents(vc:UIViewController){
        vc.performSegueWithIdentifier("ModalRecents", sender: nil)
    }
    func presentSettings(vc:UIViewController){
        vc.performSegueWithIdentifier("SettingsViewSegueID", sender: nil)
    }
    func presentSectionRenamor(vc:UIViewController){
        vc.performSegueWithIdentifier("SectionRenamorID", sender: nil)
    }
    func presentAllTitles(vc:UIViewController){
        vc.performSegueWithIdentifier("AllTitlesID", sender: nil)
    }
    
    func presentMore(vc:UIViewController) {
        vc.performSegueWithIdentifier("AddMoreContentMenuSegueID", sender: nil)
    }
    
    //
    
    func unwindFromHere(vc:UIViewController) {
        vc.performSegueWithIdentifier("UnwindORSegueID", sender: nil)
    }
}

// MARK: Transparent Top Navigation Bar
extension UINavigationController {
    //http://stackoverflow.com/questions/19082963/how-to-make-completely-transparent-navigation-bar-in-ios-7
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = Colors.clear
        setNavigationBarHidden(false, animated:true)
    }
    
    public func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = UINavigationBar.appearance().translucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
}
