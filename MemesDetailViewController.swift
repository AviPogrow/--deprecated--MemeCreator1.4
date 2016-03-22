//
//  MemesDetailViewController.swift
//  MemeCreator
//
//  Created by new on 2/22/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//


import UIKit
import CoreData

class MemesDetailViewController: UIViewController {
	
	//This collection View Controller has one property for the prototype cell
	@IBOutlet weak var memeDetailImageView: UIImageView!
	
	lazy var sharedContext: NSManagedObjectContext = {
		return CoreDataStackManager.sharedInstance().managedObjectContext
	 }()
	
	//This stores the meme object that was passed from the TableViewController
	
	var  meme:Meme!
	var currentCompositeImage: UIImage!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		currentCompositeImage  = meme.fetchCompositeImage!
		memeDetailImageView.image =  currentCompositeImage
	}
	
	override func viewWillAppear(animated: Bool) {
       	 super.viewWillAppear(animated)
		
	}
	//TODO: add share function that brings up activity view controller
	@IBAction func share(sender: AnyObject) {
	 	print("share pressed")
		
		let image = currentCompositeImage
		let activityViewController = UIActivityViewController(activityItems: [image],
	 														applicationActivities: nil)
	
			//3 this closure completion handler
			// executes when the user exits the activity controller
	
			activityViewController.completionWithItemsHandler =	{
				activity, completed, returned, error in
		
			if completed {
		
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	self.presentViewController(activityViewController,
	 animated: true,
	 completion: nil)
	}
	
	}	

	
	
	
	















	