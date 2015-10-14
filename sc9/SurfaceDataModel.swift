//
//  StoriesModel.swift
//  stories
//
//  Created by william donner on 6/30/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

let kNameForSurfaceUpdated = "kNameForSurfaceUpdatedSignal"



public protocol Singleton {
    
    // used as marker that class is a singleton and has a shared variable ala
    // class var shared: X {
    //	 struct Singleton {
    //	 static let sharedAppConfiguration = X()
    //	}
    //	return Singleton.sharedAppConfiguration
    // }
    
}
struct IOSConstants {
    /// real constants
    static let landscapeNavbarHeight = CGFloat(32)
    static let portraitNavbarHeight = CGFloat(44)
    static let tileStandardHeight = CGFloat(124)
    static let tilePreviewHeight = CGFloat(180)
    static let tileHWRatio = CGFloat(1.2)
    static let sectionHeaderLabelHeight = CGFloat(50)
    
    
    static let tileSize = CGSize(width: IOSConstants.tilePreviewHeight/IOSConstants.tileHWRatio,
        height: IOSConstants.tilePreviewHeight)
    
}
enum TyleEditorTags : Int  {
    case None = 0
    case UrlField
    case frontTextView
    case KeyField
    case BpmField
    case TextColorButton
    case BackgroundColorButton
    case NotesTextView
}
class XSectionHeader {
    
    let title:String
    var enabled:Bool
    // let headerfunc: headerclofunc
    
    init(title:String,enabled:Bool) {
        self.title = title
        self.enabled = enabled
        // self.headerfunc = headerfunc
    }
}

//struct Story {
//    let storyID: Int
//    let name:String
//    let storyboardName:String
//    let storyboardID:String
//    let frontColor:UIColor
//    let backColor:UIColor
//    let loadsWatch:Bool
//    
//    init (name:String,storyboardName:String,storyboardID:String,frontColor:UIColor,backColor:UIColor,loadsWatch:Bool )
//    {
//        self.name = name
//        self.storyboardID = storyboardID
//        self.storyboardName = storyboardName
//        self.frontColor = frontColor
//        self.backColor = backColor
//    //    self.storyID = Globals.shared.sequentialStoryID++ //generate id
//        self.loadsWatch = loadsWatch
//    }
//    init (name:String,storyboardName:String,storyboardID:String) {
//        self.init(name:name,storyboardName:storyboardName,storyboardID:storyboardID,frontColor:UIColor.whiteColor(),
//            backColor:UIColor.blackColor(),loadsWatch:true)
//    }
//}

let currentversion = "0.1.5"



typealias fieldfunc = (status:Bool,s:String?)->()
// MARK: - Model


class SurfaceDataModel {
   // var stories: StoryModel
    var data: BoardModel
    var headers: [HeaderType]
    
    
    
    class func restoreDataModel() { // no ui run in background
        Recents.shared.restore()
        Addeds.shared.restore()
        Corpus.shared.reload()
        Globals.shared.theModel = SurfaceDataModel.smallestModel() // start with something and reload into that
        if  !Globals.shared.theModel.reload() {// no ui
            // if no model to reload then load pre-built one
            Globals.shared.theModel =  SurfaceDataModel.dataModel()
            // now save so we have something
            //Globals.shared.theModel.save()
        }
        
        Globals.shared.theModel.save()
    }
    

    
    
    init(data:BoardModel, headers:[HeaderType]) {
        //self.stories = stories
        self.headers = headers
        self.data = data
    }
    
    func boardSpec () -> String {
        return  FS.shared.SurfacePlist
    }
    func  storiesSpec () -> String {
        return  FS.shared.StoriesPlist
    }
    
    func save() {
        var enabledRowIndex = -1
       // var enabledRowName: String?
        let elapsedTime = timedClosure("saving"){
            var list :[[ExternalTile]] = []
            var theaders: [HeaderType] = []
            
            let tales = NSMutableDictionary()
            tales.setObject(currentversion as NSString, forKey: "version")
//            for (key,story) in self.stories { // Dictionary<String,Story>
//                tales.setObject(makeExternalStoryFromStory(story), forKey: key)
//            }
            // rows
            for row in self.data {
                var thisrowlist:[ExternalTile] = []
                for each in row {
                    thisrowlist.append (Tyle.makeExternalTileFromTyle(each.1))
                }
                list.append(thisrowlist)
            }
            //headers
            var idx = 0
            for header in self.headers {
                if (header["enabled"] != nil) { enabledRowIndex = idx } // get las enabled for now
                let x = (header["enabled"] != nil) ? "1":"0"
                let h = ["title":header["title"]!,"enabled":x]
                theaders.append(h)
                idx++
            }
            var d : Dictionary<String,NSObject> = [:]
            d ["version"] = currentversion as NSString
            d ["sections"] = theaders
            d ["items"] = list
            (d as NSDictionary).writeToFile(self.boardSpec(), atomically: true)
            
            //stories
            (tales as NSDictionary).writeToFile(self.storiesSpec(), atomically: true)
            
            // write a slice of it all to user defaults
            if enabledRowIndex >= 0 {
                let h = self.headers[enabledRowIndex]
                if  let name = h["title"] {
                let rodata = self.data[enabledRowIndex]
                var thisrowlist:[ExternalTile] = []
                for each in rodata {
                    thisrowlist.append (Tyle.makeExternalTileFromTyle(each.1))
                }
                    InterAppCommunications.save(name,items:thisrowlist)
                }
                
            }
      
            
        
        }// end of timed closure
        print ("saved Surface \(Int(elapsedTime))ms")
        // announce what we have done
        
        NSNotificationCenter.defaultCenter().postNotificationName(kNameForSurfaceUpdated,object:nil)
        
    }
    
