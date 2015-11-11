//
//  CommonExtensions.swift
//  stories
//
//  Created by bill donner on 7/18/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

// external tiles are stored as small dictionaries
let K_ExTile_Backcolor = "backcolor"
let K_ExTile_Textcolor = "textcolor"
let K_ExTile_ID = "tyleID"
let K_ExTile_Doc = "doc"
let K_ExTile_Url = "url"
let K_ExTile_Note = "note"
let K_ExTile_Key = "key"
let K_ExTile_Bpm = "bpm"
let K_ExTile_Label = "label"

// make one line Label as attributed string
func asTextFor(row:Int,o:ExternalTile) -> NSAttributedString {
    // first style
    
    let key = (o[K_ExTile_Key]?.characters.count > 0) ? "" + (o[K_ExTile_Key]! as String) : ""
    let bpm = (o[K_ExTile_Bpm]?.characters.count > 0) ? "" + (o[K_ExTile_Bpm]! as String) : ""
    let prefix =  String(format:"%02d ",row) //
    let midfix =  key.padding(5) + " " + bpm.padding(5)
    let label = o[K_ExTile_Label] ?? ""
    
    let attributedString = NSMutableAttributedString(string: "\(prefix)\(midfix)\(label)" as String)
    
    // 2 UIFont(name:"Courier-New",size:18.0)
    //, NSUnderlineStyleAttributeName: 1
    let prefixAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor(),NSFontAttributeName: UIFont(name: "Courier New", size: 16)!]
    let labelAttributes  = [NSForegroundColorAttributeName: (o[K_ExTile_Textcolor]! as String).hexStringToUIColor, NSBackgroundColorAttributeName: (o[K_ExTile_Backcolor]! as String).hexStringToUIColor, NSFontAttributeName: UIFont.systemFontOfSize(30)]
    let midfixAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSBackgroundColorAttributeName: UIColor.clearColor(),NSFontAttributeName: UIFont(name: "Courier New", size: 24)!]
    
    // 3
    let prefixRange = NSRange(location: 0,length: prefix.characters.count)
    let midfixRange = NSRange(location: prefix.characters.count,length: midfix.characters.count)
    let labelRange = NSRange(location:   prefix.characters.count + midfix.characters.count,length: label.characters.count)
    
    attributedString.addAttributes(prefixAttributes, range: prefixRange )
    attributedString.addAttributes(midfixAttributes, range: midfixRange)
    attributedString.addAttributes(labelAttributes, range: labelRange)
    
    return attributedString
}



/**
Executes the lefthand closure on a background thread and,
upon completion, the righthand closure on the main thread.
*/
func doThis(
    dothis: () -> (),
    thenThat:() -> ())
{
    
    let _queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)
    
    dispatch_async(_queue) {
        dothis()
        dispatch_async(dispatch_get_main_queue(),{
            thenThat()
        })
    }
}

extension UIColor {
    class func offWhiteColor() -> UIColor {
        return UIColor(red:204/255,green:204/255,blue:204/255,alpha:1.0)
    }
    
    class func scnearblackColor() -> UIColor {
        return UIColor(red:40/255,green:40/255,blue:40/255,alpha:0.3)
    }
    
}
extension UIColor {
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    // hue, saturation, brightness and alpha components from UIColor**
    var hsbComponents:(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue:CGFloat = 0
        var saturation:CGFloat = 0
        var brightness:CGFloat = 0
        var alpha:CGFloat = 0
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha){
            return (hue,saturation,brightness,alpha)
        }
        return (0,0,0,0)
    }
    var htmlRGBColor:String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    var htmlRGBaColor:String {
        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
    }
}

extension String {
    var hexStringToUIColor: UIColor {
        var cString:String = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            let endIndex = cString.startIndex.advancedBy(1)
            cString = cString.substringFromIndex(endIndex)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
}


extension String {
    func padding(fieldLength: Int) -> String {
        let x = self.padding(fieldLength,paddingChar:" ")
        return x
    }
    
    func padding(fieldLength: Int, paddingChar: String) -> String {
        let count = self.characters.count
        if count > fieldLength  {
            
            // let myString = "[ABCDEFGHI]"
             //let startIndex = advance(self.startIndex, 1) //advance as much as you like
            let endIndex = self.endIndex.advancedBy( -(count - fieldLength))
            let range = startIndex..<endIndex
            let myNewString = self.substringWithRange( range )
            
            return myNewString
        }
        var formatedString: String = ""
        formatedString += self
        
        let cnt = fieldLength - count
        if cnt > 0 {
        for _ in 0..<cnt {
            formatedString += paddingChar
        }
        }
        
        return formatedString
    }
} 


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

protocol StashPhotoOps {
    func stashPhoto(image:UIImage)
}
final class PhotoKeeperQueryViewController:
UIViewController {
    
    var theImage:UIImage?
    var stashDelegate:StashPhotoOps?
    
    
    var button: UIButton!
    var button2: UIButton!
    var imageView: UIImageView!
    
    
    func done() {
        // just remove the little overlay
        //		self.imageView?.removeFromSuperview()
        //		self.imageView = nil
        //		self.button.removeFromSuperview()
        //        self.button = nil
        //self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func doneKeep() {
        /// Stash Content in background
        self.stashDelegate?.stashPhoto(theImage!)
        //        let bits =  UIImagePNGRepresentation(theImage)
        //        print("Keeping photo with  bits count ",bits!.length)
        done()
    }
    
    func doneCancel() {
        done()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView = UIImageView(frame:UIScreen.mainScreen().bounds)
        if imageView != nil {
            imageView!.userInteractionEnabled = true
            imageView!.contentMode = .ScaleAspectFill
            imageView!.image = theImage
            self.view.addSubview(imageView!)
            
            
            button = UIButton(frame:CGRect(x:0,y:0,width:80,height:80))
            button.setTitle("cancel", forState: .Normal)
            button.addTarget(nil , action: "doneCancel", forControlEvents: UIControlEvents.TouchUpInside)
            self.imageView!.addSubview(button)
            
            button2 = UIButton(frame:CGRect(x:imageView!.frame.width-80,y:0,width:80,height:80))
            button2.setTitle("use", forState: .Normal)
            button2.addTarget(nil , action: "doneKeep", forControlEvents: UIControlEvents.TouchUpInside)
            self.imageView!.addSubview(button2)
            
            self.view.addSubview(self.imageView!)
        }
    }
}


protocol ExCo {
    func pencode(a:[String])->String
    func pdecode(s:String)->[String]
}
extension ExCo {
    
    func pencode(a:[String])->String {
        func collapse(a:[String],c:String)->String {
            var s = ""
            for aa in a {
                if s != "" { s += c }
                s += aa
            }
            return s
        }
        return collapse(a,c:" ")
    }
    
    func pdecode(s:String)->[String]{
        
        func expand(s:String,c:String)->[String] {
            var a : [String]
            a = (s as NSString).componentsSeparatedByString(c)
            if a.count < 3 { a.append(" ") }
            if a.count < 3 { a.append(" ") }
            return a
        }
        return expand(s,c:" ")}
}