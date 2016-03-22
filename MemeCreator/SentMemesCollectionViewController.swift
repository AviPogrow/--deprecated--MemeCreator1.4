//
//  SentMemesCollectionViewController.swift
//  MemeCreator
//
//  Created by new on 2/22/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

class SentMemesCollectionViewController: UIViewController,
 		UICollectionViewDelegate,UICollectionViewDataSource,  NSFetchedResultsControllerDelegate  {
	
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var deleteButton: UIBarButtonItem!
	
	//this holds an array of indexPaths that the user has tapped to highlight
	// for deletion
	var selectedIndexes = [NSIndexPath]()
	
	
	//Core Data: This is our interface to the core data store
	// and the fetchedResultsController
	lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
        }()
	//Core Data Save support
	func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
	
	override func viewDidLoad() {
        super.viewDidLoad()
	
		/*
		var rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "NewCollection",
	 			style: UIBarButtonItemStyle.Plain, target: self, action: "newCollection:")
		
		self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
		*/
		// Step 2: Perform the fetch
        do {
			//the fetchedResultsController is configured to get and array of photos
			// for the current location object
			try fetchedResultsController.performFetch()
        } catch {}
		
		//Set the delegate to this view controller
        fetchedResultsController.delegate = self
		
		//The delete button will adapt based on if there are cells highlighted for
		// deletion
		updateDeleteButton()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.collectionView.reloadData()
	}
	
	func performFetch() {
		
	 	do {
			 try fetchedResultsController.performFetch()
		} catch let error as NSError {
		 print("Error in fetchAllActors(): \(error)")
		
		}
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
	}
	/*
	override func viewDidLayoutSubviews() {
		 // Lay out the collection view so that cells take up 1/3 of the width,
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let width = floor(collectionView!.frame.size.width/3) - 1
        layout.itemSize = CGSize(width: width, height: width)
        collectionView!.collectionViewLayout = layout
		
	}*/
	
	//if no cells are selected the delete button is disabled
	func updateDeleteButton() {
        if selectedIndexes.count > 0 {
            deleteButton.enabled = true
        } else {
            deleteButton.enabled = false 
        }
	}
	
 	@IBAction func deleteSelectedPhotos(sender: AnyObject) {
		
		//create empty array of memes To be deleted
		var memesToDelete = [Meme]()
	
		//iterate through the selectedIndex index values and append each one
		// to the photosToDelete array
		for indexPath in selectedIndexes {
            memesToDelete.append(fetchedResultsController.objectAtIndexPath(indexPath) as! Meme)
        }
		//iterate through the memesToDelete array
		for meme in memesToDelete {
			
			//1 remove the meme composite image from the application directory
			meme.prepareForDeletion()
			
			//2 remove the other meme properties from the fetchedResultsController
			self.sharedContext.deleteObject(meme)
			updateDeleteButton()
		}
			 selectedIndexes = [NSIndexPath]()
		
			//save the changes(deletions)
			dispatch_async(dispatch_get_main_queue()) {
            CoreDataStackManager.sharedInstance().saveContext()
        }
		
	}
	// MARK: - UICollectionView Data Source and Delegate Methods
    
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		
		//ternary operator says "give me the count.. and if nil then give me 0"
		
		print("number of section func invoked")
		return self.fetchedResultsController.sections?.count ?? 0
    }
	
	//2 Data Source delegate methods of collection view 
	//a. telling it how many items
	
	func collectionView(collectionView: UICollectionView,
		numberOfItemsInSection section: Int) -> Int {
		
		let sectionInfo = self.fetchedResultsController.sections![section]
        
		//the sectionInfo has a property "number of objects"
		return sectionInfo.numberOfObjects
    }
	
	//b. cell for each item
	func collectionView(collectionView: UICollectionView,
						cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
	
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
						"CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
	
		//cell.activityView.startAnimating()
		//use the meme object to set the various view objects in the tableView cell
		let meme = fetchedResultsController.objectAtIndexPath(indexPath) as!
							Meme
		//set the image
		//cell.memedImageView.image = meme.fetchCompositeImage
		
		cell.memedImageView.image = UIImage(named: meme.imageName!)    
		return cell
    }

	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CustomMemeCell
        
        // Whenever a cell is tapped we do two operations
		//1. will toggle its presence
		//  in the selectedIndexes array
		
		if let index = selectedIndexes.indexOf(indexPath) {
            selectedIndexes.removeAtIndex(index)
        } else {
            selectedIndexes.append(indexPath)
        }
		//2. call a method to toggle the transparency of the cell
		//configureCell(cell, atIndexPath: indexPath)
		
		
		//use the meme object to set the various view objects in the tableView cell
		let meme = fetchedResultsController.objectAtIndexPath(indexPath) as!
							Meme
		cell.memedImageView!.image = meme.fetchCompositeImage
		  
		if let _ = self.selectedIndexes.indexOf(indexPath) {
            cell.memedImageView!.alpha = 0.5
        } else {
            cell.memedImageView!.alpha = 1.0
        }
		//TODO: update the bottom button
		updateDeleteButton()
	}
		
		
/*************NSFetchedResultsController init and delegatem methods************************/
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest:
		fetchRequest, managedObjectContext: self.sharedContext,
		sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

	//when view controller is dealocatted we unhook the delegate
	deinit {
    	fetchedResultsController.delegate = nil
  	}


	//NSFetchedResultsController Delegate methods for UICollectionView
	//set the three empty arrays that will store the indexPath that need to be modified
	var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
	
	
	//1
	  func controllerWillChangeContent(controller: NSFetchedResultsController) {
        // We are about to handle some new changes. Start out with empty arrays for each change type
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
        
		
		print("controller will change content invoked")
		}
	//2
	func controller(controller: NSFetchedResultsController,
		didChangeObject anObject: AnyObject,
		atIndexPath indexPath: NSIndexPath?,
		forChangeType type: NSFetchedResultsChangeType,
	 	newIndexPath: NSIndexPath?) {
        
		switch type{
            
		case .Insert:
			insertedIndexPaths.append(newIndexPath!)
            break
        case .Delete:
            deletedIndexPaths.append(indexPath!)
            break
        case .Update:
            updatedIndexPaths.append(indexPath!)
            break
        case .Move:
            break
		
        }
    }
	
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
		print("in controllerDidChangeContent. changes.count: \(insertedIndexPaths.count + deletedIndexPaths.count)")
        
        collectionView!.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.collectionView!.insertItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView!.deleteItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.collectionView!.reloadItemsAtIndexPaths([indexPath])
            }
            
            }, completion: nil)
	
			updateDeleteButton()
    	}
	}