    func reload(/*vc:StoriesViewController*/) -> Bool {
        
        var sections: [HeaderType] = []
   //     var lstories: [String:Story] = [:]
        
        // check version

        
        // stories
        if  let stories = NSDictionary(contentsOfFile: storiesSpec()){
            
            for (key,value) in stories  { // this is an NSDictionary
                if key as! String == "version" {
                    let v = value as? String ?? ""
                    guard v == currentversion  else {
                        fatalError("Version Mismatch for Stories Data should be \(currentversion) not \(v)")
                    }
                }
//                if value is ExternalTile { // exclude version string key
//                    let o = value as? ExternalTile
//                    //lstories[key as! String] = makeStoryFromExternalStory(o!)
//                }
            }
            //self.stories = lstories
        }
        else { return false} // stories and sections
        if let dict  = NSDictionary(contentsOfFile: boardSpec()) {
            let v = dict["version"] as? String ?? ""
             guard v == currentversion else {
                fatalError("Version Mismatch for Surface Data should be \(currentversion) not \(v)")
            }
            //  headers
            if   let headers = dict ["sections"] as? NSArray {
                for he in headers {
                    let h = he as! HeaderType
//                    let tit = h["title"] as String?
//                    let ena = (h["enabled"]! as String) != "0"
//                    let sh =  SectionHeader( title:tit!,
//                        enabled:ena
//                    )
                    sections.append( h)
                }
            }  else { return false}
            
            var ldata :BoardModel = [] // build new map
            if let list  = dict ["items"] as? NSArray {
           
                for each in list {
                         var theRow:BoardData = []
                    let oo = each as! [ExternalTile]
                    for o in oo {
                        
                        let t = Tyle.makeTyleFromExternalTile(o)
                        
                        theRow.append(([:],t))
                    }// in oo
                    ldata.append(theRow)
                }
                
                self.headers = sections
                self.data = ldata
                
                return true
            } // end of items
        }// end if let dict
        return false
    }

    class func smallestModel() -> SurfaceDataModel {
        let bd: BoardModel = []
        //let stories: StoryModel = [:]
        let headers : [HeaderType] = []
        return SurfaceDataModel(    data:bd, headers: headers)
    }
    
    class func dataModel() -> SurfaceDataModel {
        
//                let editor_colors = [UIColor.whiteColor(),UIColor.blackColor()]
//                let help_colors = [UIColor.whiteColor(),UIColor.darkGrayColor()]
//                let weburl_colors = [UIColor.whiteColor(),UIColor.grayColor()]
//                let song_colors = [UIColor.whiteColor(),UIColor.clearColor()]
        
                // these functions start in a storyboard
//                let story_import = Story(name: "iTunes Import", storyboardName: "Main", storyboardID: "iTunesImportID",frontColor:editor_colors[0],backColor:editor_colors[1],loadsWatch:false)
//        
//                let story_zero = Story(name: "Edit Settings", storyboardName: "Main", storyboardID: "AppSettingsID",frontColor:editor_colors[0],backColor:editor_colors[1],loadsWatch:false)
//                let story_one = Story(name: "Edit Surface", storyboardName: "boarda", storyboardID: "ida",frontColor:editor_colors[0],backColor:editor_colors[1],loadsWatch:false)
//                let story_two = Story(name: "Edit Stories", storyboardName: "boarda", storyboardID: "idb",frontColor:editor_colors[0],backColor:editor_colors[1],loadsWatch:false)
//                // these are builtin - they ae special caseda by the dispatcher
//                let story_three = Story(name: "Show Song", storyboardName: "", storyboardID: "",frontColor:song_colors[0],backColor:song_colors[1],loadsWatch:true)
//                let story_four = Story(name: "Show WebURL", storyboardName: "", storyboardID: "",frontColor:weburl_colors[0],backColor:weburl_colors[1],loadsWatch:false)
//                let story_five = Story(name: "Show Help", storyboardName: "", storyboardID: "",frontColor:help_colors[0],backColor:help_colors[1],loadsWatch:true)
//                let story_makeTile = Story(name: "New Tile", storyboardName: "", storyboardID: "",frontColor:editor_colors[0],backColor:editor_colors[1],loadsWatch:false)
//        
//                let story_sendToWatch = Story(name: "Send To Watch", storyboardName:"Main", storyboardID: "SendRowsToWatchTableViewControllerID",frontColor:editor_colors[0],backColor:editor_colors[1],loadsWatch:false)
//                let story_sendToToday = Story(name: "Send To Today", storyboardName: "Main", storyboardID: "SendRowsToTodayTableViewControllerID",frontColor:editor_colors[0],backColor:editor_colors[1],loadsWatch:false)
//        
//                // coalesce all the stories into a dictionary indexed by name
//                let storee = [story_makeTile,story_sendToWatch,story_sendToToday, story_import,story_zero,story_one,story_two,story_three,story_four,story_five]
//        var stories: StoryModel = [:]
//        for story in storee { stories[story.name] = story }
    
        
        let bd :BoardModel = []
        
        let headers:[HeaderType] = []
        
        return SurfaceDataModel(data:bd , headers: headers)
    }
}