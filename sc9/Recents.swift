//
//  Recents.swift
//  sheetcheats
//
//  Created by william donner on 7/21/14.
//  Copyright (c) 2014 william donner. All rights reserved.
//

import Foundation
public typealias CAdded = CRecent
public typealias RecentList = [CRecent]
public typealias AddedsList = [CAdded]
public class CRecent : BasiclListEntry ,SpecialListMethods {
	var hint:ID
	override 	public var description:String {
		return "[crecent:\(title) hint:\(hint)]"
	}
	override public  func encode () -> [String] {
	 return [self.title,self.time,self.hint]
	}
	override public class func decode (x:[String]) -> SpecialListEntry {
	 return CRecent(title:x[0], hint:x[2])   // yikes
	}
	public init(title: Title,  hint:ID) {
		self.hint = hint
		super.init(title:title)
		self.listNamed = Recents.Configuration.label
	}
}
public final class Recents : SpecialList, Singleton {
public  struct Configuration {
		public  static let maxSize = 100
		public  static let displayCount = 5
		public  static let label = "recents"
	}
	var gRecents:RecentList = [] // one list to rule them all
	
public class var shared: Recents {
	struct Singleton {
		static let sharedAppConfiguration = Recents()
		}
		return Singleton.sharedAppConfiguration
	}

	override public var description : String {
	return Recents.Configuration.label + ": \(gRecents.count) \(gRecents)"
	}
	private func pathForSaveFile()-> String  {
	return FS.shared.RecentsPlist
	}
	func add(t:CRecent) {
				t.listNamed = "Recents"
		addToList(&gRecents, maxSize:  Recents.Configuration.maxSize , t: t)
		//save()
	}
public func sortedalpha(limit:Int) -> [CRecent] {
		return alphaSorted(&gRecents,limit:limit)
	}

	//brutally check all the recents for everything we have shown so as to get the hintID
	func hintFromRecent(title:Title)->ID {
		for eachRecent:CRecent in gRecents {
			if eachRecent.title == title {
				return eachRecent.hint
			}
		}
		return ""
	}

	public override func save(){
		gsave( &self.gRecents,path:self.pathForSaveFile(),label: Recents.Configuration.label)
	}
	
	public override func restore(){
		grestore( &self.gRecents,path:self.pathForSaveFile(),label:  Recents.Configuration.label)
	}
	
}