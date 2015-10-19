//
//  SearchCollationSupport.swift
//  sheetcheats
//
//  Created by william donner on 6/14/15.
//  Copyright © 2015 william donner. All rights reserved.
//

import UIKit



// MARK: types used for concordance and file processing

public typealias Sideinfo = [[Int]]


/// Model representation in memory of sets and tunes go into a TitleMatrix
public typealias TitleInfo =  String
public typealias TitleMatrix = [[TitleInfo]]



public protocol MultiFacedSupport {
    func makeTitleView(title:String, color:UIColor, onPress:()->())-> UIView
    func rebuild()
}

// MARK: - Collation stuff is a singleton, who needs more?

class CollationSupport : Singleton {
	var collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation
	class var shared: CollationSupport {
		struct Singleton {
			static let sharedAppConfiguration = CollationSupport()
		}
		return Singleton.sharedAppConfiguration
	}
	class func matrixOfIndexes(inout list: [SortEntry]) -> Sideinfo {

		var collation = UILocalizedIndexedCollation.currentCollation() as UILocalizedIndexedCollation

		func collationIndexForTitle(s:String) -> Int {
			func collationStringSelector()->NSString {
				return s as NSString
			}
			if s.isEmpty {return -1}
			let n = collation.sectionForObject(s , collationStringSelector: "description")
			return n
		}

		var matrix : Sideinfo = []
		let collcount = collation.sectionTitles.count

		for _ in 0..<collcount {
			matrix.append([])
		}
		var listidx = 0
		for entry in list {
			let j = collationIndexForTitle(entry.title)
			matrix[j].append(listidx)
			listidx++
		}
		return matrix
	}
}

