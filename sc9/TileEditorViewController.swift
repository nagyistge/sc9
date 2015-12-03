//
//  TileEditor.swift
//
//  Created by william donner on 9/23/15.
//

import UIKit
protocol TileEditorDelegate {
    func deleteThisTile(//path:NSIndexPath
    )
    func tileDidUpdate(//path:NSIndexPath,
        name name:String,key:String,bpm:String,textColor:UIColor,backColor:UIColor)
}

class TileEditorViewController: UIViewController,ModelData {
    var delegate:TileEditorDelegate?
    // These must be set by caller
    var tileIdx: NSIndexPath!
    var tileIncoming: TileSequeArgs!
    
    var changedSomething: Bool = false //
    var willSetBackGroundColor = false
    

    
    // unwind to here from subordinate editors, passing back values via custom protocols for each
    
    deinit {
        self.cleanupFontSizeAware(self)
    }
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        //print("Unwound to TileEditorViewController")
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var keyValue: UILabel!
    @IBOutlet weak var bpmValue: UILabel!
    private func updateTile() {
        
        
        
        self.delegate?.tileDidUpdate(//self.tileIdx!,
            name:self.textView.text  ,key:keyValue.text!,bpm:bpmValue.text!,textColor:self.textView.textColor!,backColor:self.textView.backgroundColor!)
    }
    @IBAction func donePressed(sender: AnyObject) {
     
        updateTile()
          self.unwindFromHere(self)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    // MARK: - deleting the tile requires confirmation takes us back
    
    @IBAction func trashThisTile(sender: AnyObject) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Delete this tile \(tileIncoming.name) ?", message: "Can not be undone", preferredStyle: .Alert)
        //
        //	//Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //		  Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        actionSheetController.addAction(UIAlertAction(title: "Delete This Tile", style: .Destructive) { action -> Void in
            self.delegate?.deleteThisTile()
            self.unwindFromHere(self)
            })
        //  We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = sender as? UIView;
        
        //  Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    // MARK: - Lifecycle


    override func viewDidLoad() {
        super.viewDidLoad()
        // if the fontsize changes refresh everthing
        self.setupFontSizeAware(self)
        self.navigationItem.title = self.tileIncoming.name ?? "mizzing"
        self.textView.delegate = self
        
        keyValue.text = self.tileIncoming.key
        bpmValue.text = self.tileIncoming.bpm
        textView.text = self.tileIncoming.name
        textView.backgroundColor = self.tileIncoming.backColor
        textView.textColor = self.tileIncoming.textColor

    }
}

extension TileEditorViewController: UITextViewDelegate {
    func doneWithKeyboard() {
        self.textView.resignFirstResponder()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "donePressed:")
    }
    func textViewDidBeginEditing(textView: UITextView) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneWithKeyboard")
    }
    
    func textViewDidChange(textView: UITextView) {
        changedSomething = true // just give it a shot
       //updateTile()
    }
}

// invocation of editors vector thru here
extension TileEditorViewController: SegueHelpers {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let uiv = segue.destinationViewController as? TextForegroundColorPickerViewController {
            uiv.delegate = self
            self.willSetBackGroundColor = false
        }
        if let uiv = segue.destinationViewController as? TextBackgroundColorPickerViewController {
            uiv.delegate = self
            self.willSetBackGroundColor = true
        }
        if let uiv = segue.destinationViewController as? KeyPickerViewController {
            uiv.delegate = self
            uiv.pickerSetup = " "
        }
        if let uiv = segue.destinationViewController as? TimingsPickerViewController {
            uiv.delegate = self
            uiv.pickerSetup = " "
        }
    }
}

extension TileEditorViewController: SubEditorDelegate {
    func returningResults(data:String){
        print("SubEditor returned ",data)
    }
}
extension TileEditorViewController : FontSizeAware {
    func refreshFontSizeAware(vc:TileEditorViewController) {
        vc.view.setNeedsDisplay()
    }
}

// MARK: Color Picker Delegate
extension TileEditorViewController:SwiftColorPickerDelegate {
    func colorSelectionChanged(selectedColor color: UIColor) {
        if self.willSetBackGroundColor {
            self.textView.backgroundColor = color
        } else {
            self.textView.textColor = color
        }
        self.textView.setNeedsDisplay()
        //updateTile()
    }
}
extension TileEditorViewController:KeyPickerViewControllerDelegate {
    func keySelectionChanged(selectedKey   key: [String]) {
        self.keyValue.text = key[0]+" "+key[1]+" "+key[2]
        self.keyValue.setNeedsDisplay()
       // updateTile()
    }
}
extension TileEditorViewController:TimingsPickerViewControllerDelegate
{
    func timingsSelectionChanged(selectedTimings   timings: [String]) {
        self.bpmValue.text = timings[0] + " " + timings[1] + " " + timings[2]
        self.bpmValue.setNeedsDisplay()
       //updateTile()
    }
}
