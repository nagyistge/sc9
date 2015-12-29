//
//  Incorporator.swift
//  stories
//
//  Created by william donner on 7/2/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit

//  based on
//  Assimilator.swift
//  SheetCheats



func timedClosure(_:String, f:()->())->NSTimeInterval {
    let startTime = NSDate()
    f()
    let elapsedTime : NSTimeInterval = NSDate().timeIntervalSinceDate(startTime)
    return elapsedTime * 1000.0
}

public typealias FilePath = String
public typealias FilePaths = [FilePath]

public typealias selectorFunc = (String)->(Bool)

typealias compleet = (String,Int,Int,Int) -> ()

protocol StorageModel {
    func tempDirectoryForZip()->String
    func unzipFileAtPath(zipPath:String, toDestination: String)
    func normalizeTitle(title:String)->String
    func addDocumentWithBits(bits:AnyObject,title:String,type:String) -> (Bool,String,String)
    func saveGorpus()
    func saveAddeds()
}

extension StorageModel {
    func tempDirectoryForZip()->String {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "tmp"
    }
    func normalizeTitle(title:String)->String {
        let title2  = Corpus.normalizeTitle(title)
        if title2.characters.count == 0 { //println ("path \(path) has no tag")
            return  ""}
        return title2
        
    }
    func unzipFileAtPath(zipPath:String, toDestination: String) {
        
        ZipMain.unzipFileAtPath(zipPath, toDestination: FS.shared.TemporaryDirectory)
    }
    func addDocumentWithBits(bits:AnyObject,title:String,type:String) -> (Bool,String,String) {
        return Corpus.addDocumentWithBits(bits as! NSData,title:title,type:type)
        //return (false,"","")
    }
    func saveGorpus() {
        
        Corpus.shared.save() // make it safe by writing (ugh) the entire hashtable thing
    }
    func saveAddeds() {
        
        Addeds.shared.save()
    }
}


final class Incorporator:StorageModel {
    
    var gson = 0
    var csv = 0
    var zip = 0
    var deft = 0
    var dupes = 0
    var read = 0
    
    var elaps: Double = 0.0
    var opages = 0
    var odupes = 0
    var ofilesread = 0
    
    class func pathsForPrefix(dirPath:String) -> FilePaths {
        var error:NSError?
        var paths:NSArray?
        do {
            paths = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(dirPath)
        } catch let error1 as NSError {
            error = error1
            paths = nil
        }
        var toProcess:FilePaths = []
        if (error != nil) { return toProcess }
        for path:AnyObject in paths! {
            let spath = path as! String
            if !spath.hasPrefix("."){
                let fullpath:FilePath = dirPath + "/" + spath
                do {
                    let attrs = try NSFileManager.defaultManager().attributesOfItemAtPath(fullpath)
                    let fattrs = attrs as [String : AnyObject]
                    
                    //	errln ("filetype of \(spath) is \(fattrs[NSFileType])")
                    if fattrs[NSFileType] as? NSString == NSFileTypeRegular {
                        toProcess.append(fullpath)
                    }
                    else {
                        if error != nil { print ("error getting attrs on \(spath), \(error)")
                        }
                    }
                } catch let error1 as NSError {
                    error = error1
                }
                
            }
        } // all paths
        return toProcess
    }
    
    
    private func processIncomingFromPath(inboxPath:String,each: compleet) {
        var dupes = 0
        var filesread = 0
        func iassimilate(path:String,todo:selectorFunc,  inout x: Int) {
            // delete the incoming if told to do so
            //var error:NSError?
            let toDelete = todo (path)
            if toDelete {
                x++
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(path)
                } catch  _ as NSError {
                    //error = error1
                }
            }
        }
        
        // CSV files from Excel get translated to GSON/Json
        func doCSV(path:String)->Bool {
            
            let inc = Incorator()
            inc.processCSV(path)
            self.opages += 1
            self.csv += 1
            return true//return r
        }
        
