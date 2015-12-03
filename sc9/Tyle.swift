//
//  Tyle.swift
//  stories
//
//  Created by bill donner on 7/9/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
enum TyleError:ErrorType {
    case GeneralFailure
    case RestoreFailure
}

enum TyleType {
    case DocPresentor
    case URLPresentor
    case Spacer
}

// MARK: - Tyle internal representation

class Tyle {
    var tyleType : TyleType = .DocPresentor
    var tyleID: Int
    var tyleNote: String = ""
    var tyleUrl: String = ""
    var tyleBpm: String = ""
    var tyleDoc: String = ""
    var tyleKey: String = ""
    var tyleTitle: String = ""
    var tyleTextColor: UIColor  = UIColor.whiteColor()
    var tyleBackColor: UIColor  = UIColor.blackColor()

    // TODO: a change to any field will cause a change to all
   func refresh() {
        Globals.saveDataModel ()
    }

    init(label:String, bpm:String,key:String,docPath:String,url:String, note:String, textColor:UIColor,backColor:UIColor) {
            self.tyleID = Globals.shared.sequentialTyleID++ //generate id
            self.tyleTitle = label
            self.tyleBpm = bpm
            self.tyleKey = key
            self.tyleUrl = url
            self.tyleDoc = docPath
            self.tyleBackColor = backColor
            self.tyleTextColor = textColor
            self.tyleNote = note
    }
    

    
    class func makeNewTile(section:String) -> Tyle {
        
        let name = "tile \(Globals.shared.sequentialTyleID)"
        let note = "note \(Globals.shared.sequentialTyleID)"
        let tyle =  Tyle(label: name, bpm: "", key: "", docPath: "", url: "", note: note,
            textColor: UIColor.whiteColor(), backColor: UIColor.blackColor())
        // match section against headers   
 //       }
        return tyle
    }
 
    /// External Tiles are used for communicating with watch and today extensions
    
    class func makeExternalTileFromTyle(t:Tyle)->ExternalTile {
        var o = ExternalTile()
        o[K_ExTile_Label] = t.tyleTitle
        o[K_ExTile_Key] = t.tyleKey
        o[K_ExTile_Bpm] = t.tyleBpm
        o[K_ExTile_Note] = t.tyleNote
        o[K_ExTile_Url] = t.tyleUrl
        o[K_ExTile_Doc] = t.tyleDoc
        o[K_ExTile_ID] = "\(t.tyleID)"
        o[K_ExTile_Textcolor] = t.tyleTextColor.htmlRGBColor
        o[K_ExTile_Backcolor] = t.tyleBackColor.htmlRGBColor
        return o
    }
    
    class func makeTyleFromExternalTile(o:ExternalTile) -> Tyle {
        //print(o[K_ExTile_Textcolor]! + "|" + o[K_ExTile_Backcolor]!)
        let t = Tyle( label: o[K_ExTile_Label]!, bpm: o[K_ExTile_Bpm]!, key:  o[K_ExTile_Key]!,
            docPath: o[K_ExTile_Doc]!, url: o[K_ExTile_Url]!, note: o[K_ExTile_Note]!,
            textColor:o[K_ExTile_Textcolor]!.hexStringToUIColor,
            backColor:o[K_ExTile_Backcolor]!.hexStringToUIColor)
        return t
    }

}// struct Tyle
