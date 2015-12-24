//
//  ModelData.swift

//  Created by william donner on 9/29/15.

import UIKit


typealias   BoardData = [Tyle]
typealias   BoardModel = [[Tyle]]

// MARK: - global storage
final class Globals {
    
    static let UserActivityType = "com.billdonner.useractivity.song"
    
    class var shared: Globals {
        struct Singleton {
            static let sharedAppConfiguration = Globals()
        }
        return Singleton.sharedAppConfiguration
    }
    var mainColors = NSArray() // from Chameleon
    
    var matcoll: Sideinfo?  // used by allDocsVC, cached here
    var incoming: [SortEntry]?  // used by allDocsVC, cached here

    
    var sequentialStoryID = 1000 // global
    var sequentialTyleID = 20000 // global
    //    var theModel:SurfaceDataModel!
    //var processPool: WKProcessPool = WKProcessPool() // enables sharing of cookies across wkwebviews
    var openedByActivity: Bool = false 
    var openURLOptions: [String : AnyObject] = [:]
    var launchOptions : [NSObject: AnyObject]? = nil
    
    var segueargs : [String:AnyObject] = [:]
    var userAuthenticated = false
    var restored = false
    class func cacheLoad() {
        // these are cached - invalidated when content is added or deleted
        if Globals.shared.incoming == nil {
            Globals.shared.incoming = Corpus.uniques(Corpus.sorted())
        }
        if Globals.shared.matcoll == nil {
            Globals.shared.matcoll = CollationSupport.matrixOfIndexes(&Globals.shared.incoming!)
        }//
    }
    
    class   func reloadModel(/*vc:StoriesViewController*/) -> Bool {
        
        var sections: [SectionHeaderProperties] = []
        
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
                    let h = he as! SectionHeaderProperties
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
                       
                        theRow.append(t)
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
    
    class func restoreDataModel() { // no ui run in background
        Recents.shared.restore()
        Addeds.shared.restore()
        Corpus.shared.reload()
        
        reloadModel () // local class func
        
        saveDataModel()
    }
    class func saveDataModel() { 
        var enabledRowIndex = -1
        var tilerowcount = 0
        var headercount = 0
        
