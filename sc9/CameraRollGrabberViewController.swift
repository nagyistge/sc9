//
//  CameraRollGrabberViewController.swift
//  sc9
//
//  Created by william donner on 9/30/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

final class CameraRollGrabberViewController: UIImagePickerController,
	UINavigationControllerDelegate, // required by image picker
UIImagePickerControllerDelegate{

	var button: UIButton!
	var imageView: UIImageView!
	func done() {
		// just remove the little overlay
		self.imageView.removeFromSuperview()
		self.imageView = nil
		self.button.removeFromSuperview()
		self.button = nil
		//self.navigationController?.popViewControllerAnimated(true)
		//self.dismissViewControllerAnimated(true, completion: nil)
	}
	//	func done() {
	//		//self.navigationController?.popViewControllerAnimated(true)
	//		self.dismissViewControllerAnimated(true, completion: nil)
	//	}

	// MARK: Lifecycle
	override func viewDidLoad() {
		print("CameraRollGrabberViewController viewDidLoad")
		super.viewDidLoad()
		self.delegate = self

		self.sourceType = .PhotoLibrary

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	func makeTitle()->String {
		let now = NSDate()
		return "PhotoLibrary \(now)"

	}
	// MARK: UIImagePickerControllerDelegate
	func imagePickerController(picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [String : AnyObject]) {


			guard let theImage = info[UIImagePickerControllerOriginalImage] as? UIImage  else {
				fatalError("Could not retrieve original Photo from camera")
			}
			imageView = UIImageView(image:theImage)
			self.view.addSubview(imageView)
			button = UIButton(frame:CGRect(x:0,y:0,width:50,height:50))
			button.setTitle("BYE", forState: .Normal)

			button.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
			self.view.addSubview(button)


			/// Stash Content in background

			let bits =  UIImagePNGRepresentation(theImage)
			print("Got bits count ",bits?.length)
			
	}// end of func
	
}

