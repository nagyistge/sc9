//
//  ModelData.swift

//  Created by william donner on 9/29/15.

import UIKit

// non persistent data is in globals

// MARK: - global storage
final class Globals {
    
    static let UserActivityType = "com.billdonner.useractivity.song"
    
    class var shared: Globals {
        struct Singleton {
            static let sharedAppConfiguration = Globals()
        }
        return Singleton.sharedAppConfiguration
    }
    
    var sequentialStoryID = 1000 // global
    var sequentialTyleID = 20000 // global
    //    var theModel:SurfaceDataModel!
    //var processPool: WKProcessPool = WKProcessPool() // enables sharing of cookies across wkwebviews
    var openURLOptions: [String : AnyObject] = [:]
    var launchOptions : [NSObject: AnyObject]? = nil
    
    var segueargs : [String:AnyObject] = [:]
    var userAuthenticated = false
    var restored = false
    //var splitViewController: UISplitViewController! // filled in by AppDelegate
    
    
    // cache the documentChooser controller
    
    var chooseDocTableViewController : ChooseDocTableViewController?
    func chooseDocVC () -> ChooseDocTableViewController {
        if chooseDocTableViewController == nil {
            chooseDocTableViewController = UIStoryboard(name:"Main",bundle:nil).instantiateViewControllerWithIdentifier("ChooseDocTableViewControllerID") as? ChooseDocTableViewController
        }
        return chooseDocTableViewController!
    }
    
    
    
    class   func reloadModel(/*vc:StoriesViewController*/) -> Bool {
        
        var sections: [HeaderType] = []
        
        // check version
        
        // stories
        if  let stories = NSDictionary(contentsOfFile: FS.shared.StoriesPlist){
            for (key,value) in stories  { // this is an NSDictionary
                if key as! String == "version" {
                    let v = value as? String ?? ""
                    guard v == currentversion  else {
                        fatalError("Version Mismatch for Stories Data should be \(currentversion) not \(v)")
                    }
                }
            }
        }
        else { return false} // stories and sections
        if let dict  = NSDictionary(contentsOfFile: FS.shared.SurfacePlist) {
            let v = dict["version"] as? String ?? ""
            guard v == currentversion else {
                fatalError("Version Mismatch for Surface Data should be \(currentversion) not \(v)")
            }
            //  headers
            if   let headers = dict ["sections"] as? NSArray {
                for he in headers {
                    let h = he as! HeaderType
                    sections.append( h)
                }
            }  else { return false}
            
            var ldata :BoardModel = [] // build new map
            if let list  = dict ["items"] as? NSArray {
                
                for each in list {
                    var theRow:BoardData = []
                    let oo = each as! [ExternalTile]
                    for o in oo {
                        if o[K_ExTile_Label] != "+" {
                        let t = Tyle.makeTyleFromExternalTile(o)
                       
                        theRow.append(([ElementProperties.NameKey:t.tyleTitle],t))
                        }
                    }// in oo
                    ldata.append(theRow)
                }
                Model.data.sectionHeaders = sections
                Model.data.tiles = ldata
                return true
            } // end of items
        }// end if let dict
        return false
    }
    
    //    class func smallestModel() -> SurfaceDataModel {
    //        let bd: BoardModel = []
    //        //let stories: StoryModel = [:]
    //        let headers : [HeaderType] = []
    //        return SurfaceDataModel(    data:bd, headers: headers)
    //    }
    
    //    class func dataModel() -> SurfaceDataModel {
    //        let bd :BoardModel = []
    //        let headers:[HeaderType] = []
    //        return SurfaceDataModel(data:bd , headers: headers)
    //    }
    
    
    class func restoreDataModel() { // no ui run in background
        Recents.shared.restore()
        Addeds.shared.restore()
        Corpus.shared.reload()
        
        reloadModel () // local class func
        
        //        Globals.shared.theModel = SurfaceDataModel.smallestModel() // start with something and reload into that
        //        if  !Globals.shared.theModel.reload() {// no ui
        //            // if no model to reload then load pre-built one
        //            Globals.shared.theModel =  SurfaceDataModel.dataModel()
        //            // now save so we have something
        //            //Globals.shared.theModel.save()
        //        }
        
        saveDataModel()
    }
    class func saveDataModel() {
       // print("saveDataModel  \(Model.data.sectionHeaders.count) headers \(Model.data.tiles.count) rows")
        var enabledRowIndex = -1
        var tilerowcount = 0
        var headercount = 0
        
