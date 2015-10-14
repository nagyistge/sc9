//
//  SegueSupport.swift
//
//  Created by william donner on 9/27/15.

import UIKit

protocol CellHelper {
	func configureCell(t :ElementType)
}
extension UITableViewCell:CellHelper {
	func configureCell(t :ElementType) {
		self.textLabel!.text  = t[ElementProperties.NameKey]! as String 
		self.textLabel!.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
		self.textLabel!.textColor = .whiteColor()
		self.backgroundColor = .clearColor()
		self.contentView.backgroundColor = .clearColor()
	}
}
final class TilesSectionHeaderView: UICollectionReusableView {
	@IBOutlet weak var headerLabel: UILabel!
}

final class   TileCell: UICollectionViewCell, CellHelper {
	@IBOutlet var alphabetLabel: UILabel!

	func configureCell(t:ElementType) {
		self.alphabetLabel.text = t[ElementProperties.NameKey] as String!
		self.alphabetLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
	}
}
protocol SequeHelpers {

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
	func presentSearch(vc:UIViewController)
	func presentMore(vc:UIViewController)
	func presentShootPhoto(vc:UIViewController)
	func presentAddPhotos(vc:UIViewController)
	func presentImportItunes(vc:UIViewController)
	func presentEditTile(vc:UIViewController)
	func presentTilesEditor(vc:UIViewController)
	func presentAny(vc:UIViewController,identifier:String)

	func unwindFromHere(vc:UIViewController)
	func prepForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
}
extension SequeHelpers {

	func storeStringArgForSeque(s:String) {
		Model.data.segueargs["StringParam1"] = s

	}
	func fetchStringArgForSegue()  -> String? {
		let m =  Model.data.segueargs["StringParam1"]
		if (m as? String != nil) {
			return m! as? String
		}
		return nil
	}

	func storeIndexArgForSeque(s:NSIndexPath) {
	Model.data.segueargs["IndexParam1"] = s
	}
	func fetchIndexArgForSegue()  -> NSIndexPath? {
		let m =  Model.data.segueargs["IndexParam1"]
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
					uiv .modalPresentationStyle = .FullScreen;
				} else
					if let uiv = nav.topViewController as? CameraRollGrabberViewController {
						uiv .modalPresentationStyle = .FullScreen;
					} else
				if let uiv = nav.topViewController as? ShowContentViewController {
					uiv.name = self.fetchStringArgForSegue()
					// set variables in our superclass
					uiv.uniqueIdentifier = uiv.name //looks like a title now
					let fileURL = NSBundle.mainBundle().URLForResource( "furelisepng", withExtension:"pdf")!

					uiv.urlList = [fileURL.absoluteString]
					
				} else if let uiv = nav.topViewController {
					uiv.modalPresentationStyle = .OverCurrentContext;
					uiv.modalTransitionStyle = .CrossDissolve
				}
			} else { // not wrapped as nav
				let con = segue.destinationViewController as UIViewController
				if let uiv = con as? PhotoGrabberViewController {
					uiv .modalPresentationStyle = .FullScreen;
				} else
					if let uiv = con as? CameraRollGrabberViewController{
						uiv .modalPresentationStyle = .FullScreen;
					} else
				if let uiv = con as? ShowContentViewController {
					uiv.name = self.fetchStringArgForSegue()
				// set variables in our superclass
				uiv.uniqueIdentifier = uiv.name //looks like a title now
				let fileURL = NSBundle.mainBundle().URLForResource( "furelisepng", withExtension:"pdf")

					uiv.urlList = [fileURL!.absoluteString]

				} else {// not showcontent
				con.modalPresentationStyle = .OverCurrentContext;
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

	func presentShootPhoto(vc:UIViewController){


		//1>let target  = UIStoryboard(name:"Main",bundle:nil).instantiateViewControllerWithIdentifier("ChoosePhotosID") as? PhotoGrabberViewController {

		//2>
			let target = PhotoGrabberViewController()
		vc.presentViewController(target, animated: true, completion: nil)
		//3vc.performSegueWithIdentifier("ModalShootPhoto", sender: nil)
		
	}
	func presentAddPhotos(vc:UIViewController){
		let target = CameraRollGrabberViewController()

		vc.presentViewController(target, animated: true, completion: nil)
		//vc.performSegueWithIdentifier("ModalAddPhotos", sender: nil)
	}
	func presentImportItunes(vc:UIViewController){
		vc.performSegueWithIdentifier("ModalImportItunes", sender: nil)
	}
	func presentModalMenu(vc:UIViewController) {
		vc.performSegueWithIdentifier("IntoModalMenuSegueID", sender: nil)
	}

	func presentContent(vc:UIViewController) {

		// this is made as a fake inline seque to avoid duble pushing of controllers 
		
		let target = ShowContentViewController() // make one
		target.uniqueIdentifier = self.fetchStringArgForSegue()
		let fileURL = NSBundle.mainBundle().URLForResource( "furelisepng", withExtension:"pdf")!

		target.urlList = [fileURL.absoluteString]
		vc.presentViewController(target, animated: true, completion: nil)
		//		vc.performSegueWithIdentifier("ShowContentSegueID", sender: nil)
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
	func presentSearch(vc:UIViewController){
		vc.performSegueWithIdentifier("ModalSearch", sender: nil)
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
		navigationBar.backgroundColor = .clearColor()
		setNavigationBarHidden(false, animated:true)
	}

	public func hideTransparentNavigationBar() {
		setNavigationBarHidden(true, animated:false)
		navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default), forBarMetrics:UIBarMetrics.Default)
		navigationBar.translucent = UINavigationBar.appearance().translucent
		navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
	}
}
