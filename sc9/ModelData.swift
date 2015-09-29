//
//  ModelData.swift

//  Created by william donner on 9/29/15.

import Foundation

typealias ElementType = String
final class Model {
	class var data: Model {
		struct Singleton {
			static let sharedAppConfiguration = Model()
		}
		return Singleton.sharedAppConfiguration
	}
	var tiles = [[ElementType]]()
	var sectionHeaders = [ElementType]()
	var recents = ["R0","R1","R2"]
	var addeds = ["A0","A1","A2"]
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
protocol ModelData {

	func addLastSpecialElements()
	func removeLastSpecialElements()
	func mswap(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath)
	func mswap2(sourceIndexPath:NSIndexPath, _ destinationIndexPath:NSIndexPath)

	func sectCount() -> Int
	func sectHeader(i:Int)->ElementType
	func moveSects(from:Int, _ to:Int)
	func deleteSect(i: Int)
	func makeNewSect(i:Int,title:ElementType )

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
	func addedsData(i:Int)->ElementType{
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

	func sectHeader(i:Int)->ElementType {
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
	func makeNewSect(i:Int,title:ElementType ){
		//print("making section \(t) at index:\(i)")
		Model.data.sectionHeaders.insert( "sec \(i) @ \(title)", atIndex:i )

		Model.data.tiles.insert ([], atIndex:i) //append a new, empty section
		let plus: String = "+"
		let j = i// Model.data.tiles.count - 1 // new index
		for c in plus.characters {
			Model.data.tiles[j].append(String(c))
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
				Model.data.tiles[j].append(String(c))
			}
		}
	}
	func removeLastSpecialElements() {
		for j in 0..<Model.data.tiles.count {
			for i in 0..<Model.data.tiles[j].count {
				if Model.data.tiles[j][i] == "+" {
					Model.data.tiles[j].removeAtIndex(i)
					break
				}
			}
		}
	}
	
	
}
