//
//  BoardDetails.swift
//  sheetcheats
//
//  Created by william donner on 8/6/14.
//  Copyright (c) 2014 william donner. All rights reserved.
//

import Foundation
// MARK: -board pages are special lists
/// CpageEntry is an abstract subclass that handles entries on a BoardPage

//TODO: - move persistence of all this into one CoreData table

public class CPageEntry : BasiclListEntry ,SpecialListMethods {
	public var track:JSONInt
	public var notes:[String]

	override public  func encode () -> [String] {
		var nots = ""
		for s in self.notes { let todo = (nots == "") ? s : s + "," ; nots += todo }
		var t = "9"
		if self is CSetName {
			t = "0"
		} else if self is CSetTune {
			t = "1"
		} else
		if self is CPageHeader {
			t = "2"
		} else if self is CPageFooter {
			t = "3"
		}
		return [self.title, self.time, self.track, t, nots]
	}
	override public class func decode (x:[String]) -> SpecialListEntry {

		let nots = x[4].componentsSeparatedByString(",")
		if x[3]=="0"  {
			return CSetName(title:x[0],track:x[2],notes:nots)
		}
		if x[3]=="1" {
			return CSetTune(title:x[0],track:x[2],notes:nots)
		}
		if x[3]=="2"  {
			return CPageHeader(title:x[0],track:x[2],notes:nots)
		}
		if x[3]=="3" {
			return CPageFooter(title:x[0],track:x[2],notes:nots)
		}
		// this last case below should never normally happen
		return CPageEntry(title:x[0],track:x[2],notes:nots)
	}

	public init(title: Title, track:JSONInt, notes:[String]) {
		self.track = track
		self.notes = notes
		super.init(title:title)
	}
}
public class CSetName: CPageEntry {
	override public 	 var description:String {
		return "[csetname:\(title) track:\(track)]"
	}
	// encodedecode handled by CpageEntry
override public init(title: Title, track:JSONInt, notes:[String])  {
		super.init(title:title,track:track,notes:notes)

	}
}
public class CPageHeader: CPageEntry {
	override 	public 	 var description:String {
		return "[header:\(title) track:\(track)]"
	}
override public init(title: Title, track:JSONInt, notes:[String])  {
		super.init(title:title,track:track,notes:notes)
	}
}
public class CPageFooter: CPageEntry{
	override 	public 	 var description:String {
		return "[footer:\(title) track:\(track)]"
	}
override  public init(title: Title, track:JSONInt, notes:[String])  {
		super.init(title:title,track:track,notes:notes)
	}
}
public class CSetTune: CPageEntry {
	override public 		 var description:String {
		return "[tune:\(title) track:\(track)]"
	}
override public  init(title: Title, track:JSONInt, notes:[String]) {
		super.init(title:title,track:track, notes:notes)
	}
}

/// details associated with one board page, basically an array of PageEntryList items

public final class BoardDetails : SpecialList {
	// unlike siblings, this is not a singleton and must be inited with a board name
	public struct Configuration {
		public  static let maxSize = 500
		public  static let displayCount = 10
		public  static let label = "board"
	}
	// accessed from outside
	public var boardName:String
	public var pageEntries:PageEntryList // one list to rule them all
	var headerText:String = ""
	var footerText:String = ""
	
	public var isChecked:Bool = true
	private var detailsDict:NSDictionary
	
	override public var description : String {
		return Configuration.label + ": \(boardName), \(pageEntries.count) items =  \(pageEntries)"
	}
	/// from scratch
	 public init(boardName:String,details:NSDictionary) {
		self.boardName = boardName
		self.detailsDict = details
		self.pageEntries = []
		//unload details into pageEntries
		super.init()
	}

	/// when we know we have object on disk
	 public init(boardName:String,path:String) {
		self.boardName = boardName
		self.detailsDict = [:]
		self.pageEntries = []
		//unload details into pageEntries
		super.init()
		self.restore(path) // as easy as fishin
	}
	private  func pathForSaveFile()-> String  {
		return FileStore.shared.pathForBoardNamed(boardName)
	}
	
	func add(t:CPageEntry) {

		t.listNamed = boardName+"Details"
		//println("adding \(t) to \(self.boardName)")
		addToListTail(&pageEntries, maxSize: Configuration.maxSize, t: t)
	}
	
 public  func sortedalpha(limit:Int) -> [CPageEntry] {
		return alphaSorted(&pageEntries,limit:limit)
	}
	
	func save(path:String) { // also called as an export function
		//println("BoardDetails save of \(self.pageEntries)")
		gsave( &self.pageEntries,
			path:path,
			label: path.lastPathComponent
			)	}
	override public func save(){
		save(self.pathForSaveFile())
	} // end save
	override public func restore(){
		restore(self.pathForSaveFile())
	}
	
	func restore(path:String) { // also called as import func
		grestore( &self.pageEntries,path:path,label:path.lastPathComponent)
		//println("BoardDetails restored  \(self.pageEntries)")
	}// end of restore


	// MARK: reshape model pages according to caller's prefs
	// called by board view controller to decompose board into sets and tunes

	public class func reshapeBoard(inout pageEntries:PageEntryList) -> (String,String,[String],[[String]]) {
		
