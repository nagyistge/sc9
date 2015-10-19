//
//  RestoreEngine.swift
//  stories
//
//  Created by bill donner on 9/3/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
typealias RestoralCompletion = ()->()

class RestoreEngine : NSObject {
    
    var coverView: UIView?
    var restoreComplete: RestoralCompletion?
    //var holderView : StartupAnimationView!
 

    func waitForRestorationAndAnimation(viewController:UIViewController,completion:RestoralCompletion?)
    {
        self.restoreComplete = completion
        /// 3 - if not done yet put up a spinner
        if Globals.shared.restored == false {
            print ("Must Stall until reload done")
            coverView = UIView(frame:viewController.view.frame)
            coverView?.backgroundColor = UIColor.grayColor()
            viewController.view.addSubview(coverView!)
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "stallcheck", userInfo: nil, repeats: false)
            
        } else {
            // no stall needed
            if self.restoreComplete != nil {
                          print ("No Stall Needed")
                (self.restoreComplete)!()
            }
        }
    }
    internal func stallcheck() {
        if Globals.shared.restored == false {
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "stallcheck", userInfo: nil, repeats: false)
            print ("stalling...")
        }
        else {
            coverView?.removeFromSuperview()
            if self.restoreComplete != nil {
                (self.restoreComplete)!()
            }
        }
    }
//    func startRestorationWithAnimation(viewController:UIViewController) {
//
//        /// 0 - get restore going in background, set flag when done
//        
//        
//        doThis( {SurfaceDataModel.restoreDataModel() },
//            
//            thenThat: { Globals.shared.restored = true } )
//        
//        /// 1 - animation from SB Loader
//        
//        
//      let hv  = StartupAnimationView(frame:CGRectZero)
//        
//        hv.parentFrame = viewController.view.frame
//      
//        hv.delegate = viewController
//        hv.finalSignal = {
////            if viewController is MasterTodayViewController {
////                let vc = viewController as! MasterTodayViewController
////                vc.fullyUpAndRunning() // back up the line
//            print("restore engine finished")
//            
//            }
//        }
//        
//        let boxSize: CGFloat = 100.0
//        
//        hv.frame = CGRect(x: viewController.view.bounds.width / 2 - boxSize / 2,
//            y: viewController.view.bounds.height / 2 - boxSize / 2,
//            width: boxSize,
//            height: boxSize)
//        
//        
//        hv.addOval()
//        
//        
//        
//        
//        viewController.view.addSubview(hv)
//        
//    }
//
    
}
