//
//  AppDelegate.swift
//  MemeCreator
//
//  Created by new on 2/22/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	 lazy var  coreDataStackManager = CoreDataStackManager()
	
		  var meme:Meme!
	
	
	//customize color of UI components
	func customizeAppearance() {
		//make nav bar black and its text white
		UINavigationBar.appearance().barTintColor = UIColor.blackColor()
		
		UINavigationBar.appearance().titleTextAttributes = [
						NSForegroundColorAttributeName:  UIColor.whiteColor() ]
		
		
		UITabBar.appearance().barTintColor = UIColor.blackColor()
		
		_ = UIColor(red: 255/255.0, green: 238/255.0,
		blue: 136/255.0, alpha: 1.0)
		
	
	}
	
	func application(application: UIApplication,
			didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		// Override point for customization after application launch.
		customizeAppearance()
		
		importJSONSeedData()
		
		return true
	}
	
	func applicationWillTerminate(application: UIApplication) {
	  self.coreDataStackManager.saveContext()
	}
	
	var  jsonArray:NSArray!
	
  func importJSONSeedDataIfNeeded() {
    
    let fetchRequest = NSFetchRequest(entityName: "Meme")
    var error:NSError? = nil
    
    let count = coreDataStackManager.managedObjectContext
      .countForFetchRequest(fetchRequest, error: &error)
    
    if count == 0 {
      importJSONSeedData()
    }
  }
  
  func importJSONSeedData() {
    let jsonURL = NSBundle.mainBundle().URLForResource("seed", withExtension: "json")
    let jsonData = NSData(contentsOfURL: jsonURL!)
	
    
    do {
       jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: .AllowFragments) as! NSArray
		
		
		
		let entity = NSEntityDescription.entityForName("Meme", inManagedObjectContext: coreDataStackManager.managedObjectContext)
      
		
	
		
	  for jsonDictionary in jsonArray {
        let imageName = jsonDictionary["imageName"] as! String
 		//let wins = jsonDictionary["wins"] as! NSNumber
        
        let meme = Meme(entity: entity!,
          insertIntoManagedObjectContext: coreDataStackManager.managedObjectContext)
		
		  meme.imageName = imageName
        //meme.imageName = imageName
		print("meme is this: \(meme.debugDescription)")
		
      }
      
      coreDataStackManager.saveContext()
		
      
    } catch let error as NSError {
      print("Error importing memes: \(error)")
    }
  }
}
 



