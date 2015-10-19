//
//  SearchPick.swift
//  stories
//
//  Created by bill donner on 9/21/15.
//  Copyright © 2015 shovelreadyapps. All rights reserved.
//

import UIKit
class  SCRecord {
    let s:String = ""
}
class SCSearchTableViewCell : UITableViewCell {
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    //    @IBOutlet weak var priceLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainImageView.image = nil
        self.detailLabel.text = nil
        self.headlineLabel.text = nil
    }
}

// cache the documentChooser controller

var chooseDocTableViewController : ChooseDocTableViewController?
func chooseDocVC () -> ChooseDocTableViewController {
    if chooseDocTableViewController == nil {
        chooseDocTableViewController = UIStoryboard(name:"Main",bundle:nil).instantiateViewControllerWithIdentifier("ChooseDocTableViewControllerID") as? ChooseDocTableViewController
    }
    return chooseDocTableViewController!
}


class ChooseDocTableViewController: TitlesTableViewControllerInternal {
    
    override func shouldAutorotate() -> Bool {
        return false
    }
//    @IBAction func addStuff(sender: AnyObject) {
//        return itunesImport()
//    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      		let idx = matcoll[indexPath.section][indexPath.row]
        backData = incoming[idx].title
        print("Tapped row \(indexPath.row) title \(backData)")
        self.performSegueWithIdentifier("unwindFromChooseDoc", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// cache the search controller

var searchPickerTitlesViewController : SearchPickerTitlesViewController?
func searchPickerVC () -> SearchPickerTitlesViewController {
    if searchPickerTitlesViewController == nil {
        searchPickerTitlesViewController = UIStoryboard(name:"Main",bundle:nil).instantiateViewControllerWithIdentifier("SearchPickerTitlesViewControllerID") as? SearchPickerTitlesViewController
    }
    return searchPickerTitlesViewController!
}

// MARK: UISearchBarDelegate

extension SearchPickerTitlesViewController:UISearchBarDelegate
{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
// MARK: UISearchControllerDelegate
extension SearchPickerTitlesViewController:UISearchControllerDelegate {
    
    func presentSearchController(searchController: UISearchController) {
        //NSLog(__FUNCTION__)
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        //NSLog(__FUNCTION__)
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        //NSLog(__FUNCTION__)
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        //NSLog(__FUNCTION__)
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        //NSLog(__FUNCTION__)
    }
}


// MARK: UISearchResultsUpdating
extension SearchPickerTitlesViewController: UISearchResultsUpdating
{

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Update the filtered array based on the search text.
        // let searchResults = productRecs
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let strippedString = searchController.searchBar.text!.stringByTrimmingCharactersInSet(whitespaceCharacterSet)
        //if strippedString == "" {strippedString = " "} // if nothing typed, make a space
        let searchItems = strippedString.componentsSeparatedByString(" ") as [String]
        let andMatchPredicates : [NSPredicate]! = []
       // var orMatchPredicates : [NSPredicate]! = []
           var searchItemsPredicate = [NSPredicate]()
        // Build all the "AND" expressions for each value in the searchString.
        
        for searchString in searchItems {
            // Each searchString creates an OR predicate
         
            
            // Name field matching.
            let lhs = NSExpression(forKeyPath: "title")
            let rhs = NSExpression(forConstantValue: searchString)
            
            let finalPredicate = NSComparisonPredicate(leftExpression: lhs, rightExpression: rhs, modifier: .DirectPredicateModifier, type: .ContainsPredicateOperatorType, options: .CaseInsensitivePredicateOption)
            
            searchItemsPredicate.append(finalPredicate)
        }
        
       // orMatchPredicates = [NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)]
        
        // Add this OR predicate to our master AND predicate.
        //andMatchPredicates.append(orMatchPredicates)
        // Match up the fields of the Product object.
        let finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: andMatchPredicates)
        
        print("predicate = \(finalCompoundPredicate) searching \(incoming.count) recs")
        
        //  println("mainsearch has \(productRecs.count) product recs")
        
        let filteredResults = incoming.filter { finalCompoundPredicate.evaluateWithObject($0.title) }
        
        
        print("mainsearch found \(filteredResults.count) filtered recs")
        
        
        // Hand over the filtered results to our search results table.
        let resultsController = searchController.searchResultsController as! SCSearchResultsViewController
        resultsController.filteredProducts = filteredResults
        resultsController.tableView!.reloadData()
    }
}

    // MARK: UITableViewDataSource
    
    
    extension SearchPickerTitlesViewController {
        // Data model for the table view.
        
        
        func configureCell(cell: SCSearchTableViewCell, forProduct product: SortEntry, forIndexPath:NSIndexPath) {
            
            cell.headlineLabel?.text = product.title
        }
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return incoming.count
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("searcherid", forIndexPath: indexPath) as! SCSearchTableViewCell
            
            let product = incoming[indexPath.row]
            configureCell(cell, forProduct: product, forIndexPath:indexPath)
            
            return cell
        }
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            var selectedProduct: SortEntry
            
