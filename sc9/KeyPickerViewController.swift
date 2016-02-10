//
//  KeyPickerViewController.swift
//  stories
//
//  Created by bill donner on 8/8/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
protocol KeyPickerViewControllerDelegate
{
    func keySelectionChanged(selectedKey   key: [String])
}

class KeyPickerViewController: UIViewController , ExCo, TodayReady, UIPickerViewDataSource, UIPickerViewDelegate {
    //var whichTile: Tyle?
    var changedSomething: Bool=false
    var delegate: KeyPickerViewControllerDelegate?
    var pickerSetup : String?// 3, one for each
    var initialPickerSetup : String?// for reset
    let allkeys = [" ","A","B","C","D","E","F","G"]
    let flatsharp = [" ","b","#"]
    let modes = [" ","min","maj"]
    var v3 = [0,0,0] //indicesinto each list
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
 
    override func shouldAutorotate() -> Bool {
        return false
    }
    @IBAction func applyTapped(sender: AnyObject) {
        // write backthru delegate     
        let a = self.pickerView.selectedRowInComponent(0)
        let b = self.pickerView.selectedRowInComponent(1)
        let c = self.pickerView.selectedRowInComponent(2)
        let q = allkeys[a]
        let r = flatsharp[b]
        let s = modes[c]
        //print("apply tapped with \(q) \(r) \(s)")
        pickerSetup = pencode([q,r,s])
        
   delegate?.keySelectionChanged( selectedKey: [q,r,s])
        self.performSegueWithIdentifier("CancelUnwindKeyPickerSequeID", sender: self)
    }
    
    @IBOutlet weak var keyValue: UILabel!
    
    func cancelPressed () {
        self.performSegueWithIdentifier("CancelUnwindKeyPickerSequeID", sender: self)
    }
    @IBAction func cancelHit(sender: AnyObject) {
        if changedSomething {
            self.confirmYesNoFromVC(self, title: "Save Changes?", mess: "you will lose your changes"){ b in
                if b {
                    self.applyTapped(self)
                } else {
                    self.cancelPressed()
                }
            }
        } else {
            // if no changes just proceed
            self.cancelPressed()
        }
    }
    @IBAction func clearTapped(sender: AnyObject) {
        pickerSetup = pencode([" "," "," "])
        reloadUI()
    }
    @IBAction func resetTapped(sender: AnyObject) {
        pickerSetup = initialPickerSetup
        reloadUI()
    }
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let a = self.pickerView.selectedRowInComponent(0)
        let b = self.pickerView.selectedRowInComponent(1)
        let c = self.pickerView.selectedRowInComponent(2)
        let q = allkeys[a]
        let r = flatsharp[b]
        let s = modes[c]
        
       keyValue.text = q+r+s
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return allkeys.count
        case 1: return flatsharp.count
        default: return modes.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return allkeys[row]
        case 1: return flatsharp[row]
        default: return modes[row]
        }
    }
    
    func getComponentPositions(pickerSet:String )->[Int] {
        var ind:Int
        ind = 0
        var x3 = [0,0,0]
        let ps = pdecode(pickerSetup!)
        for ak in allkeys {
            if ak == ps [0] {
                x3[0] = ind
                break
            }
            else {ind++}
        }
        if ps.count > 1 {
            ind = 0
            for fs in flatsharp {
                if fs == ps [1] {
                    x3[1] = ind
                    break
                }
                else  {ind++}
            }
        }
        if ps.count > 2 {
            ind = 0
            for mo in modes {
                if mo == ps [2] {
                    x3[2] = ind
                    break
                }
                else   {ind++}
            }
        }
        return x3
    }
    
    // given the initial key, position the wheels
    func reloadUI() {
        v3 = getComponentPositions(pickerSetup!)


        
        // now we have the correct positions
        pickerView.selectRow(v3[0], inComponent: 0, animated: true)
        pickerView.selectRow(v3[1], inComponent: 1, animated: true)
        pickerView.selectRow(v3[2], inComponent: 2, animated: true)
        
        let a = self.pickerView.selectedRowInComponent(0)
        let b = self.pickerView.selectedRowInComponent(1)
        let c = self.pickerView.selectedRowInComponent(2)
        let q = allkeys[a]
        let r = flatsharp[b]
        let s = modes[c]
        
keyValue.text = q+r+s

    }
    // MARK: - Segue Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        guard segue.identifier != nil else {
            print("tyle imings with prepareForSegue nil identifier")
            return
        }
        switch (segue.identifier!) {
            
        case "CancelUnwindKeyPickerSequeID":
            print("leaving keypicker via Cancel")
            return
        default: return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  print("key picker started with \(whichTile!.tyleKey)")
//        
//        let vv = CGRect(x:0,y:90,width:self.view.frame.width,height:IOSConstants.tileSize.height)
//        self.dualView = DualView(frame:vv)
//        self.dualView.loadFrom(whichTile!)
//        self.view.addSubview(self.dualView)
        initialPickerSetup = pickerSetup // save the incoming
        // delegates must get set before calls to selectRow
        pickerView.dataSource = self
        pickerView.delegate = self
        reloadUI()
    }
    
}