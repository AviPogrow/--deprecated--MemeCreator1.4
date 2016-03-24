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
	var hasSearched = false


override func viewDidLoad() {
	super.viewDidLoad()
	
	tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
	
	let cellNib = UINib(nibName: "FlickrResultCell", bundle: nil)
	tableView.registerNib(cellNib, forCellReuseIdentifier: "FlickrResultCell")
}


}
//handle user input in search box
extension FlickrSearchViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		
		searchResults = [SearchResult]()
		
		hasSearched = true
		
		if searchBar.text! != "Justin Bieber" {
		
		for i in 0...2 {
		 
		 let searchResult = SearchResult()
		 searchResult.name = String(format: "Fake Result %d for", i)
		 searchResult.artistName = searchBar.text!
		 searchResults.append(searchResult)
		 }
		
	}
	
	tableView.reloadData()
	}
	}

	
	
   //func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
	//return .TopAttached
	//}


extension FlickrSearchViewController: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	
	if !hasSearched {
	 return 0
	
	} else if searchResults.count == 0 {
	 return 1
	} else {
	
	return searchResults.count
	}
	}
}
extension FlickrSearchViewController: UITableViewDelegate {
   func tableView(tableView: UITableView,
					cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
					
   
   let cellIdentifier = "FlickrResultCell"
   
   var cell: UITableViewCell! =
   			tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
																		as! FlickrResultCell
	
	if searchResults.count == 0 {
	 //cell.flickrImageView = UIImage(named:"placeholder")
	 cell.textLabel!.text = "no results"
	 } else {
	
	
	let searchResult = searchResults[indexPath.row]
	cell.textLabel?.text = searchResult.name
	cell.detailTextLabel?.text = searchResult.artistName
   	}
   	return cell

	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	
	
	
	func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		if searchResults.count == 0 {
			return nil
		} else {
		 return indexPath
		}
	}
}








