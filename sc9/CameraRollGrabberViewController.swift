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
    var theImage:UIImage!
    var stashDelegate: StashPhotoOps? // passed thru from caller
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        print("CameraRollGrabberViewController viewDidLoad")
        super.viewDidLoad()
        self.delegate = self
        self.sourceType = .PhotoLibrary
    }
}

extension CameraRollGrabberViewController: UIImagePickerControllerDelegate{

    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            theImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            guard theImage != nil else {
                fatalError("Could not retrieve original Photo from camera")
            }
            
            let uiv = PhotoKeeperQueryViewController()
            uiv.theImage = theImage
            uiv.stashDelegate = stashDelegate
            self.presentViewController(uiv, animated: true, completion: nil)
            //self.navigationController?.pushViewController(uiv , animated: false)
         
            
    }// end of func
    
}
