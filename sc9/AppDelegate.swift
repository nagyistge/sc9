//
//  AppDelegate.swift
//  stories
//
//  Created by william donner on 6/26/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
import CoreSpotlight


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate  {
    
    var window: UIWindow?
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
          let objectId: String
        if userActivity.activityType == Globals.UserActivityType,
            let activityObjectId = userActivity.userInfo?["id"] as? String {
                // Handle result from NSUserActivity indexing
                
                print("****UserActivityType stuff with \(activityObjectId)")
                objectId = activityObjectId
        }
        else
        if userActivity.activityType == CSSearchableItemActionType {
            let aIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as! String
            print("****CSSearchableItemActionType stuff with \(aIdentifier)")
            objectId = aIdentifier
            
        }
        else {
            print("****continueUserActivity stuff with unknown \(userActivity.activityType)")
            return false
        }
        
            let t = ContinueUserActivityViewController()
            t.uniqueIdentifier = objectId
            let vc = window!.rootViewController
            
            if vc is UINavigationController {
                // if nav just push
                let nvc = vc as! UINavigationController
                nvc.pushViewController(t,animated:true)
            }
            else {
                // if no nav then wrap
                let nav  = UINavigationController(rootViewController:t)
                vc?.presentViewController(nav, animated: true, completion: nil)
            }
        return true
    }
    
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool
    {

        Globals.shared.openURLOptions = options
        let t = CommandProcessorViewController()
        t.command = url.absoluteString
        
        let vc = window!.rootViewController
        
        if vc is UINavigationController {
            // if nav just push
            let nvc = vc as! UINavigationController
            // get rid of whatsever on top, wind all the way down, then push the background conroller which will open the document
            nvc.topViewController?.dismissViewControllerAnimated(false, completion: nil)
            nvc.popToRootViewControllerAnimated(false)
            nvc.pushViewController(t,animated:true)
        }
        else {
            // if no nav then wrap
            let nav  = UINavigationController(rootViewController:t)
            vc?.presentViewController(nav, animated: true, completion: nil)
        }
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        
        NSLog ("didFinishLaunchingWithOptions options: \(launchOptions)")
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        FS.shared.bootstrap() // setup temporary filesystem
        
        Globals.shared.launchOptions = launchOptions
        //Globals.shared.splitViewController = splitViewController
        
        // run recovery push directly
//        
//        let vc = StartupAnimationViewController()
//        let nav = UINavigationController(rootViewController: vc)
//        self.presentViewController(nav , animated: true, completion: nil)
        
        return true
    }
    // MARK: - Split view delegate - needed to start on master
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        //        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        //        guard let _ = secondaryAsNavController.topViewController as? StoriesViewController else { return false }
        //if topAsDetailController.pancakeHouse == nil {
        // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return true
        //        }
        //return false
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

/*

//        let splitViewController = self.window!.rootViewController as! UISplitViewController
//        splitViewController.delegate = self
//        splitViewController.preferredDisplayMode = .Automatic///.PrimaryHidden

//        let rightNavController = splitViewController.viewControllers.last as! UINavigationController
//        if let _ = rightNavController.topViewController {
//
////            detailViewController.navigationItem.leftItemsSupplementBackButton = true
////            detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
//
//        }

// only do detail, master is setup after initial detail animation completes

//        let detailVC = UIStoryboard(name:"Main", bundle:nil).instantiateViewControllerWithIdentifier("StartupAnimationViewControllerID") as! UINavigationController //StartupAnimationViewController
//
//       // wait for detail animations  splitViewController.showViewController(masterVC,sender:self)
//        splitViewController.showDetailViewController(detailVC,sender:self)

application.statusBarHidden = false
UITextField.appearanceWhenContainedInInstancesOfClasses([UIViewController.self]).keyboardAppearance = .Light

UINavigationBar.appearanceWhenContainedInInstancesOfClasses([UIViewController.self]).barTintColor = Colors.blue//UIColor.blackColor()

UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]

UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UIViewController.self]).tintColor = UIColor.whiteColor()

UIToolbar.appearanceWhenContainedInInstancesOfClasses([UIViewController.self]).tintColor = UIColor.redColor()
*/