        // var enabledRowName: String?
        let elapsedTime = timedClosure("saving"){
            var list :[[ExternalTile]] = []
            var theaders: [HeaderType] = []
            
            let tales = NSMutableDictionary()
            tales.setObject(currentversion as NSString, forKey: "version")
            if let td = tales as NSDictionary? {
                td.writeToFile(FS.shared.StoriesPlist, atomically: true)
            }
            
            // rows
            for row in Model.data.tiles {
                var thisrowlist:[ExternalTile] = []
                for each in row {
                    thisrowlist.append (Tyle.makeExternalTileFromTyle(each.1))
                }
                list.append(thisrowlist)
                tilerowcount++
            }
            //headers
            var idx = 0
            for header in Model.data.sectionHeaders {
                if (header["enabled"] != nil) { enabledRowIndex = idx } // get las enabled for now
                let x = (header["enabled"] != nil) ? "1":"0"
                let h = ["STR":header["STR"]!,"enabled":x]
                theaders.append(h)
                headercount++
                idx++
            }
            var d : Dictionary<String,NSObject> = [:]
            d ["version"] = currentversion as NSString
            d ["sections"] = theaders
            d ["items"] = list
            if  let dd  = d as NSDictionary? {
                dd.writeToFile(FS.shared.SurfacePlist, atomically: true)
            }
            // write a slice of it all to user defaults
            if enabledRowIndex >= 0 {
                let h = Model.data.sectionHeaders[enabledRowIndex]
                if  let name = h[ElementProperties.NameKey] {
                    let rodata = Model.data.tiles[enabledRowIndex]
                    var thisrowlist:[ExternalTile] = []
                    for each in rodata {
                        thisrowlist.append (Tyle.makeExternalTileFromTyle(each.1))
                    }
                    InterAppCommunications.save(name,items:thisrowlist)
                }
            }
        }// end of timed closure
        print ("saved Surface \(Int(elapsedTime))ms rows \(tilerowcount) headers \(headercount)")
        // announce what we have done
        NSNotificationCenter.defaultCenter().postNotificationName(kSurfaceUpdatedSignal,object:nil)
    }
}


// each tile is just a simple dictionary of properties and a Tyle
//TODO: - factor all this back into Tyle
typealias ElementType = ([String:String],Tyle)

struct ElementProperties {
    static let NameKey = "STR"
}

protocol ElementTypeAccess {
    func isEqualElementString(s:ElementType,string:String)->Bool
    func makeElementFrom(from:String)->ElementType
}
extension ElementTypeAccess {
    func isEqualElementString(s:ElementType,string:String)->Bool {
        let t = s.0
        return t [ElementProperties.NameKey] == string
    }
    func makeElementFrom(from:String)->ElementType {
        let tyle = Tyle(label: from, bpm: "", key: "", docPath: "", url: "", note: "", textColor: UIColor.greenColor(), backColor: UIColor.redColor())
        
        var s = ElementType([:],tyle)
        
        s.0[ElementProperties.NameKey] = from
        s.1 = tyle
        return s
    }
}
// each header is just a simple dictionary of properties
typealias HeaderType = [String:String]

protocol HeaderTypeAccess {
    func isEqualHeaderString(s:HeaderType,string:String)->Bool
    func makeHeaderFrom(from:String)->HeaderType
}
extension HeaderTypeAccess {
    func isEqualHeaderString(s:HeaderType,string:String)->Bool {
        return  s[ElementProperties.NameKey] == string
    }
    func makeHeaderFrom(from:String)->HeaderType{
        var s = HeaderType()
        s[ElementProperties.NameKey] = from
        return s
    }
}
//typealias StoryModel = Dictionary<String,Story>
typealias   BoardData = [ElementType]
typealias   BoardModel = [[ElementType]]


final class Model {
    private class var data: Model {
        struct Singleton {
            static let sharedAppConfiguration = Model()
        }
        return Singleton.sharedAppConfiguration
    }
    var tiles = BoardModel()
    var sectionHeaders = [HeaderType]()
    
    
    func describe() {
        if tiles.count > 0 {
            
            print  ("Model is ", tiles.count, " rows with ",tiles[0].count," elements in 1st row")
            
            for j in 0..<Model.data.tiles.count  {
                print("\n\(j):")
                for k in 0..<Model.data.tiles[j].count {
                
                        print (" \(Model.data.tiles[j][k]) ")
                    }
                }
            
        }
        else {
            print("Model has no tiles")
        }
        if Corpus.shared.hascontent() == false  {
            print ("Corpus has no files")
        }
    }
}
protocol ModelData :ElementTypeAccess,HeaderTypeAccess{
    
    func addLastSpecialElements()
    func removeLastSpecialElements()
    func mswap(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath)
    func mswap2(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath)
    
    func sectionNumFromName(section:String) throws -> Int
    func elementFor(path:NSIndexPath) -> ElementType
        func setElementFor(path:NSIndexPath,el:ElementType)
    func noTiles() -> Bool
    func sectCount() -> Int
    func sectHeader(i:Int)->HeaderType
    func moveSects(from:Int, _ to:Int)
    func deleteSect(i: Int)
    func makeNewSect(i:Int,hdr:HeaderType )
    
    func tileInsert(indexPath:NSIndexPath,newElement:ElementType)
    func tileData(indexPath:NSIndexPath)->ElementType
    func tileSection(indexPath:NSIndexPath)->[ElementType]
    func tileRemove(indexPath:NSIndexPath)
    func tileSectionCount() -> Int
    
