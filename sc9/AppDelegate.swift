//
//  AppDelegate.swift
//  sc9
//
//  Created by william donner on 9/29/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
protocol TodayReady {
    
}
extension TodayReady {
    func blurt (vc:UIViewController, title:String, mess:String, f:()->()) {
        
        let action : UIAlertController = UIAlertController(title:title, message: mess, preferredStyle: .Alert)
        
        action.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: {alertAction in
            f()
        }))
        
        action.modalPresentationStyle = .Popover
        let popPresenter = action.popoverPresentationController
        popPresenter?.sourceView = vc.view
        vc.presentViewController(action, animated: true , completion:nil)
    }
    func blurt (vc:UIViewController, title:String, mess:String) {
        blurt(vc,title:title,mess:mess,f:{})
    }
    
    
    
    // a simple yes/no question
    func confirmYesNoFromVC (vc:UIViewController, title:String, mess:String, f:(Bool)->()) {
        
        let action : UIAlertController = UIAlertController(title:title, message: mess, preferredStyle: .Alert)
        action.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {alertAction in
            f(true)
        }))
        action.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {alertAction in
            f(false)
        }))
        
        action.modalPresentationStyle = .Popover
        let popPresenter = action.popoverPresentationController
        popPresenter?.sourceView = vc.view
        vc.presentViewController(action, animated: true , completion:nil)
    }
    
    
    
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

