//
//  SpecialList.swift
//  sheetcheats
//
//  Created by william donner on 7/30/14.
//  Copyright (c) 2014 william donner. All rights reserved.
//

import Foundation
public typealias JSONDate = String
public typealias JSONInt = String
public typealias Word = String
public typealias ID = String
public typealias Title = String

//MARK: General lists for Favorites, Recents, Addeds, Friends, and BoardPages
/// base class, never directly instantiated
protocol SpecialListMethods {
	func encode () -> [String]
	static func decode (x:[String]) -> SpecialListEntry
}

class SpecialListEntry : SpecialListMethods {
	var listNamed: String
	var title:Title
	 func encode () -> [String] {
		assert(false,"must override encode()")
	 return []
	}
	 class func decode (x:[String]) -> SpecialListEntry {
	 assert(false,"must override class func decode()")
		return SpecialListEntry(title:"")
	}
	init(title:Title) {
		self.title = title // note, not normalized
		self.listNamed = "subclass must override"
	}
}

class BasiclListEntry:SpecialListEntry,CustomStringConvertible {
	var time:JSONDate
	var description:String {
		return "[ble:\(title) time:\(time)]"
	}
	override init(title:Title) {
        self.time = NSDate().description
		super.init(title: Corpus.normalizeTitle(title))
	}
}



/// stores lists as plists on disk - with encode/decoders

public protocol PersistenceSupport {
    func save()
    func restore()
}

public protocol SpecialListSupport {
	func add<T>(_:T)
	func sortedalpha<T>(limit:Int)->[T]
}
public class SpecialList: NSObject,  PersistenceSupport, SpecialListSupport {
	public func save() { assert(false,"Must subclass save on Persistent Special Lists") }
	public func restore() { assert(false,"Must subclass restore on  Persistent Special Lists") }
	public func add<T>(_:T)  { assert(false,"Must subclass add on  Persistent Special Listpublic s") }
	public func sortedalpha<T>(limit:Int)->[T]  { assert(false,"Must subclass sorted on  Persistent Special Lists")
		return [] }

	typealias ffunc =  (_:SpecialListEntry, _:SpecialListEntry) -> Bool

	func alphaSorted<T where T:SpecialListEntry>(inout g:[T], limit:Int ,predicate :ffunc) -> [T] {
		func timeSorted(limit:Int) -> [T]  {
			var x:[T] = []
			for i in 0 ..< min(g.count,limit) {
				x.append(g[i])
			}
			return x
		}
		let r = timeSorted(limit)
		let x = r.sort{predicate($0,$1)}
		return x
	}
	func alphaSorted<T where T:SpecialListEntry>(inout g:[T], limit:Int) -> [T] {
		return alphaSorted(&g,limit:limit,predicate:{$0.title<$1.title})
	}
	func addToList<T where T:SpecialListEntry>(inout list:[T] , maxSize:Int, t:T) {
		var idx  = 0
		for eachRecent:T in list {
			if eachRecent.title == t.title {
				//its here in the middle so reinsert at top
				list.removeAtIndex(idx)
				list.insert (t, atIndex: 0)
				return
			} else
			{
				idx++
			}
		}
		let size = list.count
		if size == maxSize {
			// keep size under control
			list.removeLast()
		}
		list.insert (t, atIndex: 0)
	}
	func addToListTail<T where T:SpecialListEntry>(inout list:[T] , maxSize:Int, t:T) {
		let size = list.count
		if size == maxSize {
			// keep size under control
			list.removeLast()
		}
		list.append (t)
	}
	func gsave<T where T:SpecialListEntry>( inout g:[T],path:String,label:String
		){
		doThis( 	{// background
				let f2 = {(w:T) -> [String]  in w.encode()}
				var records = 0
				let elaps = timedClosure("\(label).save()") {
					/// old school write plists with closure callback for each record
					let c = NSMutableArray()
					for w  in g {
						c.addObject(f2(w) as NSArray)
						records++
					}

					c.writeToFile(path, atomically: true)

				}
				let emit =  "saved \(records) \(label), \(Int(elaps))ms to \((path as NSString).lastPathComponent)"
				print(emit)
			},
            thenThat: { //(s:String) in // foreground
					//print(s)
			}
			)
	}

	/// reload from disk with timings
	// currently storing as a pipe delimited string
	func grestore<T where T:SpecialListEntry>(inout g:[T], path:String, label:String) {
		var records = 0
		let t0 = NSDate()
		g = []
					let c = NSArray(contentsOfFile:path)
				let t1 = NSDate()
		if c != nil {
					for y:AnyObject in c! {
						if	let x = y as? [String] {
						g.append( T.decode(x) as! T)
						records++
						}
			}
		}
//		var error:NSError?
//		var s = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: &error)
//		assert(error==nil)
//		//	println("restored from \(path) s \(s)")
//		let t1 = NSDate.date()
//		var parts = s.componentsSeparatedByString("|") //depipe
//
//		for part in parts  {
//			if part as NSString != "" {
//			let pieces = (part as NSString).componentsSeparatedByString(",") as [String]
//			g.append( T.decode(pieces) as T)
//			records++
//		}
//		}


		let t2 = NSDate()
		let elapsedTime1 : NSTimeInterval = t1.timeIntervalSinceDate(t0) * 1000.0 as NSTimeInterval
		let elapsedTime2 : NSTimeInterval = t2.timeIntervalSinceDate(t1) * 1000.0 as NSTimeInterval

		print ("restored \(records) \(label)  readtime \(Int(elapsedTime1 as Double ))ms rebuild \(Int(elapsedTime2 as Double))ms")
	}
}
