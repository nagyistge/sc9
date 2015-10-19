//
//  SettingsViewController.swift
//  stories
//
//  Created by bill donner on 7/15/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

enum FrameStyle: Int {
    case WatchFrace = 0
    case TableFace = 1
    case None = 2
    
    func NameFor() -> String {
        if self == FrameStyle.WatchFrace { return "WatchFace" }
            else if self == FrameStyle.TableFace { return "TableFace" }
        return "None"
    }
}
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var useTouchIDLabel: UILabel!
    @IBOutlet weak var useTouchID: UISwitch!
    @IBOutlet weak var resetCorpusNextRestart: UISwitch!
    @IBOutlet weak var resetSurfaceNextRestart: UISwitch!
    
    var frameStyle = FrameStyle.None
    
    func presentMenu(vc:UIViewController, menu:String) {

        let qq = self.frameStyle.NameFor()
        let action : UIAlertController =
        
        UIAlertController(title:"Frame Style",
            message: "Currently \(qq)", preferredStyle: .ActionSheet)
        
        action.addAction(UIAlertAction(title: "Watch Face", style: .Default,handler: {alertAction in
            self.frameStyle = FrameStyle.WatchFrace
            self.ornamentation.setTitle(self.frameStyle.NameFor(),forState:.Normal)
        }))
        action.addAction(UIAlertAction(title: "Tablet Face", style: .Default,handler: {alertAction in
            self.frameStyle = FrameStyle.TableFace
            self.ornamentation.setTitle(self.frameStyle.NameFor(),forState:.Normal)
        }))
        action.addAction(UIAlertAction(title: "No Ornamentation", style: .Default,handler: {alertAction in
            self.frameStyle = FrameStyle.None
            self.ornamentation.setTitle(self.frameStyle.NameFor(),forState:.Normal)
        }))
        action.addAction(UIAlertAction(title: "Cancel", style: .Cancel,handler: {alertAction in
        }))
        
        action.modalPresentationStyle = .Popover
        let popPresenter = action.popoverPresentationController
        popPresenter?.sourceView = vc.view
        vc.presentViewController(action, animated: true , completion:nil)
    }

    @IBAction func pressedOrnamentation(sender: AnyObject) {
        presentMenu(self, menu: "slfalkds")
    }
    @IBOutlet weak var ornamentation: UIButton!
    
    @IBOutlet weak var titlesCounter: UILabel!
    @IBOutlet weak var sheetsCounter: UILabel!
    @IBAction func didChangeSetting(sender: AnyObject) {
        // move current values into NSUserDefaults
        Persistence.ornamentationStyle = "\(self.frameStyle)"
        
        Persistence.resetCorpusNextRestart =  self.resetCorpusNextRestart.on ?
            Persistence.Config.corpusKey : ""
        
        Persistence.resetSurfaceNextRestart = self.resetSurfaceNextRestart.on ?
            Persistence.Config.surfaceKey : ""
        
        Persistence.useTouchID = self.useTouchID.on ?
            Persistence.Config.touchIDKey : ""
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let x = Corpus.shared.docIDSeqNum - initialDocSeqNum
        self.titlesCounter.text = "\(Corpus.uniques(Corpus.sorted()).count)"
        self.sheetsCounter.text = "\(x)"
        
        self.useTouchID.on = Persistence.useTouchID?.characters.count > 0
        
        self.resetSurfaceNextRestart.on  =   Persistence.resetSurfaceNextRestart?.characters.count > 0
        
        
        self.resetCorpusNextRestart.on =   Persistence.resetCorpusNextRestart?.characters.count > 0
        
        // Do any additional setup after loading the view.
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
