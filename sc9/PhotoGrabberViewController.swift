//
//  CameraRollGrabberViewController
//

import UIKit
import CoreLocation


final class PhotoGrabberViewController: UIImagePickerController,
	UINavigationControllerDelegate, // required by image picker
	SegueHelpers{

    var stashDelegate: StashPhotoOps?
    
	let locationManager = CLLocationManager()
	var lastPlacemark : CLPlacemark?

	var button: UIButton!
	var imageView: UIImageView?
	func done() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}

	// MARK: Lifecycle
	override func viewDidLoad() {
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
			
    self.stashDelegate?.stashPhoto(theImage!)
    self.dismissViewControllerAnimated(true, completion: nil)
	}// end of func
}

extension PhotoGrabberViewController :CLLocationManagerDelegate{
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