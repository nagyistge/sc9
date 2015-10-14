//
//  CameraRollGrabberViewController
//

import UIKit

import CoreLocation



final class PhotoGrabberViewController: UIImagePickerController,
	UINavigationControllerDelegate, // required by image picker
	UIImagePickerControllerDelegate,
	CLLocationManagerDelegate {

	let locationManager = CLLocationManager()
	var lastPlacemark : CLPlacemark?

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
	// MARK: UIImagePickerControllerDelegate
	func imagePickerController(picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [String : AnyObject]) {


			guard let theImage = info[UIImagePickerControllerOriginalImage] as? UIImage  else {
				fatalError("Could not retrieve original Photo from camera")
			}
			//imageView.image = theImage
			//if introOverlayLabel != nil {introOverlayLabel.removeFromSuperview()}

			imageView = UIImageView(image:theImage)
			self.view.addSubview(imageView)
			button = UIButton(frame:CGRect(x:0,y:0,width:50,height:50))
			button.setTitle("BYE", forState: .Normal)

			button.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
			self.view.addSubview(button)


			/// Stash Content in background

			let bits =  UIImagePNGRepresentation(theImage)
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