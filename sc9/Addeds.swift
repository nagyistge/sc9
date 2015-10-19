//
//  Addeds.swift
//  sheetcheats
//
//  Created by william donner on 7/29/14.
//  Copyright (c) 2014 william donner. All rights reserved.
//

import Foundation

public final class Addeds : SpecialList,Singleton {
	public struct Configuration {
		public  static let maxSize = 100
		public  static let displayCount = 5
		public  static let label = "addeds"
	}
	var gAddeds:AddedsList = [] // one list to rule them all
	
	public class var shared: Addeds {
	struct Singleton {
		static let sharedAppConfiguration = Addeds()
		}
		return Singleton.sharedAppConfiguration
	}
	override public var description : String {
	return Configuration.label + ": \(gAddeds.count) \(gAddeds)"
	}
//	private func pathForSaveFile()-> String  {
//            return FS.shared.AddedsPlist
//	}
	func add(t:CAdded) {
		//println("addToAddeds \(t)")
		addToList(&gAddeds, maxSize: Configuration.maxSize, t: t)

		//save()
	}
	override  public func save(){
		gsave(&gAddeds,path:FS.shared.AddedsPlist,label:Configuration.label)

	}
	override public  func restore(){
		grestore(&gAddeds,path:FS.shared.AddedsPlist,label:Configuration.label)
			
	}
func sortedalpha(limit:Int) -> [CAdded] {
		return alphaSorted(&gAddeds,limit:limit)
	}
}