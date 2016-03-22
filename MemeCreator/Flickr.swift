//
//  Flickr.swift
//  MemeCreator
//
//  Created by new on 3/16/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

//
//  Flickr.swift
//  VirtualTouristCoreData2.0
//
//  Created by new on 10/20/15.
//  Copyright © 2015 Avi Pogrow. All rights reserved.
//

import Foundation
import UIKit
import CoreData


//to allow user to input phrase and fetch flickr images
class Flickr: NSObject {
	
  let apiKey = "fec2dca93ec5de19700fdd361f147f41"
	
	//user will enter a phrase instead of location
	var searchPhrase:String?
	var pageToFetch:Int?
	
	
  	typealias CompletionHandler = (result: AnyObject!, error: NSError?) -> Void
  
  	var session:NSURLSession
  
	var sharedContext: NSManagedObjectContext {
	 return CoreDataStackManager.sharedInstance().managedObjectContext
	 }
	
	override init() {
        session = NSURLSession.sharedSession()
		
		super.init()
		
		}
	func newFlickrSearchURLForSearchPhrase(searchPhrase:String) -> NSURL {
	
		pageToFetch = pageToFetch! + 1
		
		print("the value for flickrPageToFetch is \(self.pageToFetch!)")
	
		let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="
		//(apiKey)&lat=\(latitude!)&lon=\(longitude!)&page=\(self.pageToFetch!)&per_page=20&extras=url_m&format=json&nojsoncallback=1"
		return NSURL(string:URLString)!
  	}
	
	func newSearchFlickrForPhotosByLatLon(completionHandler:CompletionHandler ) -> NSURLSessionDataTask {
		
		 let url =  newFlickrSearchURLForSearchPhrase(searchPhrase!)
		 let request = NSURLRequest(URL: url)
		
		let task = session.dataTaskWithRequest(request) {data, response, downloadError in
			
		
 		if let error = downloadError  {
                print("Could not complete the request \(error)")
            } else {
			
			
		 print("Step 3 - taskForResource's completionHandler is invoked.")
		
		Flickr.parseJSONWithCompletionHandler(data!, completionHandler: completionHandler)
			}
		}
	task.resume()
	return task
	}
	
	
	//Mark - Task for downloading images
	
	func taskForImage(flickrImageURL:String, completionHandler: (imageData: NSData?, error: NSError?) -> Void) -> NSURLSessionDataTask {
		 let url = NSURL(string: flickrImageURL)!
		 let request = NSURLRequest(URL:url)
		
		 let task = session.dataTaskWithRequest(request) {data, response, downloadError in
			if let error = downloadError {
			print("could not complete request \(error)")
			completionHandler(imageData: nil, error: error)
			
		  } else {
		   completionHandler(imageData: data, error: nil)
		
			}
		}
		
			task.resume()
		
			return task
	}
	class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHandler) {
        var parsingError: NSError? = nil
        
        let JSONResult: AnyObject?
        do {
            JSONResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch let error as NSError {
            parsingError = error
            JSONResult = nil
        }
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            print("Step 4 - parseJSONWithCompletionHandler is invoked.")
            completionHandler(result: JSONResult, error: nil)
			
		}
	}
}
	













  