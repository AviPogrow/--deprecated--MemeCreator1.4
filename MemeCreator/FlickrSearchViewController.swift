//
//  FlickrSearchViewController.swift
//  MemeCreator
//
//  Created by new on 3/17/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit

class FlickrSearchViewController : UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!

	@IBOutlet weak var tableView: UITableView!
	
	var searchResults = [SearchResult]()

override func viewDidLoad() {
	super.viewDidLoad()
	
	tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
}


}
//handle user input in search box
extension FlickrSearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		
		searchResults = [SearchResult]()
		
		for i in 0...2 {
		 
		 let searchResult = SearchResult()
		 searchResult.name = String(format: "Fake Result %d for", i)
		 searchResult.artistName = searchBar.text!
		 searchResults.append(searchResult)
		 
		}
	
	tableView.reloadData()
	}
   func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
	return .TopAttached
	}
}
extension FlickrSearchViewController: UITableViewDataSource {
func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	return searchResults.count
	}
}
extension FlickrSearchViewController: UITableViewDelegate {
   func tableView(tableView: UITableView,
					cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
					
   
   let cellIdentifier = "SearchResultCell"
   
   var cell: UITableViewCell! =
   			tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
	if cell == nil {
		cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
	}
	let searchResult = searchResults[indexPath.row]
	cell.textLabel?.text = searchResult.name
	cell.detailTextLabel?.text = searchResult.artistName
   
   return cell

	}
}








