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
	
	var searchResults = [String]()

override func viewDidLoad() {
	super.viewDidLoad()
	
	tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
}




}

extension FlickrSearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchResults = [String]()
		
		for i in 0...2 {
		 searchResults.append(String(format: "Fake Result %d for %@", i, searchBar.text!))
		}
	
	tableView.reloadData()
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
		cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
	}
	cell.textLabel!.text = searchResults[indexPath.row]
   
   return cell

	}
}








