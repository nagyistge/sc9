//
//  InterAppCommunications
//  stories
//
//  Created by bill donner on 7/18/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import Foundation
typealias ExternalStory  = Dictionary<String,String>
typealias ExternalTile  = Dictionary<String,String>
typealias ExTilePayload = [ExternalTile]


let SuiteNameForDataModel = "group.com.shovelreadyapps.stories"
enum IACommunications:ErrorType {
    case GeneralFailure
    case RestoreFailure
}
class  InterAppCommunications {
    
    class var shared: InterAppCommunications {
        struct Singleton {
            static let sharedAppConfiguration = InterAppCommunications()
        }
        return Singleton.sharedAppConfiguration
    }
    
    // the data sent to watch or "today" extension
    var version: String = "0.0.2"
    var name: String // typically matches section name
    var items: ExTilePayload // the small tile data
    //
    init() {
        name = ""; items = []
    }
    class func make(name:String ,items:ExTilePayload){
        InterAppCommunications.shared.name = name
        InterAppCommunications.shared.items = items
    }
    
    //put in special NSUserDefaults which can be shared
    class func restore () throws {
        if  let defaults: NSUserDefaults = NSUserDefaults(suiteName: SuiteNameForDataModel)!,
            let name  = (defaults.objectForKey("name") as? String),
            let items = (defaults.objectForKey("items") as? ExTilePayload)
        {
            // version check goes here
            InterAppCommunications.make(name,items:items)
            return
        }
        else {throw IACommunications.RestoreFailure}
    }

    class func save (name:String,items:ExTilePayload) {// aka send to other device/panel
        InterAppCommunications.make(name,items:items)
        let defaults: NSUserDefaults = NSUserDefaults(suiteName:SuiteNameForDataModel)!
        defaults.setObject(  InterAppCommunications.shared.version, forKey: "version")
        defaults.setObject(  name, forKey: "name")
        defaults.setObject(  items, forKey: "items")
    }
    
}
