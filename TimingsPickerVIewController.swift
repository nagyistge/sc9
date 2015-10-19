//
//  TimingsPickerVIewController.swift
//  stories
//
//  Created by bill donner on 8/8/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

/// unwinds via manual segue
protocol TimingsPickerViewControllerDelegate
{
    func timingsSelectionChanged(selectedTimings   timings: [String])
}

class TimingsPickerViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate, ExCo,TodayReady {
    //var whichTile: Tyle?
    var changedSomething = false
    var pickerSetup : String? // pipe delimited
    var delegate: TimingsPickerViewControllerDelegate?
    var initialPickerSetup : String?// for reset
    
    var allbpmvec : [String] = []
    var allnumvec : [String] = []
    var alldenvec : [String] = []
    var v3 = [0,0,0] //indicesinto each list
    
    func pickervalues (low:Int,high:Int) -> [String] {
        var z :[String] = []
        z.append(" ")
        for i in low..<high {
            z.append("\(i)")
        }
        return z
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    @IBOutlet weak var bpmValue: UILabel!
    
    @IBAction func applyTapped(sender: AnyObject) {
        // write backthru delegate
        
        let a = self.pickerView.selectedRowInComponent(0)
        let b = self.pickerView.selectedRowInComponent(1)
        let c = self.pickerView.selectedRowInComponent(2)
        let q = allbpmvec[a]
        let r = allnumvec[b]
        let s = alldenvec[c]
        pickerSetup = pencode([q,r,s])
       delegate?.timingsSelectionChanged(selectedTimings: [q,r,s])
self.performSegueWithIdentifier("CancelUnwindTimingsSequeID", sender: self)
    }
    @IBAction func clearTapped(sender: AnyObject) {
        pickerSetup = pencode([" "," "," "])
        reloadUI()
    }
    @IBAction func resetTapped(sender: AnyObject) {
        pickerSetup = initialPickerSetup
        reloadUI()
    }
    
    
    func cancelPressed () {
        self.performSegueWithIdentifier("CancelUnwindTimingsSequeID", sender: self)
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
    @IBOutlet weak var pickerView: UIPickerView!
    
 //   var dualView: DualView! // must get pasted over
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let a = self.pickerView.selectedRowInComponent(0)
        let b = self.pickerView.selectedRowInComponent(1)
        let c = self.pickerView.selectedRowInComponent(2)
        let q = allbpmvec[a]
        let r = allnumvec[b]
        let s = alldenvec[c]
        
     bpmValue.text = q+" "+r+" "+s
        changedSomething = true
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return allbpmvec.count
        case 1: return allnumvec.count
        default: return alldenvec.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return allbpmvec[row]
        case 1: return allnumvec[row]
        default: return alldenvec[row]
        }
    }
    // given the initial key, position the wheels
    
    func getComponentPositions(pickerSet:String )->[Int] {
        let ps = pdecode(pickerSet)
        var ind:Int
        var x3 = [0,0,0]
        ind = 0
        for ak in allbpmvec {
            if ak == ps[0] {
                x3[0] = ind
                break
            }
            else {ind++}
        }
        if ps.count > 1 {
            ind = 0
            for fs in allnumvec {
                if fs == ps[1] {
                    x3[1] = ind
                    break
                }
                else  {ind++}
            }
        }
        if ps.count > 2 {
            ind = 0
            for mo in alldenvec {
                if mo == ps[2] {
                    x3[2] = ind
                    break
                }
                else   {ind++}
            }
        }
        return x3
    }
    
    func reloadUI() {
        
        v3 = getComponentPositions(pickerSetup!)
        
        
        pickerView.selectRow(v3[0], inComponent: 0, animated: true)
        pickerView.selectRow(v3[1], inComponent: 1, animated: true)
        pickerView.selectRow(v3[2], inComponent: 2, animated: true)
        
        
        let a = self.pickerView.selectedRowInComponent(0)
        let b = self.pickerView.selectedRowInComponent(1)
        let c = self.pickerView.selectedRowInComponent(2)
        let q = allbpmvec[a]
        let r = allnumvec[b]
        let s = alldenvec[c]
        
      //  
        bpmValue.text = q+" "+r+" "+s
    }
    
    
    // MARK: - Segue Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        guard segue.identifier != nil else {
            print("tyle imings with prepareForSegue nil identifier")
            return
        }
        switch (segue.identifier!) {
            
        case "CancelUnwindTimingsSequeID":
            print("leaving timingspicker via Cancel")
            return
        default: return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   print("timings picker started with \(whichTile!.tyleBpm)")
//        let vv = CGRect(x:0,y:90,
//            width:self.view.frame.width,height:IOSConstants.tileSize.height)
//        
//        self.dualView = DualView(frame:vv)
//        self.dualView.loadFrom(whichTile!)
//        self.view.addSubview(self.dualView)
        
        
        initialPickerSetup = pickerSetup // save the incoming
        
        allbpmvec  = pickervalues(40,high:300)
        allnumvec = pickervalues(2,high:12)
        alldenvec = pickervalues(2, high: 13)
        
        // delegates must get set before calls to selectRow
        pickerView.dataSource = self
        pickerView.delegate = self
        reloadUI()
    }
    
}

extension TimingsPickerViewController {
    
}
