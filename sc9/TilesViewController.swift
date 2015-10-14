//
//  TilesViewController.swift
//

import UIKit



protocol TilesViewDelegate {
	func tilesViewControllerReturningResults(data:String)
}
extension TilesViewDelegate {
	func tilesViewControllerReturningResults(data:String) {
		print("tilesViewControllerReturningResults ",data)
	}
}

final class TilesViewController: UICollectionViewController ,  ModelData    {
	

	var delegate:TilesViewDelegate?

	var longPressOneShot = false

	deinit {
		self.cleanupFontSizeAware(self)
	}

	func refresh() {
		self.collectionView?.reloadData()
		longPressOneShot = false // now listen to longPressAgain
	}
	// total surrender to storyboards, everything is done thru performSegue and unwindtoVC
	@IBAction func unwindToVC(segue: UIStoryboardSegue) {
		// unwinding
			print("Unwound to TilesViewController")

		self.refresh()
	}

	@IBAction func modalMenuButtonPressed(sender: AnyObject) {
		self.presentModalMenu(self)
	}
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
self.navigationController?.presentTransparentNavigationBar()
        if Model.data.tiles.count == 0 {
            // simulate a press if we get here with nothing
            NSTimer.scheduledTimerWithTimeInterval(0.1,    target: self, selector: "noItemsSimulatePress", userInfo: nil, repeats: false)
            //pressedLong()
        }

}
    func noItemsSimulatePress() {
        self.presentMore(self)
    }
	func pressedLong() {
		if longPressOneShot == false {
		self.presentModalMenu(self)

		longPressOneShot = true
				}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.removeLastSpecialElements()
		Model.data.describe()
		self.setupFontSizeAware(self)
   
		let tgr = UILongPressGestureRecognizer(target: self, action: "pressedLong")
		self.view.addGestureRecognizer(tgr)
     
	}

	override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		return false
	}
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		// in this case, show content
		self.storeStringArgForSeque(    self.tileData(indexPath).0[ElementProperties.NameKey]! )
		self.presentContent(self)
	}
}
extension TilesViewController {
	//: UICollectionViewDataSource {
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return self.tileSectionCount()
	}

	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.tileCountInSection(section)
	}

	override func collectionView(collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
			//1
			switch kind {
				//2
			case UICollectionElementKindSectionHeader:
				//3
				let headerView =
				collectionView.dequeueReusableSupplementaryViewOfKind(kind,
					withReuseIdentifier: "sectionheaderid",
					forIndexPath: indexPath)
					as! TilesSectionHeaderView

				headerView.headerLabel.text = self.sectHeader(indexPath.row)[ElementProperties.NameKey]
				headerView.headerLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
				return headerView
			default:
				//4
				assert(false, "Unexpected element kind")
			}
	}


	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		// 3
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TileCell", forIndexPath: indexPath) as!   TileCell

		// Configure the cell
		cell.configureCell(self.tileData(indexPath))
		return cell
	}
}

extension TilesViewController:SequeHelpers {
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == nil {
			// unwinding
			self.refresh()
		} else {
			self.prepForSegue(segue , sender: sender)
		}
	}
}
extension TilesViewController: FontSizeAware {
	func refreshFontSizeAware(vc: TilesViewController) {
		vc.collectionView?.reloadData()
	}
}

extension TilesViewController: ShowContentDelegate {
	func userDidDismiss() {
		print("user dismissed Content View Controller")
	}
}
///////////////////////////////////////////////





