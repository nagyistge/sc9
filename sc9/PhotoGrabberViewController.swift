//
//  CameraRollGrabberViewController
//

import UIKit

import CoreLocation



final class PhotoGrabberViewController: UIImagePickerController,
	UINavigationControllerDelegate, // required by image picker
	CLLocationManagerDelegate ,SegueHelpers{

	let locationManager = CLLocationManager()
	var lastPlacemark : CLPlacemark?

	var button: UIButton!
	var imageView: UIImageView?
	func done() {
		// just remove the little overlay
		self.imageView?.removeFromSuperview()
		self.imageView = nil
		self.button.removeFromSuperview()
		self.button = nil
        //self.unwindFromHere(self)
		//self.navigationController?.popViewControllerAnimated(true)
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	// MARK: Lifecycle
	override func viewDidLoad() {
		print("PhotoGrabberViewController viewDidLoad")
		super.viewDidLoad()
        self.delegate = self  // this line when moved into takephoto causes archiving to fail!!!
		// Do any additional setup after loading the view, typically from a nib.
		/// ask for gps permission

		if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
			self.sourceType = .Camera
			self.locationManager.delegate = self
			self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
			self.locationManager.requestWhenInUseAuthorization()
			self.locationManager.startUpdatingLocation()
		} else {
			self.sourceType = .PhotoLibrary
		}

	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	func makeTitle()->String {
		let now = NSDate()
		return "SnapShot \(now)"

	}
}
extension PhotoGrabberViewController : UIImagePickerControllerDelegate {
	// MARK: UIImagePickerControllerDelegate
	func imagePickerController(picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            var theImage:UIImage?  = (info[UIImagePickerControllerEditedImage] as? UIImage)
            if theImage == nil {
                theImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            }

			guard theImage != nil   else {
				fatalError("Could not retrieve Photo from camera")
			}
			
			//if introOverlayLabel != nil {introOverlayLabel.removeFromSuperview()}

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

			let bits =  UIImagePNGRepresentation(theImage!)
			print("Got bits count ",bits?.length)

			/// SEND notifications

	}// end of func




	// MARK: CLLocationManagerDelegate
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in

			if (error != nil) {
				print("Error: ",error!.localizedDescription)
				return
			}
			// even if we get multiple completions throw them all out and stop
			if placemarks!.count > 0 && self.lastPlacemark == nil {
				let pm = placemarks![0] as CLPlacemark
				self.displayLocationInfo(pm)
				self.lastPlacemark = pm // stash this


			} else {
				print("Error with the data.")
			}

			// for now we only need this once

			self.locationManager.stopUpdatingLocation()
		})
	}

	func displayLocationInfo(placemark: CLPlacemark) {

		print(placemark.locality)
		print(placemark.postalCode)
		print(placemark.administrativeArea)
		print(placemark.country)

	}

	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Error: ",error.localizedDescription)
	}
	
}