        // zip files are expanded and each is processed
        func doZip(zipPath:String)->Bool {
            autoreleasepool{
                
                let tempPath = self.tempDirectoryForZip()
                
                self.unzipFileAtPath(zipPath, toDestination: tempPath)
                // recurse
                processIncomingFromPath(tempPath,each: each)
                
            }// autorelease
            return true
        }
        func trak(title:String,hint:String) {
            // trak it
            //			let t = CAdded(title: title,hint:hint)
            //			t.listNamed = "Addeds"
            //			Addeds.shared.add(t) // record this
        }
        // stash file into sharded system as a bunch of bits
        func doFile(path:String) -> Bool {
            let nspath = path as NSString
            var r = true
            autoreleasepool {
                var error:NSError?
                let part = (nspath.lastPathComponent as NSString).stringByDeletingPathExtension.componentsSeparatedByString("-")[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let title  = self.normalizeTitle(part)
                if title.characters.count == 0 { //println ("path \(path) has no tag")
                    return } // in this case do no harm with null strings
                let bits: NSData?
                do {
                    bits = try NSData(contentsOfFile:path, options: NSDataReadingOptions())
                } catch let error1 as NSError {
                    error = error1
                    bits = nil
                } catch {
                    fatalError()
                }
                filesread++;self.ofilesread++
                if let err = error {
                    print ("Incorporator File for \(path) read error \(err)")
                    r = false
                }
                else {
                    
                    let (notdupe,normalTitle,hint) = 	self.addDocumentWithBits(bits!,title:title as String,type:nspath.pathExtension) // yikes
                    trak (normalTitle,hint: hint)
                    if !notdupe   { dupes++; self.odupes++}
                    
                    // call per file completion
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            each(normalTitle,self.ofilesread,self.odupes,self.csv)
                    })
                }
            } // autoreleasepool
            return r
        }
        gson = 0
        csv = 0
        zip = 0
        deft = 0
        let toProcess = Incorporator.pathsForPrefix(inboxPath)
        print("--------------------assimilating \(toProcess.count) documents")
        for fp in toProcess {
            let filepath = fp as NSString
            let filetitle:String = filepath.lastPathComponent
            if (!filetitle.hasPrefix(".")) { // skip any system files that dribble in
                let filetype:NSString = filepath.pathExtension // swift bug - must be NSString
                let lower:String = filetype.lowercaseString
                
                switch lower {
                    //                case "gson" :
                    //                    iassimilate(fp,todo: doGson,x: &gson)
                case "csv" :
                    iassimilate(fp,todo: doCSV,x: &csv)
                case "zip" :
                    iassimilate(fp,todo: doZip,x: &zip)
                default:
                    iassimilate(fp,todo: doFile,x: &deft)
                }
            }
        }
    }
    
    
    
    func assimilateInBackground(documentsPath:String, each: compleet, completion:compleet) -> Bool {
        
        let elapsedTime = timedClosure("assimilateInBackground") {
            doThis( {
                self.processIncomingFromPath(documentsPath, each: each)
                
                }
                , thenThat: {
                    
                    self.saveAddeds()
                    
                    self.saveGorpus()
                    
                    Globals.saveDataModel()
                    
                    completion ("Import Done",self.ofilesread,self.odupes,self.csv)
            })
            
        }
        print ("--------------------grand total read: \(self.ofilesread) dupes: \(self.odupes)  \(Int(elapsedTime))ms")
        return true
    }
}


private class Incorator:ModelData    {
    var insection = ""
    var trackcount = -1
    var sectionNumber = -1
    var sectionNameFromPath = ""
    
    
    // add section header
    func cSetName(title:String, track:String = "", notes:[String] = []) {
        
        //print ("cSetName ",title)
        
        sectionNumber += 1
        trackcount = -1 // will get bumped
        
        let ip = NSIndexPath(forRow:sectionNumber, inSection:0)
        
        self.makeHeaderAt(ip,labelled:"\(title) - \(sectionNameFromPath)")
        
        insection = title
        
    }
    // add tile in section
    func cSetTune(title:String,
        track:String = "", note:String = "", key:String = "", bpm:String = "") {
          //  print ("cSetTune ",title)
            
            if insection == "" {
                // if not in a set then ake one
                cSetName("\(sectionNameFromPath)", track: "")
            }
            trackcount += 1
            
            let ip = NSIndexPath(forItem :trackcount, inSection:sectionNumber)
            let tile = self.makeTileAt(ip,labelled: "\(title)")
            tile.tyleKey = key
            tile.tyleBpm = bpm
            tile.tyleNote = note
            
    }
    
    func trim(s:String) -> String {
        return    s.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    func makeTilesFromCSV(components:NSArray) throws {
        for o in components {
            let xns = o as! NSArray
            let x =  xns as! [String]
            if o.count > 0 {
                let ttitle = trim(x[0])
                let key = o.count > 1 ? trim(x[1]):""
                let bpm = o.count > 2 ? trim(x[2]):""
                let note = o.count > 3 ? trim(x[3]):""
                if ttitle != "" {
                    if ttitle.hasPrefix("//") {  } else
                        if ttitle.hasPrefix("=") {
                            let tits = ttitle.substringFromIndex(ttitle.startIndex.advancedBy(1))
                            cSetName(tits,track: "88")
                        } else {
                            cSetTune(ttitle,track:"1",note:note,key:key,bpm:bpm)
                    }
                }
            }
        }
        //can end uop with somethn very hollow if junk is passed in
    }
    
    
    func processCSV(path:String) -> Bool {
        let url = NSURL(fileURLWithPath: path)
        
        //var error:NSError?
        let components  = NSArray(contentsOfCSVFile:path)
        if components.count > 0 {
            
            sectionNameFromPath = url.lastPathComponent!.componentsSeparatedByString(".")[0]
            
            do {
                try makeTilesFromCSV(components)
            }
            catch {
                print("no useful rows in CSV")
                return false
            }
            return true
        }
        return false
    }
}

//func cPageHeader(title:String, track:String = "", notes:[String] = []) {
//    print ("cPageHeader ",title)
//}
//
//func cPageFooter(title:String, track:String = "", notes:[String] = []) {
//    print ("cPageFooter ",title)
//}
//                    if o.count >= 4 {
//                        t = trim(x[3])
//                    }
//                    switch t {
//
//                    case "0":
//                        cSetName(ttitle,track: "88")
//                    case "1":
//                        cSetTune(ttitle)
//                    case "2"://header
//                        cPageHeader( ttitle)
//                    case "3":// trailer
//                        cPageFooter(ttitle)
//                    default: