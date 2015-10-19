//
//  Versions.swift
//  sheetcheats
//
//  Created by william donner on 8/13/14.
//  Copyright (c) 2014 william donner. All rights reserved.
//

import Foundation

public class Versions {

	public class func make() -> Versions { return Versions() }

	public class func versionString () -> String {
		if let iDict = NSBundle.mainBundle().infoDictionary {
		if let w:AnyObject =  iDict["CFBundleIdentifier"] {
		if let x:AnyObject =  iDict["CFBundleName"] {
			if let y:AnyObject = iDict["CFBundleShortVersionString"] {
				if let z:AnyObject = iDict["CFBundleVersion"] {
					return "\(w) \(x) \(y) \(z)"
				}
			}
			}
		}
		}
		return "**no version info**"
	}
	private func versionSave () {
		let userDefaults = NSUserDefaults.standardUserDefaults()
		userDefaults.setObject(Versions.versionString(), forKey: "version")
		userDefaults.synchronize()
	}
	
	private func versionFetch() -> String? {
		 let userDefaults = NSUserDefaults.standardUserDefaults()
			if let s : AnyObject = userDefaults.objectForKey("version") {
				return (s as! String)
			}
		return nil
	}
	
	func versionCheck() -> Bool {
		let s = Versions.versionString()
		if let v = versionFetch() {
			if s != v {
				versionSave()
				print ("versionCheck changed :::: \(s) - will reset and may be slow to delete existing files")
			} else {
				print ("versionCheck stable :::: \(s)")
			}
			return s==v
		}
		// if nothing stored then store something, but we check OK
		versionSave()
		print("versionCheck first time up :::: \(s)")
		return true
	}
}