//
//  Startup.swift
//  stories
//
//  Created by bill donner on 9/21/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

class Startup {
    var restoreEngine:RestoreEngine?
    
    func finish(vc:UIViewController) {
        restoreEngine!.waitForRestorationAndAnimation(vc){
        print("WaitforRestoration done")
            
 // when everything is final in place
            NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceRestorationCompleteSignal,object:nil)
            
            
//        let masterVC = UIStoryboard(name:"Main",bundle:nil).instantiateViewControllerWithIdentifier("TilesViewControllerID") as! TilesViewController
////         let baseMaster = vc.splitViewController!.viewControllers[1]
////            baseMaster.presentViewController(masterVC, animated: false, completion: nil)
//            
//            //vc.navigationController?.navigationBarHidden = false
           vc.navigationItem.leftItemsSupplementBackButton = true
           vc.navigationItem.leftBarButtonItem = vc.splitViewController!.displayModeButtonItem()
            

        }
    }

    
    func startup(vc:UIViewController,completion:()->())->UIView {
        /// background......
        /// restore NSUserDefaults and reconfigure datamodel if required
        let inframe = vc.view.frame
        Persistence.processRestartParams()
        restoreEngine = RestoreEngine()

        doThis( {
            SurfaceDataModel.restoreDataModel() },
            
            thenThat: {
                
                /// 0 - get restore going in background, set flag when done
                
                Globals.shared.restored = true }
        )
        /// 1 - animation from SB Loader
        let boxSize: CGFloat = 100.0
        
        let frame = CGRect(x: inframe.width / 2 - boxSize / 2,
            y: inframe.height / 2 - boxSize / 2,
            width: boxSize,
            height: boxSize)
        
        let hv  = StartupAnimationView(frame:frame)
        
        hv.parentFrame = inframe
        
        hv.delegate = vc
        hv.finalSignal = {
            completion() // back up the line
        }
        
        hv.addOval()
        return hv
    }
    
}