            // Check to see which table view cell was selected.
            if tableView == self.tableView {
                selectedProduct = incoming[indexPath.row]
            }
            else {
                selectedProduct = resultsTableController.filteredProducts[indexPath.row]
            }
            let _ = "\(selectedProduct.title):\(selectedProduct.title)"
            //        let uiv = viewControllerForProductFromPartner(IMIData.shared.retailerID!, selectedProduct.imiSKU,top)
            //        self.presentViewController(uiv , animated: true, completion: nil)
            
            // Note: Should not be necessary but current iOS 8.0 bug requires it.
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
        }
    }
    
    class SearchPickerTitlesViewController:
    TitlesTableViewControllerInternal{
        //SearchMainTableViewController {
        
        var searchController: UISearchController!
        
        // Secondary search results table view.
        var resultsTableController: SCSearchResultsViewController!
        
        
//        @IBAction func importStuff(sender: AnyObject) {
//            return itunesImport()
//        }
        override func preferredStatusBarStyle() -> UIStatusBarStyle {
            return .LightContent
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            resultsTableController = SCSearchResultsViewController()
            
            // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
            
            //resultsTableController.tableView.delegate = self
            
            searchController = UISearchController(searchResultsController: resultsTableController)
            searchController.searchResultsUpdater = self
            searchController.searchBar.frame = CGRect(x:0,y:-12,width:self.view.frame.size.width,height:32)
            //  searchController.searchBar.sizeToFit()
            //tableView!.tableHeaderView = searchController.searchBar
            
            //*
            searchController.delegate = self
            //searchController.dimsBackgroundDuringPresentation = true // default is YES
            //searchController.hidesNavigationBarDuringPresentation = false
            //*
            searchController.searchBar.delegate = self    // so we can monitor text changes + others
        }
        @IBAction func unwindToVC(segue: UIStoryboardSegue) {
            
        }
    }
    
    
    
    
    class SCSearchResultsViewController : UITableViewController {
        struct Constants {
            struct Nib {
                static let name = "IMISearchTableCell"
            }
            
            struct TableViewCell {
                static let identifier = "IMISearchTableCellID"
            }
        }
        // MARK: Properties
        
        var filteredProducts = [SortEntry]()
        
        // MARK: View Life Cycle
        
        override func viewDidLoad() {
            print("IMISearchResultsViewController has \(filteredProducts.count) filtered products")
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            self.navigationItem.title = "Results" // no effect
            self.tableView!.rowHeight = 120.0
            
        }
        
        // MARK:
        
        func configureCell(cell: SCSearchTableViewCell, forProduct product: SortEntry, forIndexPath:NSIndexPath) {
            
            cell.headlineLabel?.text = product.title
            // cell.detailLabel?.text = "\(product.productDesc)  | \(product.imiSKU) | "
            
        }
        // MARK: UITableViewDataSource
        
        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredProducts.count
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.TableViewCell.identifier) as! SCSearchTableViewCell
            
            let product = filteredProducts[indexPath.row]
            configureCell(cell, forProduct: product, forIndexPath:indexPath)
            
            return cell
        }
        
        
        
        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            print("did select")
        }
}


//
//                searchItemsPredicate.append(finalPredicate)
//            }
//
//            // Add this OR predicate to our master AND predicate.
//            let orMatchPredicates = NSCompoundPredicate.orPredicateWithSubpredicates(searchItemsPredicate)
//            andMatchPredicates.append(orMatchPredicates)
//        }
//            // Each searchString creates an OR predicate for: name, productDesc, imiSKU.
//            //
//            // Example if searchItems contains "iphone 599 2007":
//            //      name CONTAINS[c] "iphone"
//            //      name CONTAINS[c] "599", productDesc ==[c] 599, imiSKU ==[c] 599
//            //      name CONTAINS[c] "2007", productDesc ==[c] 2007, imiSKU ==[c] 2007
//            //


//
//            let numberFormatter = NSNumberFormatter()
//            numberFormatter.numberStyle = .NoStyle
//            numberFormatter.formatterBehavior = .BehaviorDefault
//
//            let targetNumber = numberFormatter.numberFromString(searchString)
//            // `searchString` may fail to convert to a number.
//            if targetNumber != nil {
//                // `productDesc` field matching.
//                lhs = NSExpression(forKeyPath: "productDesc")
//                rhs = NSExpression(forConstantValue: targetNumber!)
//                finalPredicate = NSComparisonPredicate( leftExpression: lhs, rightExpression: rhs, modifier: .DirectPredicateModifier, type: .EqualToPredicateOperatorType, options: .CaseInsensitivePredicateOption)
//
//                searchItemsPredicate.append(finalPredicate)
//
//                // `price` field matching.
//                lhs = NSExpression(forKeyPath: "imiSKU")
//                rhs = NSExpression(forConstantValue: targetNumber!)
//                finalPredicate = NSComparisonPredicate( leftExpression: lhs, rightExpression: rhs, modifier: .DirectPredicateModifier, type: .EqualToPredicateOperatorType, options: .CaseInsensitivePredicateOption)


//        if strippedString == "" {
//
//            let filteredResults = productRecs
//            println("no search string so supplying all \(filteredResults.count) product recs")
//
//
//            // Hand over the filtered results to our search results table.
//            let resultsController = searchController.searchResultsController as IMISearchResultsViewController
//            resultsController.filteredProducts = filteredResults
//            resultsController.tableView!.reloadData()
//
//            return
//        }