//
//  Meme.swift
//  MemeCreator
//
//  Created by new on 3/1/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//
import UIKit
import CoreData

extension Meme  {
	
	@NSManaged var topField:String?
	@NSManaged var bottomField:String?
	@NSManaged var compositeImageID: NSNumber?
	@NSManaged var imageName:String?
}