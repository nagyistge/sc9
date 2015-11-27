//
//  TileView.swift
//  stories
//
//  Created by bill donner on 7/9/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

// MARK: - TileView is the Face of Tile
protocol TileViewFaceReady {
    
}


/*

| pad | tileView | pad | rearView | pad |

*/


class DualView: UIView {
    let tileView: TileView!
    let rearView: RearTileView
    override init(frame:CGRect){
        let fpad =  frame.width - 2 * (IOSConstants.tileSize.width)
        let pad = fpad / 3
        
        // left side is front
        
        let frL = CGRect(x: pad, y:0, width:IOSConstants.tileSize.width,height:IOSConstants.tileSize.height )
        let innerFrameL = UIEdgeInsetsInsetRect(frL, UIEdgeInsetsMake(1.0, 1.0, 1.0,  1.0))
        tileView = TileView(frame:innerFrameL)
        tileView.frontTextView.tag = TyleEditorTags.frontTextView.rawValue
        
        
        // right side is rear
        
        let frR = CGRect(x: pad + pad + IOSConstants.tileSize.width, y:0, width:IOSConstants.tileSize.width,height:IOSConstants.tileSize.height )
        let innerFrameR = UIEdgeInsetsInsetRect(frR, UIEdgeInsetsMake(1.0, 1.0, 1.0,  1.0))
        rearView = RearTileView(frame:innerFrameR)
        rearView.noteTextView.tag = TyleEditorTags.NotesTextView.rawValue
        
        super.init(frame:frame)
        
        self.addSubview(tileView)
        self.addSubview(rearView)
    }
    
