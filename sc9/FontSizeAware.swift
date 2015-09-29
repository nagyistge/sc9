//
//  FontSizeAware.swift
//
//  Created by william donner on 9/27/15.
//

import UIKit

protocol FontSizeAware {
	func refreshFontSizeAware (vc:UIViewController)
	func setupFontSizeAware (vc:UIViewController)
	func cleanupFontSizeAware (vc:UIViewController)
}
extension FontSizeAware {

	func cleanupFontSizeAware (vc:UIViewController) {
		NSNotificationCenter.defaultCenter().removeObserver(vc)
	}

	func refreshFontSizeAware (vc:UIViewController) {
		vc.view.setNeedsDisplay()
		print("Did Hit Refresh")

	}
	func setupFontSizeAware (vc:UIViewController){
		// if the fontsize changes refresh everthing
		NSNotificationCenter.defaultCenter().addObserver(vc, selector: Selector("refresh"),name: UIContentSizeCategoryDidChangeNotification, object: nil)
	}
}

