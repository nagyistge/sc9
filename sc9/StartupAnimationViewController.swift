//
//  StartupAnimationViewController.swift
//  stories
//
//  Created by bill donner on 9/21/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

typealias RestoralCompletion = ()->()

private class RestoreEngine : NSObject {
    
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
    private func stallcheck() {
        if Globals.shared.restored == false {
            NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "stallcheck", userInfo: nil, repeats: false)
            print ("stalling...")
        }
        else {
            coverView?.removeFromSuperview()
            if self.restoreComplete != nil {
                (self.restoreComplete)!()
            }
        }
    }
}


private class Startup {
    var restoreEngine:RestoreEngine?
    
    func finish(vc:UIViewController) {
        restoreEngine!.waitForRestorationAndAnimation(vc){
            print(">>>Startup Animations done")
            
            // when everything is final in place
            NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceRestorationCompleteSignal,object:nil)
        }
    }
    
    
    func startup(vc:UIViewController,completion:()->())->UIView {
        /// background......
        /// restore NSUserDefaults and reconfigure datamodel if required
        let inframe = vc.view.frame
        Persistence.processRestartParams()
        restoreEngine = RestoreEngine()
        
        doThis( {   Globals.restoreDataModel() },
            
            thenThat: {
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

protocol StartAnima  {
    func restoreViews()
}


extension StartupAnimationViewController: StartAnima {
    func restoreViews() {
        if Globals.shared.restored == false {
            self.navigationItem.leftBarButtonItem?.enabled = false
            s = Startup()
            print(">>>Startup Animations beginning...")
            let animationView = s!.startup(self) {
                //print("Startup Sequence ending...")
                self.s!.finish(self)
                self.performSegueWithIdentifier("AnimationSequenceDone", sender: nil)
                self.navigationItem.leftBarButtonItem?.enabled = true
                self.dismissViewControllerAnimated(true, completion: nil) // bug out
            }
            self.view.addSubview(animationView)
        } else {
            print ("Restore flag was already set at startup")
        }
    }
    }
    
class StartupAnimationViewController: UIViewController {
   private var s: Startup?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restoreViews()
    }
}