		var	tunes:[[String]]
		var	sets: [String]
		var headertext = ""
		var footertext = ""
		tunes = []
		sets = []
		
		for detail in pageEntries {
			if detail is CSetTune {
				// new tune
				var curset = sets.count-1
				if curset < 0 { // hasnt seen a setlist so make one
					sets.append("set generated on " + NSDate().description)
					tunes.append([])
					curset = 0 // 4 hrs !!
				}
				tunes[curset].append(detail.title)
			} else
				if detail is CSetName {
				 // new setlist
					sets.append(detail.title + NSDate().description)
					tunes.append([])
			}
				else
					if detail is CPageHeader {
						// new setlist
						headertext += detail.title
			}
					else
						if detail is CPageFooter {
							footertext += detail.title
			}
		}
		return (headertext,footertext,sets,tunes)
	}

	public class func reshapeBoardAsOneSet(inout pageEntries:PageEntryList) -> (String,String,[String],[[String]]) {

		// one alpha list

		var	tunes:[[String]]
		var	sets: [String]
		var headertext = ""
		var footertext = ""
		tunes = []
		sets = []

		for detail in pageEntries {
			if detail is CSetTune {
				// new tune
				var curset = sets.count-1
				if curset < 0 { // hasnt seen a setlist so make one
							sets.append("alpha set " + NSDate().description)
					tunes.append([])
					curset = 0 // 4 hrs !!
				}
				tunes[curset].append(detail.title)
			} else
				if detail is CSetName {
				 // nothing, just stash in footer
					footertext += " " + detail.title
				}
				else
					if detail is CPageHeader {
						// new setlist
						headertext += " " + detail.title
					}
					else
						if detail is CPageFooter {
							footertext += " " + detail.title
			}
		}
		tunes[0].sortInPlace {$0 < $1}
		return (headertext,footertext,sets,tunes)
	}
    public class func makeTilesFromCSV( components:NSArray) throws {
            //var first = true
        var trackcount = 1
        
        for o in components {
            let x = o as! NSArray
            var  t = "1"
            if o.count > 0 {
                let ttitle = x[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                if ttitle != "" {
                    if o.count >= 4 {
                        
                        t = x[3].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as String
                    }
                    switch t {
                        
                    case "0":	bd.add(CSetName(title: ttitle,
                        track: "88", notes: []))
                        
                    case "1":
                        var enuf = [String]()
                        enuf.append(t)
                        for _ in 1 ..< 6 {
                            enuf.append("")
                        }
                        
                        bd.add(CSetTune(title: ttitle, track: "\(trackcount++)", notes: []))
                    case "2"://header
                        bd.add(CPageHeader(title: ttitle,  track: "\(trackcount++)", notes: []))
                    case "3":// trailer
                        bd.add(CPageFooter(title: ttitle, track: "\(trackcount++)", notes: []))
                    default: 	bd.add(CSetTune(title: ttitle, track: "\(trackcount++)", notes: []))
                    }				
                    //first = false
                }
            }
        }
        //can end uop with somethn very hollow if junk is passed in
        return bd
    }
	public class func boardfromCSV(boardName:String, components:NSArray) -> BoardDetails {
		//var first = true
		var trackcount = 1
		let bd = BoardDetails(boardName:boardName,details: [:])
		for o in components {
			let x = o as! NSArray
			var  t = "1"
			if o.count > 0 {
				let ttitle = x[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
				if ttitle != "" {
			if o.count >= 4 {

				t = x[3].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) as String
			}
				switch t {
				
				case "0":	bd.add(CSetName(title: ttitle,
					 track: "88", notes: []))
				
				case "1":
					var enuf = [String]()
					enuf.append(t)
					for _ in 1 ..< 6 {
						enuf.append("")
					}
			
					bd.add(CSetTune(title: ttitle, track: "\(trackcount++)", notes: []))
				case "2"://header
					bd.add(CPageHeader(title: ttitle,  track: "\(trackcount++)", notes: []))
				case "3":// trailer
					bd.add(CPageFooter(title: ttitle, track: "\(trackcount++)", notes: []))
				default: 	bd.add(CSetTune(title: ttitle, track: "\(trackcount++)", notes: []))
				}				
					//first = false
			}
		}
		}
		//can end uop with somethn very hollow if junk is passed in
		return bd
	}
	public class func boardfromJSON(boardName:String, JSON:NSArray) -> BoardDetails {
		// link it in
		//println("boardFromJSON \(JSON)")
		
		//var first = true
		var setcount = 1
		let bd = BoardDetails(boardName:boardName,details: [:])
		for x in JSON {
			var skip = false
			let obj = x as! NSArray
			let t = obj.objectAtIndex(0) as! NSString
			if t.caseInsensitiveCompare("--setlist") == NSComparisonResult.OrderedSame {
				let setname = "name-\(setcount++)"
				
				bd.add(CSetName(title: setname,track: "77", notes: []))
				skip = true
			}
			if skip == false &&
				t.caseInsensitiveCompare("title") != NSComparisonResult.OrderedSame  {
					var enuf = [String]()
					enuf.append(t as String)
					for _ in 1 ..< 6 {
						enuf.append("")
					}
					bd.add(CSetTune(title: enuf[0], track: "98", notes: []))
			}
			//first = false
		}
		return bd
	}
	
}