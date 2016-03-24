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
	
	var  cellNib = UINib(nibName: "FlickrResultCell", bundle: nil)
	tableView.registerNib(cellNib, forCellReuseIdentifier: "FlickrResultCell")
	
	cellNib = UINib(nibName: "NothingFoundCell", bundle: nil)
	tableView.registerNib(cellNib, forCellReuseIdentifier: "NothingFoundCell")

	searchBar.becomeFirstResponder()

}


}
//handle user input in search box
extension FlickrSearchViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		
		if !searchBar.text!.isEmpty  {
			searchBar.resignFirstResponder()
		
			hasSearched = true
		
			searchResults = [SearchResult]()
		
			let url = urlWithSearchText(searchBar.text!)
			
		
			if let jsonString = performStoreRequestWithURL(url) {
		 
			if let dictionary = parseJSON(jsonString) {
		 		 print("Dictionary \(dictionary)")
		 
		 		parseDictionary(dictionary)
		 
		 		tableView.reloadData()
		 		return
			}
		}
		
		
		}
		//showNetworkError()
	}
}

   //TODO: fix color of status Bar and position of searchbar
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
					
	
	 print("the number of searchResults is \(searchResults.count)")
	  
	    if searchResults.count == 0 {
	 
	 let cellIdentifier = "NothingFoundCell"
	 
	 var cell: UITableViewCell! =
	 		tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
	 																	as! NothingFoundCell
	 
	 //cell.flickrImageView = UIImage(named:"placeholder")
	 //cell.textLabel!.text = "no results"
	 } else {
	
	
	 let cellIdentifier = "FlickrResultCell"
   
   		var cell: UITableViewCell! =
   			tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
																		as! FlickrResultCell
	
	let searchResult = searchResults[indexPath.row]
	//cell.textLabel?.text = searchResult.name
	//cell.detailTextLabel?.text = searchResult.artistName
	cell.flickrImageView.image = searchResult.artworkURL60
		
	cell.textLabel?.text = searchResult.artistName
	return cell

	}
	
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
extension FlickrSearchViewController {

	func urlWithSearchText(searchText:String) -> NSURL  {
		
		let escapedSearchText =
	searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
		
		
		let urlString = String(format: "https://itunes.apple.com/search?term=%@", escapedSearchText)
		
		let url = NSURL(string: urlString)
		return url!
	
	}
	func performStoreRequestWithURL(url:NSURL) -> String? {
		do {
			return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
			} catch {
				print("Download Error: \(error)")
				return nil
		}
	}
	func parseJSON(jsonString:String) -> [String: AnyObject]? {
		guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
			else { return nil }
		
			do {
				return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
			
			} catch {
				print("JSON Error: \(error)")
				return nil
			}
		}
		func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
		
		let searchResult = SearchResult()
		
		searchResult.name = dictionary["trackName"] as! String
		searchResult.artistName = dictionary["artistName"] as! String
		searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
		searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
		
	    return searchResult
	}
	
	func parseDictionary(dictionary: [String: AnyObject]) {
		//1
		guard let array =  dictionary["results"] as? [AnyObject] else {
			print("Expected results array")
		 
		 return
		 
		}
		
		var searchResults = [SearchResult]()
		
		//2
		for resultDict in array {
		 //3
		 if let resultDict = resultDict as? [String: AnyObject] {
		   //4
			
			var searchResult:SearchResult?
			
		   if let wrapperType = resultDict["wrapperType"] as? String {
		   	 switch wrapperType {
				case "track":
					searchResult = parseTrack(resultDict)
				default:
					break
				}
			}
				
			
			if let result = searchResult {
			  searchResults.append(result)
	  		}
		}

	
	func showNetworkError() {
		let alert = UIAlertController(title: "whoops", message:
				"There was an error reading from the itunes store", preferredStyle: .Alert)
		
		let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
		alert.addAction(action)
		
		presentViewController(alert, animated: true, completion: nil)
			 }
		}
	}
}





