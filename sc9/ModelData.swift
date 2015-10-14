//
//  ModelData.swift

//  Created by william donner on 9/29/15.

import Foundation

// each tile is just a simple dictionary of properties
typealias ElementType = [String:String]

struct ElementProperties {
	static let NameKey = "STR"
}

protocol ElementTypeAccess {
	func isEqualElementString(s:ElementType,string:String)->Bool
	func makeElementFrom(from:String)->ElementType
}
extension ElementTypeAccess {
	func isEqualElementString(s:ElementType,string:String)->Bool {
		return  s[ElementProperties.NameKey] == string
	}
	func makeElementFrom(from:String)->ElementType {
		var s = ElementType()
		s[ElementProperties.NameKey] = from
		return s
	}
}
// each header is just a simple dictionary of properties
typealias HeaderType = [String:String]

protocol HeaderTypeAccess {
	func isEqualHeaderString(s:HeaderType,string:String)->Bool
	func makeHeaderFrom(from:String)->HeaderType
}
extension HeaderTypeAccess {
	func isEqualHeaderString(s:HeaderType,string:String)->Bool {
		return  s[ElementProperties.NameKey] == string
	}
	func makeHeaderFrom(from:String)->HeaderType{
		var s = HeaderType()
		s[ElementProperties.NameKey] = from
		return s
	}
}

final class Model {
	class var data: Model {
		struct Singleton {
			static let sharedAppConfiguration = Model()
		}
		return Singleton.sharedAppConfiguration
	}
	var tiles = [[ElementType]]()
	var sectionHeaders = [HeaderType]()
	var recents = [ElementType]()//["R0","R1","R2"]
	var addeds = [ElementType]()//["A0","A1","A2"]
	var segueargs : [String:AnyObject] = [:]



	func describe() {
		if tiles.count > 0 {
			print  ("Model is ", tiles.count, " rows with ",tiles[0].count," elements in 1st row")
		}
		else {
			print("Model has no data")
		}
	}
}
protocol ModelData :ElementTypeAccess,HeaderTypeAccess{

	func addLastSpecialElements()
	func removeLastSpecialElements()
	func mswap(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath)
	func mswap2(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath)

	func sectCount() -> Int
	func sectHeader(i:Int)->HeaderType
	func moveSects(from:Int, _ to:Int)
	func deleteSect(i: Int)
	func makeNewSect(i:Int,hdr:HeaderType )

	func tileInsert(indexPath:NSIndexPath,newElement:ElementType)
	func tileData(indexPath:NSIndexPath)->ElementType
	func tileSection(indexPath:NSIndexPath)->[ElementType]
	func tileRemove(indexPath:NSIndexPath)
	func tileSectionCount() -> Int

	func addedsCount()->Int
	func addedsData(i:Int)->ElementType

	func recentsCount()->Int
	func recentsData(i:Int)->ElementType

}

extension ModelData {
	////

	func addedsCount()->Int {
		return Model.data.addeds.count
	}
	func addedsData(i:Int)-> ElementType{
		return Model.data.addeds[i]
	}
	func recentsCount()->Int {
		return Model.data.recents.count
	}
	func recentsData(i:Int)->ElementType{
		return Model.data.recents[i]
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
	func tileSection(indexPath:NSIndexPath)->[ElementType] {
		return Model.data.tiles[indexPath.section]
	}
	func tileRemove(indexPath:NSIndexPath) {
		Model.data.tiles[indexPath.section].removeAtIndex(indexPath.item)
	}
	func tileInsert(indexPath:NSIndexPath,newElement:ElementType) {
		Model.data.tiles[indexPath.section].insert(newElement, atIndex: indexPath.item)
	}
	func tileData(indexPath:NSIndexPath)->ElementType {
		return Model.data.tiles[indexPath.section][indexPath.item]
	}

	func sectHeader(i:Int)->HeaderType {
		return Model.data.sectionHeaders[i ]
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
	func makeNewSect(i:Int,hdr:ElementType ){
		//print("making section \(t) at index:\(i)")
		let title = hdr[ElementProperties.NameKey]
		Model.data.sectionHeaders.insert(self.makeHeaderFrom("sec \(i) @ \(title)"), atIndex:i )

		Model.data.tiles.insert ([], atIndex:i) //append a new, empty section
		let plus: String = "+"
		let j = i// Model.data.tiles.count - 1 // new index
		for c in plus.characters {
			Model.data.tiles[j].append(makeElementFrom(String(c)))
		}
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
	func addLastSpecialElements() {
		let plus: String = "+"
		for j in 0..<Model.data.tiles.count {
			for c in plus.characters {
				Model.data.tiles[j].append(makeElementFrom(String(c)))
			}
		}
	}
	func removeLastSpecialElements() {
		for j in 0..<Model.data.tiles.count {
			for i in 0..<Model.data.tiles[j].count {
				if isEqualElementString(Model.data.tiles[j][i],string:"+") {
					Model.data.tiles[j].removeAtIndex(i)
					break
				}
			}
		}
	}
}