    func addedsCount()->Int
    func addedsData(i:Int)->CAdded
    
    func recentsCount()->Int
    func recentsData(i:Int)->CRecent
    
}

extension ModelData {
    ////
    
    func addedsCount()->Int {
        return Addeds.shared.gAddeds.count
    }
    func addedsData(i:Int)-> CAdded {
        return Addeds.shared.gAddeds[i]
    }
    func recentsCount()->Int {
        return Recents.shared.gRecents.count
    }
    func recentsData(i:Int)->CRecent {
        return Recents.shared.gRecents[i]
    }
    func sectCount() -> Int {
        return Model.data.sectionHeaders.count
    }
    func tileSectionCount() -> Int { // should be the same as above
        return Model.data.tiles.count
    }
    func tileCountInSection(i:Int) -> Int {
        return Model.data.tiles[i].count
    }
    func noTiles() -> Bool {
        return Model.data.tiles.count == 0
        
    }
    
    func elementFor(path:NSIndexPath) -> ElementType {
        
        return Model.data.tiles[path.section][path.item]
        
    }
    func setElementFor(path:NSIndexPath,el:ElementType) {
        Model.data.tiles[path.section][path.item] = el
    }
    func tileSection(indexPath:NSIndexPath)->[ElementType] {
        return Model.data.tiles[indexPath.section]
    }
    func tileRemove(indexPath:NSIndexPath) {
        Model.data.tiles[indexPath.section].removeAtIndex(indexPath.item)
    }
    func tileInsert(indexPath:NSIndexPath,newElement:ElementType) {
        Model.data.tiles[indexPath.section].insert(newElement, atIndex: indexPath.item)
    }
    func tileData(indexPath:NSIndexPath)->ElementType {
        return Model.data.tiles[indexPath.section][indexPath.item]
    }
    
    func sectHeader(i:Int)->HeaderType {
        return Model.data.sectionHeaders[i ]
    }
    func moveSects(from:Int, _ to:Int){
        let t = Model.data.tiles [from]
        Model.data.tiles.insert(t,atIndex:to)
        
        let  h = Model.data.sectionHeaders [from]
        Model.data.sectionHeaders.insert(h,atIndex:to)
    }
    func deleteSect(i: Int){
        Model.data.sectionHeaders.removeAtIndex(i)
        Model.data.tiles.removeAtIndex(i)
    }
    func makeNewSect(i:Int,hdr:HeaderType ){
       // print("making section index:\(i)")
        let title = hdr[ElementProperties.NameKey]!
        Model.data.sectionHeaders.insert(self.makeHeaderFrom("sec \(i) @ \(title)"), atIndex:i )
        
        Model.data.tiles.insert ([], atIndex:i) //append a new, empty section
//        let plus: String = "+"
//        let j = i// Model.data.tiles.count - 1 // new index
//        for c in plus.characters {
//            Model.data.tiles[j].append(makeElementFrom(String(c)))
//        }
    }
    func mswap2(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath) {
        let section = Model.data.tiles[sourceIndexPath.section]
        let temp = section[sourceIndexPath.item] // the character
        
        //shrink source array
        
        Model.data.tiles[sourceIndexPath.section].removeAtIndex(sourceIndexPath.item)
        
        //insert in dest array
        Model.data.tiles[destinationIndexPath.section].insert(temp, atIndex: destinationIndexPath.item)
    }
    func mswap(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath) {
        // swap values if source and destination sections are the same
        let temp = Model.data.tiles[sourceIndexPath.section][sourceIndexPath.item]
        Model.data.tiles[sourceIndexPath.section][sourceIndexPath.item] = Model.data.tiles[destinationIndexPath.section][destinationIndexPath.item]
        Model.data.tiles[destinationIndexPath.section][destinationIndexPath.item] = temp
    }
    func addLastSpecialElements() {
        let plus: String = "+"
       // Model.data.describe()
        for j in 0..<Model.data.tiles.count {
            //for c in plus.characters
            Model.data.tiles[j].append(makeElementFrom (plus))
            //}
        }
        
       // Model.data.describe()
    }
    func removeLastSpecialElements() {
        var newtiles = BoardModel()
        for j in 0..<Model.data.tiles.count  {
            newtiles.append([])
            for k in 0..<Model.data.tiles[j].count {
                if isEqualElementString(Model.data.tiles[j][k],string:"+") { //print("stripping plus...")
                }
                else
                {
                    newtiles[j].append(Model.data.tiles[j][k])
                }
            }
        }
        Model.data.tiles = newtiles
    }
    
func sectionNumFromName(section:String) throws -> Int {
        var i = 0
        for hd in Model.data.sectionHeaders {
            if hd["title"] == section { return i }
            i++
        }
        throw TyleError.GeneralFailure
    }
  
}