    func loadFrom(tyle:Tyle) {
        self.tileView.loadFromTyle(tyle)
        self.rearView.loadRearFromTyle(tyle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RearTileView: UIView,TileViewFaceReady {
    
    var noteTextView :  UITextView!
    
    func loadRearFromTyle (tyle :Tyle) {
        let v = self
        v.noteTextView.text = tyle.tyleNote
        v.noteTextView.textColor = tyle.tyleTextColor
        v.noteTextView.backgroundColor = tyle.tyleBackColor
        v.backgroundColor = tyle.tyleBackColor
        v.setNeedsDisplay()
        
    }
    func loadRearFromArgs (note:String,textColor:UIColor,backColor:UIColor) {
        // print("The note is \(note)")
        let v = self
        v.noteTextView.text = note
        v.noteTextView.textColor = textColor
        v.noteTextView.backgroundColor = backColor
        v.backgroundColor = backColor
        v.setNeedsDisplay()
    }
    
    // must init to setup the general frame and parts, then call one of the load routines
    override init(frame:CGRect) {
        super.init(frame: frame)
           let xx = CGRect(x:0,y:0,width:frame.width,height:frame.height)
        let innerFrame = UIEdgeInsetsInsetRect(xx,
            UIEdgeInsetsMake(10.0, 15.0, 5.0,  15.0))
        self.noteTextView = UITextView(frame:innerFrame)
        
        //Or do it in code using properties editable, selectable, scrollEnabled
        self.noteTextView.scrollEnabled = false
        self.noteTextView.textAlignment = .Center
        //self.noteTextView.font = AdjustableFonts.fontForTextStyle(UIFontTextStyleHeadline)
        self.noteTextView.backgroundColor = self.backgroundColor
        self.noteTextView.userInteractionEnabled = false
        self.addSubview(noteTextView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class TileView: UIView,TileViewFaceReady {
    
    var frontTextView :  UITextView!
    var keyLabel :  UILabel!
    var bpmLabel :  UILabel!
    
    var tgr: UITapGestureRecognizer?
    var ltgr: UITapGestureRecognizer?
    
    private  func makeTextView(innerFrame:CGRect) -> UITextView {
        let label =  UITextView(frame:innerFrame)
       // label.font = AdjustableFonts.fontForTextStyle(UIFontTextStyleHeadline)
        label.backgroundColor = self.backgroundColor
        label.userInteractionEnabled = false
        return label
    }
    private func makeSingle(innerFrame:CGRect) -> UILabel {
        let label =  UILabel(frame:innerFrame)
        //label.font = AdjustableFonts.fontForTextStyle(UIFontTextStyleCallout)
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor  = self.backgroundColor
        return label
    }
//    private func withStory(story:Story?) {
//        //self.userInteractionEnabled = true
//        var img: UIImage?
//        if story != nil {
//            img =  story!.loadsWatch ?
//                UIImage(named:"Watch Background Gary") : UIImage(named:"iPadSilo")
//        } else
//        {
//            img = UIImage(named:"Watch Background Gary")
//        }
//        let xx = CGRect(x:0,y:0,width:self.frame.width,height:self.frame.height)
//        let innerFrame = UIEdgeInsetsInsetRect(xx, UIEdgeInsetsMake(1.0, 1.0, 1.0,  1.0))
//        let iv = UIImageView(frame: innerFrame)
//        iv.contentMode = UIViewContentMode.ScaleAspectFit
//        iv.image = img
//        self.addSubview(iv)
//    }
    func loadFromTyle (tyle :Tyle) {
        
        let v = self
        v.bpmLabel.text = "\(tyle.tyleBpm)"
        v.keyLabel.text = "\(tyle.tyleKey)"
        v.frontTextView.text = "\(tyle.tyleTitle)"
        
        v.frontTextView.textColor = tyle.tyleTextColor
        v.keyLabel.textColor = tyle.tyleTextColor
        v.bpmLabel.textColor = tyle.tyleTextColor
        
        v.frontTextView.backgroundColor = tyle.tyleBackColor
        v.keyLabel.backgroundColor = tyle.tyleBackColor
        v.bpmLabel.backgroundColor = tyle.tyleBackColor
        v.backgroundColor = tyle.tyleBackColor
        
        v.setNeedsDisplay()
    }
    func loadFromArgs (title:String,bpm:String,key:String,textColor:UIColor,backColor:UIColor) {
        
        let v = self
        v.bpmLabel.text = "\(bpm)"
        v.keyLabel.text = "\(key)"
        v.frontTextView.text = "\(title)"
        
        v.frontTextView.textColor = textColor
        v.keyLabel.textColor = textColor
        v.bpmLabel.textColor = textColor
        
        v.frontTextView.backgroundColor = backColor
        v.keyLabel.backgroundColor = backColor
        v.bpmLabel.backgroundColor = backColor
        v.backgroundColor = backColor 
        v.setNeedsDisplay()
        //withStory(nil)
    }
    
    // must init to setup the general frame and parts, then call one of the load routines
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        /// chop up the watch face 80% on top, then two bottom ornaments/complications on left and right
        
        let iframe =   CGRect(x:0,y:0,width:frame.width,height:frame.height)
        
        let sframe1 = CGRect(x:0,y:0,width:iframe.width,height:iframe.height*0.7)
        let sframe2 = CGRect(x:0,y:sframe1.height, width:iframe.width/2,height:iframe.height*0.3)
        let sframe3 = CGRect(x:iframe.width/2,y:sframe1.height,width:iframe.width/2,height:iframe.height*0.3)
        
        // put the full textView on Bottom
        
        let innerFrame = UIEdgeInsetsInsetRect(sframe1, UIEdgeInsetsMake(10.0, 15.0, 5.0,15.0))
        frontTextView = makeTextView(innerFrame)
        frontTextView.scrollEnabled  = false
        frontTextView.textAlignment = .Center
        self.addSubview(frontTextView)
        
        let keyFrame = UIEdgeInsetsInsetRect(sframe2, UIEdgeInsetsMake(2, 15.0, 20.0, 5.0))
        keyLabel = makeSingle (keyFrame)
        keyLabel.textAlignment = .Left
        self.addSubview(keyLabel)
        
        
        let bpmFrame = UIEdgeInsetsInsetRect(sframe3, UIEdgeInsetsMake(2, 5.0, 20.0, 15.0))
        bpmLabel = makeSingle(bpmFrame)
        bpmLabel.textAlignment = .Right
        self.addSubview(bpmLabel)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
