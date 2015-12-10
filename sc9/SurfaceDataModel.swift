//
//  StoriesModel.swift
//  stories
//
//  Created by william donner on 6/30/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

let kSurfaceUpdatedSignal = "kSurfaceUpdatedSignal"
let kSurfaceRestorationCompleteSignal = "kSurfaceRestorationCompleteSignal"


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

let currentversion = "0.1.6"

typealias fieldfunc = (status:Bool,s:String?)->()
// MARK: - Model

class SurfaceDataModel {
    // var stories: StoryModel
    var data: BoardModel
    var headers: [SectionHeaderProperties]

    init(data:BoardModel, headers:[SectionHeaderProperties]) {
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
    
    
    }