        // var enabledRowName: String?
        let elapsedTime = timedClosure("saving"){
            var list :[[ExternalTile]] = []
            var theaders: [SectionHeaderProperties] = []
            
            let tales = NSMutableDictionary()
            tales.setObject(currentversion as NSString, forKey: "version")
            if let td = tales as NSDictionary? {
                td.writeToFile(FS.shared.StoriesPlist, atomically: true)
            }
            
            // rows
            for row in Model.data.tiles {
                var thisrowlist:[ExternalTile] = []
                for each in row {
                    thisrowlist.append (Tyle.makeExternalTileFromTyle(each))
                }
                list.append(thisrowlist)
                tilerowcount++
            }
            //headers
            var idx = 0
            for header in Model.data.sectionHeaders {
                if (header["enabled"] != nil) { enabledRowIndex = idx } // get las enabled for now
                let x = (header["enabled"] != nil) ? "1":"0"
                let h = [SectionProperties.NameKey:header[SectionProperties.NameKey]!,"enabled":x]
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
                if  let name = h[SectionProperties.NameKey] {
                    let rodata = Model.data.tiles[enabledRowIndex]
                    var thisrowlist:[ExternalTile] = []
                    for each in rodata {
                        thisrowlist.append (Tyle.makeExternalTileFromTyle(each))
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


// each header is just a simple dictionary of properties
typealias SectionHeaderProperties = [String:String]

struct SectionProperties {
    static let NameKey = "STR"
}
protocol SectionHeaderOps {
    func isEqualHeaderString(s:SectionHeaderProperties,string:String)->Bool
    func makeHeaderFrom(from:String)->SectionHeaderProperties
}
extension SectionHeaderOps {
    func isEqualHeaderString(s:SectionHeaderProperties,string:String)->Bool {
        return  s[SectionProperties.NameKey] == string
    }
    func makeHeaderFrom(from:String)->SectionHeaderProperties{
        var s = SectionHeaderProperties()
        s[SectionProperties.NameKey] = from
        return s
    }
}


final class Model {
    private class var data: Model {
        struct Singleton {
            static let sharedAppConfiguration = Model()
        }
        return Singleton.sharedAppConfiguration
    }
    var tiles = BoardModel()
    var sectionHeaders = [SectionHeaderProperties]()
    
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
protocol ModelData :SectionHeaderOps{
    
    func mswap(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath)
    func mswap2(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath)
    
    func sectionNumFromName(section:String) throws -> Int
    func elementFor(path:NSIndexPath) -> Tyle
        func setElementFor(path:NSIndexPath,el:Tyle)
    func noTiles() -> Bool
   // func sectCount() -> Int
    func sectHeader(i:Int)->SectionHeaderProperties
    func moveSects(from:Int, _ to:Int)
    func deleteSect(i: Int)
   // func makeNewSect(i:Int,hdr:SectionHeaderProperties )
    
  //  func tileInsert(indexPath:NSIndexPath,newElement:Tyle)
    func tileData(indexPath:NSIndexPath)->Tyle
    func tileSection(indexPath:NSIndexPath)->[Tyle]
    func tileRemove(indexPath:NSIndexPath)
    func tileSectionCount() -> Int
    
    func addedsCount()->Int
    func addedsData(i:Int)->CAdded
    
    func recentsCount()->Int
    func recentsData(i:Int)->CRecent
    
    func makeTileAt(indexPath:NSIndexPath,labelled:String)
    func makeHeaderAt(indexPath:NSIndexPath,labelled:String)
    
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
    
    func elementFor(path:NSIndexPath) -> Tyle {
        return Model.data.tiles[path.section][path.item]
    }
    func setElementFor(path:NSIndexPath,el:Tyle) {
        Model.data.tiles[path.section][path.item] = el
    }
    func tileSection(indexPath:NSIndexPath)->[Tyle] {
        return Model.data.tiles[indexPath.section]
    }
    func tileRemove(indexPath:NSIndexPath) {
        Model.data.tiles[indexPath.section].removeAtIndex(indexPath.item)
    }
    private func tileInsert(indexPath:NSIndexPath,newElement:Tyle) {
        print("tileInsert at \(indexPath)")
        Model.data.tiles[indexPath.section].insert(newElement, atIndex: indexPath.item)
    }
    func tileData(indexPath:NSIndexPath)->Tyle {
        return Model.data.tiles[indexPath.section][indexPath.item]
    }

    func sectHeader(i:Int)->SectionHeaderProperties {
        return Model.data.sectionHeaders[i]
    }
    func renameSectHeader(i:Int,headerTitle:String) {
         Model.data.sectionHeaders[i][SectionProperties.NameKey] = headerTitle
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
    private func makeNewSect(i:Int,hdr:SectionHeaderProperties ){
       // print("making section index:\(i)")
        let title = hdr[SectionProperties.NameKey]!
        Model.data.sectionHeaders.insert(self.makeHeaderFrom("\(title)"), atIndex:i )
        Model.data.tiles.insert ([], atIndex:i) //append a new, empty section
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

    
    func sectionNumFromName(section:String) throws -> Int {
        var i = 0
        for hd in Model.data.sectionHeaders {
            if hd["title"] == section { return i }
            i++
        }
        throw TyleError.GeneralFailure
    }
    func makeTileAt(indexPath:NSIndexPath,labelled:String = "newtile") {
        let tyle = Tyle(label: labelled, bpm: "", key: "", docPath: "", url: "", note: "", textColor:Colors.tileTextColor(), backColor:Colors.tileColor() )
        tileInsert(indexPath,newElement:tyle)
    }
    func makeHeaderAt(indexPath:NSIndexPath,labelled:String = "newheader") {
        let hdr = makeHeaderFrom(labelled)
        makeNewSect(indexPath.row,hdr:hdr)
    }
}