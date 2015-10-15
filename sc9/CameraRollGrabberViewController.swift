//
//  CameraRollGrabberViewController.swift
//  sc9
//
//  Created by william donner on 9/30/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

final class CameraRollGrabberViewController: UIImagePickerController,
	UINavigationControllerDelegate, SegueHelpers // required by image picker
 {

	var button: UIButton!
	var imageView: UIImageView?
    
	func done() {
		// just remove the little overlay
		self.imageView?.removeFromSuperview()
		self.imageView = nil
		self.button.removeFromSuperview()
        self.button = nil
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
	}

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
}

extension CameraRollGrabberViewController: UIImagePickerControllerDelegate {
	// MARK: UIImagePickerControllerDelegate
	func imagePickerController(picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [String : AnyObject]) {
			guard let theImage = info[UIImagePickerControllerOriginalImage] as? UIImage  else {
				fatalError("Could not retrieve original Photo from camera")
			}
            
            imageView = UIImageView(frame:UIScreen.mainScreen().bounds)
            if imageView != nil {
                imageView!.contentMode = .ScaleAspectFill
                imageView!.image = theImage
                self.view.addSubview(imageView!)
            }
            
			button = UIButton(frame:CGRect(x:0,y:0,width:80,height:80))
			button.setTitle("X", forState: .Normal)
			button.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
			self.view.addSubview(button)
			/// Stash Content in background

			let bits =  UIImagePNGRepresentation(theImage)
			print("Got bits count ",bits!.length)
	}// end of func
}

