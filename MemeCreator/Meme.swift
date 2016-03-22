//
//  Meme.swift
//  MemeCreator
//
//  Created by new on 2/22/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

class Meme: NSManagedObject {
	
	
	
	
	
	//keep track if meme object has a compositeImage associated with it
	var hasCompositeImage: Bool {
		return compositeImageID != nil
	}
	
	//Get location to store memed image in docs directory
	var compositeImagePath: String {
		assert(compositeImageID != nil, "No photo ID set")
	
		
		let fileName = "Photo-\(compositeImageID!).jpg"
		return (applicationDocumentsDirectory as NSString)
							.stringByAppendingPathComponent(fileName)
	}
	
	// fetch the image from the docs directory
	//return the composite image by loading the image file
	// this allows us to display photos for existing meme objects
	var fetchCompositeImage: UIImage? {
		return UIImage(contentsOfFile: compositeImagePath)
	
	}
	
	
	class func nextImageID() ->  Int {
	 let userDefaults = NSUserDefaults.standardUserDefaults()
	 let currentID = userDefaults.integerForKey("compositeImageID")
	 userDefaults.setInteger(currentID + 1, forKey: "compositeImageID")
	 userDefaults.synchronize()
	 return currentID
	
	}
	
  func removePhotoFile() {
    if hasCompositeImage {
      let path = compositeImagePath
      let fileManager = NSFileManager.defaultManager()
      if fileManager.fileExistsAtPath(path) {
        do {
          try fileManager.removeItemAtPath(path)
        } catch {
          print("Error removing file: \(error)")
        }
      }
    }
  }
}

	
/* var memeImageCache = MemeImageCache()
	
	get {
            return memeImageCache.imageWithIdentifier(memedImagePath)
        }
        
        set {
            memeImageCache.storeImage(memedImage, withIdentifier: memedImagePath)
        }
    }
}



*/

