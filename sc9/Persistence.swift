

import UIKit

/// keeps small persistent values in NSUserDefaults

class Persistence {
    struct Config {
        static let colorSchemeKey = "chameleonBaseColorKey"
        static let corpusKey = "resetCorpusNextRestartKey"
        static let surfaceKey = "resetSurfaceNextRestartKey"
        static let touchIDKey = "touchIDKey"
        static let modeKey = "performanceModeKey"
        static let ornamentationKey = "ornamentationKey"
    }
    
    class var resetCorpusNextRestart : String? {
        get {return NSUserDefaults.standardUserDefaults().stringForKey(Config.corpusKey)}
        set {NSUserDefaults.standardUserDefaults().setValue(newValue, forKey:Config.corpusKey)}
    }
    
    class var resetSurfaceNextRestart : String? {
        get {return NSUserDefaults.standardUserDefaults().stringForKey(Config.surfaceKey)}
        set {NSUserDefaults.standardUserDefaults().setValue(newValue, forKey:Config.surfaceKey)}
    }
    class var useTouchID: String? {
        get {return NSUserDefaults.standardUserDefaults().stringForKey(Config.touchIDKey)}
        set {NSUserDefaults.standardUserDefaults().setValue(newValue, forKey:Config.touchIDKey)}
    }
    class var performanceMode: String? {
        get {return NSUserDefaults.standardUserDefaults().stringForKey(Config.modeKey)}
        set {NSUserDefaults.standardUserDefaults().setValue(newValue, forKey:Config.modeKey)}
    }
    class var ornamentationStyle: String? {
        get {return NSUserDefaults.standardUserDefaults().stringForKey(Config.ornamentationKey)}
        set {NSUserDefaults.standardUserDefaults().setValue(newValue, forKey:Config.ornamentationKey)}
    }
    class var colorScheme: String? {
        get {return NSUserDefaults.standardUserDefaults().stringForKey(Config.colorSchemeKey)}
        set {NSUserDefaults.standardUserDefaults().setValue(newValue, forKey:Config.colorSchemeKey)}
    }
    
    class  func processRestartParams() {
        Versions().versionCheck()
        if Persistence.resetSurfaceNextRestart?.characters.count > 0
        { print ("Deleting Surface as per NSUserDefaults")
            do {
                try NSFileManager.defaultManager().removeItemAtPath(FS.shared.SurfacePlist)
            } catch  _ as NSError {
                //error = error1
                print ("error deleting surface plist")
            }
            Persistence.resetSurfaceNextRestart = ""
        }
        if Persistence.resetCorpusNextRestart?.characters.count > 0
        { print ("Deleting Corpus as per NSUserDefaults")
            do {
                try NSFileManager.defaultManager().removeItemAtPath(FS.shared.CorpusPlist)
            } catch  _ as NSError {
                //error = error1
                print ("error deleting corpus plist")
            }
            do {
                try NSFileManager.defaultManager().removeItemAtPath(FS.shared.CorpusDirectory)
            } catch  _ as NSError {
                print ("error deleting corpus")
            }
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(FS.shared.RecentsPlist)} catch  _ as NSError {
                    print ("error deleting RecentsPlist")
            }
            
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(FS.shared.AddedsPlist)
                
            } catch  _ as NSError {
                print ("error deleting AddedsPlist")
            }
            Persistence.resetCorpusNextRestart = ""
        }
    }
}