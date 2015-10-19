//
//  Corpus.swift
//  stories
//
//  Created by william donner on 6/30/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

/// most minimalist system for keeping track of indices
/// - linear search thru a hashtable to find particular titles 
/// - will evenutally replace with coredata or similar

//let currentversion = "0.1.5"
typealias Hkey = String
typealias Hpay = [String]
typealias Htable = [Hkey:Hpay] // md5 is key, ID and Title are elements of hpay

struct SortEntry {
    let title:String
    let md5hash:String
}

let initialDocSeqNum = 333333
@objc class Corpus : NSObject, CSSearchableIndexDelegate, StorageModel {
    
    class var shared: Corpus {
        struct Singleton {
            static let sharedAppConfiguration = Corpus()
        }
        return Singleton.sharedAppConfiguration
    }
    override init() {
        // this is definitely first
        if  !NSFileManager.defaultManager().fileExistsAtPath(FS.shared.CorpusDirectory) {
            FS.shared.createDir(FS.shared.CorpusDirectory)
        }
        
        
    }
    
    var hashTable : Htable = [:]
    var docIDSeqNum = initialDocSeqNum
    
    func haveprops()->Bool {
        return  NSFileManager.defaultManager().fileExistsAtPath(FS.shared.CorpusPlist)
    }
    func save() {
        hashTable["version"] =  [currentversion]
        let elapsedTime = timedClosure("Corpus Save"){
            (hashTable as NSDictionary).writeToFile(FS.shared.CorpusPlist, atomically: false)
        }
        let c = hashTable.count
        let s =  String(format:"%02f ",elapsedTime)
        print("Saved Corpus of \(c) items in  \(s) ms")
    }
    func reload() -> Bool {
        if let yy = NSDictionary(contentsOfFile:FS.shared.CorpusPlist) {
            let elapsedTime = timedClosure("Corpus Reload"){
            self.hashTable = yy as! Htable
            // figue out the new docIDSeqNum
            var maxseq = 0
            for (key,val) in self.hashTable {
                if key == "version" {
                    let v = yy["version"] as! NSArray
                    let xx = v[0] as! String
                    guard xx == currentversion else {
                        fatalError("Version Mismatch for Corpus Data should be \(currentversion) not \(xx)")
                    }
                }
                else {
                let v = val as Hpay
                if let docid = Int(v[0] ){
                    if docid > maxseq { maxseq = docid }
                }
                }
            }
            // reset the next seq num to allocate based on the scan
            if maxseq > 0 { self.docIDSeqNum = maxseq + 1 }
            }// end of timedClosure
             let s =  String(format:"%02f ",elapsedTime)
            print("Reloaded Corpus in \(s) ms")
            return true
        }
        
        // nothing there
        hashTable = ["version":[currentversion]]
        
        print("Creating New Corpus Plist \(currentversion)")
        return false
    }
    class func corpusFileName(seqnum:Int,type:String) -> String {
        let newname =  "\(seqnum).\(type)"
        let corpusPath = FS.shared.CorpusDirectory
        let corpusfilename = corpusPath + "/" + newname
        return corpusfilename
    }
    func deindexItem(which: Int) {
        CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers(["\(which)"]) { (error: NSError?) -> Void in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully removed!")
            }
        }
    }
    class func addDocumentWithBits(bits:NSData,title:String,type:String) -> (Bool,String,String) {
        
        // write it as a completely fresh file with abstract filename
        let corpusfilename = corpusFileName(Corpus.shared.docIDSeqNum,type:type)
        
        let b = bits.writeToFile(corpusfilename,atomically:false)
        if !b {print("cant write to \(corpusfilename)")}
        
        let md5hash  = FileHash.md5HashOfFileAtPath(corpusfilename)
        if md5hash == nil { print("nilhash('\(Corpus.shared.docIDSeqNum)')") }
        else {
            // check if already in the hashtable
            let hp = Corpus.shared.hashTable[md5hash!]
            if hp != nil {
                // in that case do nothing, we already have this document
                print("dupe('\(Corpus.shared.docIDSeqNum)','\(md5hash!)','\(type)','\(title)')")
                return (false,title,"\(Corpus.shared.docIDSeqNum)")
            }
            else {
                let newhp: Hpay = ["\(Corpus.shared.docIDSeqNum)",type,title]
                Corpus.shared.hashTable[md5hash!] = newhp
                print("stored('\(Corpus.shared.docIDSeqNum)','\(md5hash!)','\(type)','\(title)')")
                
                var contentType : String?
                var contentDescription : String?
                let tipe = type.lowercaseString
                /// IOS 9 - add to spotlight index
                switch tipe {
          
                case "doc","docx","pages":
                    contentType = kUTTypeContent as String
                    contentDescription = "Doc SheetCheats"
                case "png","jpg","jpeg","gif":
                    contentType = kUTTypeImage as String
                    contentDescription = "Image SheetCheats"
                case "rtfd":
                    contentType = kUTTypeRTF as String
                    contentDescription = "RTF SheetCheats"
                case "html":
                    contentType = kUTTypeHTML as String
                    contentDescription = "HTML SheetCheats"
                case "pdf":
                    contentType = kUTTypePDF as String
                    contentDescription = "PDF SheetCheats"
                case "txt":
                    contentType = kUTTypeText as String
                    contentDescription = "Text SheetCheats"
                default:
                    contentType = kUTTypeText as String
                contentDescription = "Other SheetCheats"
                }
                
                
//                let t = CAdded(title: title,hint:";added:12345")
//                t.listNamed = "Addeds"
//                Addeds.shared.add(t) // record this
                
                
//                contentType = kUTTypeText as String
//                contentDescription = title //"Text Test Temp Stuff"
                
                if contentType != nil { // add to Spotlight
                    let    attributeSet = CSSearchableItemAttributeSet(itemContentType: contentType!)
                    attributeSet.contentDescription = contentDescription
                    attributeSet.title = title
                    
 let item = CSSearchableItem(uniqueIdentifier:title ,// "\(Corpus.shared.docIDSeqNum)", 
    domainIdentifier: "com.shovelreadyapps.storied", attributeSet: attributeSet)
                    item.expirationDate = NSDate.distantFuture()
                    
                    CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (err: NSError?) -> Void in
                        
                        if let error = err {
                            print("spotlight: \(title)  \(item.uniqueIdentifier) err:\(error.localizedDescription)")
                        } else {
                           // print("Search item successfully indexed!")
                        }
                      
                    }
                }
                // trak it
                let t = CAdded(title: title,hint:"needs hint")
                t.listNamed = "Addeds"
                Addeds.shared.add(t) // record this
                Corpus.shared.docIDSeqNum++
                return (true,title,"\(Corpus.shared.docIDSeqNum-1)")
            }
        }
        // compute the checksum - rereads
        // if the checksum already exists then back it out
        return (false,"","")
    }
    
    class func lookup(s:String) ->[String] {
        // this is a horrible linear search for now
        // return urllist
        let ns = normalizeTitle(s)
        var urllist:[String] = []
        for (_,val) in Corpus.shared.hashTable {
            let v = val as Hpay
            if v.count > 2 { // guard against short entry for version metadata
                let id = v[0] as String
                let title = v[2]
                let ext = v[1]
                if title ==  ns  {
                    urllist.append( FS.shared.CorpusDirectory + "/\(id).\(ext)")
                }
            }
        }
        if urllist.count == 0  { print("lookup of \(s) failed ")
            
            // r put something up
            let filePath = "TileNotFound"
            
            
            urllist = [ NSBundle.mainBundle().pathForResource(filePath, ofType:"png")! ]
        }
        return urllist // whatever we got
    }
    
    class func sorted()->[SortEntry] {
        var list : [SortEntry] = []
        for (md5,val) in Corpus.shared.hashTable {
            let v = val as Hpay
            if v.count > 2 { // if shorter, its version number metadata
                let title = v[2]
                
                let se = SortEntry(title: title,md5hash: md5)
                list.append(se)
            }
        }
        list.sortInPlace () {return $0.title < $1.title }
        
        return list
    }
    class func uniques(list:[SortEntry])->[SortEntry] {
        var uniq : [SortEntry] = []
        var last = ""
        for each in list {
            if each.title != last {
                uniq.append(each)
                last = each.title
            }
        }
        return uniq
    }
    //MARK: cleanup Title String, compatible with old GigStand Titles
    
    
    class func xnormalizeTitle(title:String) -> String {
        return title
    }
    
    class func normalizeTitle(title:String) -> String {
        
        var obuf:String = ""
        var lastWasSpace = false
        var lastWasNum = true
        var first = true
        var thisIndex:Int = 0
        for o:Character in title.characters {// process each, compress spaces
            switch o { // make each cap generate a new word
                
            case "\"","'":             lastWasNum = false
                // skip over quotes, dont copy

                
            case " ","\t","_": lastWasSpace = true; //lastWasCap = false
            lastWasNum = false
                
            case "0","1","2","3","4","5","6","7","8","9":
                
                let space = first&&(lastWasNum==false) ?
                    "": " "
                obuf = obuf + space + "\(o)"
                lastWasSpace = false
                lastWasNum = true
            case "A","B","C","D","E","F","G","H","I","J","K","L","M",
            "N","O","P","Q","R","S","T","U","V","W","X","Y","Z":
                let space = first ? "": " "
                obuf = obuf + space + "\(o)"
                lastWasSpace = false
                lastWasNum = false
            case "a","b","c","d","e","f","g","h","i","j","k","l","m",
            "n","o","p","q","r","s","t","u","v","w","x","y","z":
                let s = "\(o)" // is this slow??
                let lo = first || lastWasSpace ? s.uppercaseString : s
                let space = lastWasSpace ? " ": ""
                obuf = obuf + (space + lo)
                lastWasSpace = false
                lastWasNum = false
                
            default:
                let space = lastWasSpace ? " ": ""
                obuf  = obuf + space + "\(o)"
                lastWasSpace = false
                lastWasNum = false
                
            }
            first = false
            thisIndex++
        }
        return obuf
    }
    
    // MARK: -  CSSearchableIndexDelegate
    
    
    // The index requests that the delegate should reindex all of its searchable data and clear any local state that it might have persisted because the index has been lost.
    // The app or extension should call indexSearchableItems on the passed in CSSearchableIndex.
    // The app or extension must call the acknowledgement handler once any client state information has been persisted, that way, in case of a crash, the indexer can call this again.
    // If the app passes clientState information in a batch, the acknowledgement can be called right away.
    // The passed in index shouldn't be used in an extension if a custom protection class is needed.
    func searchableIndex(searchableIndex: CSSearchableIndex, reindexAllSearchableItemsWithAcknowledgementHandler acknowledgementHandler: () -> Void)
    {
        print("reindexAllSearchableItemsWithAcknowledgementHandler");
    }
    
    // The index requests that the delegate should reindex the searchable data with the provided identifiers.
    // The app or extension should call indexSearchableItems:completionHandler on the passed in index CSSearchableIndex to update the items' states.
    // The app or extension must call the acknowledgement handler once any client state information has been persisted, that way, in case of a crash, the indexer can call this again.
    // If the app passes clientState information in a batch, the acknowledgement can be called right away.
    // The passed in index shouldn't be used in an extension if a custom protection class is needed.
    func searchableIndex(searchableIndex: CSSearchableIndex, reindexSearchableItemsWithIdentifiers identifiers: [String], acknowledgementHandler: () -> Void)
    {
        print("reindexSearchableItemsWithIdentifiers");
    }
    
}