//
//  FirstUpViewController.swift
//  sc9
//
//  Created by bill donner on 12/31/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

// puts but a full screen controller that simply shows the main color

// used as a background under the TilesViewController

class FirstUpViewController: UIViewController {
    
    
    var observer1 : NSObjectProtocol?  // emsure ots retained
    
    deinit{
  
        NSNotificationCenter.defaultCenter().removeObserver(observer1!)
      
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Now present the TilesViewController modally
        
        self.performSegueWithIdentifier("StartinTilesVCSeque", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Colors.mainColor()
        
        observer1 =  NSNotificationCenter.defaultCenter().addObserverForName(kSurfaceUpdatedSignal, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            print ("Surface was updated, FirstUpViewController reacting....")
             self.view.backgroundColor = Colors.mainColor()
        }
        // and finally we will just sit around forever, wasting a bit of memory unless we self immolate
        
        
        
        Persistence.processRestartParams()
        //restoreEngine = RestoreEngine()
        // colors
        if let scheme = Persistence.colorScheme {
            if let colorIdx = Colors.findColorIndexByName(scheme) {
                Globals.shared.mainColors = ColorSchemeOf(ColorScheme.Complementary, color:Colors.allColors[colorIdx], isFlatScheme: true)
            }
        }
        doThis({
            NSLog("FirstUpViewController restoring datamodel")
            Globals.restoreDataModel()
            },
            
            thenThat: {
                Globals.shared.restored = true
                // when everything is final in place
                NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceRestorationCompleteSignal,object:nil)
        })
        NSLog("FirstUpViewController finished viewDidLoad")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
