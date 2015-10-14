//
//  FileStuff.swift
//  stories
//
//  Created by william donner on 7/2/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import Foundation
class FS {

	class var shared: FS {
		struct Singleton {
			static let sharedAppConfiguration = FS()
		}
		return Singleton.sharedAppConfiguration
	}

 var DocumentsDirectory:String {
	return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "Private Documents"
	}
 var ItunesInboxDirectory:String {
	return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
	}
	var TemporaryDirectory:String {
		return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "tmp"
	}
	var ExportDirectory:String {
		return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String + "/" + "export"
	}
    var CorpusDirectory:String {
	return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "Private Documents/corpus"
	}
    var CorpusPlist:String {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "Private Documents/corpus.plist"
    }
    var SurfacePlist:String {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "Private Documents/board.plist"
    }
    var StoriesPlist:String {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "Private Documents/stories.plist"
    }
    var RecentsPlist:String {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "Private Documents/recents.plist"
    }
    var AddedsPlist:String {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0] as String + "/" + "Private Documents/addeds.plist"
    }
	func bootstrap() {
        print(ItunesInboxDirectory)
		resetTempFiles()
		createDir(ExportDirectory)
		createDir(DocumentsDirectory)
        createDir(CorpusDirectory) // dep
		/// Itunes Inbox is where we share with local files
	}

 func resetTempFiles() {
	var error:NSError?
	do {
		try NSFileManager.defaultManager().removeItemAtPath(TemporaryDirectory)
	} catch let error1 as NSError {
		error = error1
	}
	if (error != nil) { //errln("Cant remove temp directory \(error)")
	}
	do {
		try NSFileManager.defaultManager().createDirectoryAtPath(TemporaryDirectory, withIntermediateDirectories:true,    attributes: nil)
	} catch let error1 as NSError {
		error = error1
	}
	if (error != nil) { //errln("Cant create temp directory \(error)")
	}
	}//

	func createDir(dir:String) {  // Private
		var error:NSError?
		if NSFileManager.defaultManager().fileExistsAtPath(dir) == false {
			do {
				try NSFileManager.defaultManager().createDirectoryAtPath(dir, withIntermediateDirectories: true, attributes: nil)
			} catch let error1 as NSError {
				error = error1
			}
			if (error != nil) {
				//errln("Cant create dir \(dir) \(error)")
			}
			if NSFileManager.defaultManager().fileExistsAtPath(dir) == false {
				print ("Cant create dir \(dir) failed on re-read")
			}
		} else {
			//print  ("cant create because Directory exists -> \(dir)")
		}
	}
	
}
