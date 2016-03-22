//
//  SentMemesTableViewController.swift
//  MemeCreator
//
//  Created by new on 2/22/16.
//  Copyright © 2016 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData

class SentMemesTableViewController: UITableViewController {

	
	var meme:Meme!
	
	lazy var sharedContext = {
		CoreDataStackManager.sharedInstance().managedObjectContext
	
	}()	
	
	override func viewDidLoad() {
        super.viewDidLoad()
	
		navigationItem.leftBarButtonItem = editButtonItem()
		
		tableView.backgroundColor = UIColor.lightGrayColor()
		tableView.separatorColor = UIColor.lightGrayColor()
		tableView.indicatorStyle = .White
		
		
		performFetch()
		
		
		let cellNib = UINib(nibName:
		TableViewCellIdentifiers.MemedImageTableViewCell, bundle: nil)
		
		tableView.registerNib(cellNib, forCellReuseIdentifier:
						TableViewCellIdentifiers.MemedImageTableViewCell)
	
		tableView.rowHeight = 322
	
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	
		//this triggers the tableView to update its contents each time
		// the user touches the tab button
		performFetch()
		tableView.reloadData()
	
	}
	
	func performFetch() {
		
	 	do {
			 try fetchedResultsController.performFetch()
		} catch let error as NSError {
		 print("Error in fetchAllActors(): \(error)")
		
		}
	}
	
	func addMeme(){
	}
	
	
	
	
	
	
	// MARK: - Table view data source
	override func tableView(tableView: UITableView,
						 numberOfRowsInSection section: Int) -> Int {
		let sectionInfo = fetchedResultsController.sections![section]
		return sectionInfo.numberOfObjects
		
    }

	override func tableView(tableView: UITableView,
		 cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(
		TableViewCellIdentifiers.MemedImageTableViewCell,forIndexPath: indexPath) as! MemedImageTableViewCell

		//use the meme object to set the various view objects in the tableView cell
		let meme = fetchedResultsController.objectAtIndexPath(indexPath) as!
							Meme
	
		
		cell.memedImageView.image = UIImage(named: meme.imageName!)
		//cell.memedImageView.image = meme.fetchCompositeImage
		
		return cell
    }
	
	//MARK: - Table view delegate methods
	 override func tableView(tableView: UITableView,
	  commitEditingStyle editingStyle: UITableViewCellEditingStyle,
	  forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
      let meme = fetchedResultsController.objectAtIndexPath(indexPath) as! Meme
      meme.removePhotoFile()
      sharedContext.deleteObject(meme)
      
      do {
        try sharedContext.save()
      } catch {
        print("error saving to context\(error)")
      }
    }
  }

	
	// MARK: - tableView delegate method that detects when a cell has been selected
	override func tableView(tableView: UITableView,
	 	didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		// configure and instantiates the incoming detail view controller
	  	let detailController =
	 		self.storyboard!.instantiateViewControllerWithIdentifier("MemesDetailViewController")
	 													as! MemesDetailViewController
			 detailController.meme = fetchedResultsController.objectAtIndexPath(indexPath) as! Meme
	 		//tell the navigation controller to push the detail VC onto the stack
			navigationController!.pushViewController(detailController, animated: true)
		}
		struct TableViewCellIdentifiers {
			static let MemedImageTableViewCell = "MemedImageTableViewCell"
		}
	
    // MARK: - NSFetchedResultsController
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        fetchRequest.sortDescriptors = []
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest:
		fetchRequest, managedObjectContext: self.sharedContext,
		sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

  deinit {
    fetchedResultsController.delegate = nil
  }
}

extension SentMemesTableViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(controller: NSFetchedResultsController) {
    print("*** controllerWillChangeContent")
    tableView.beginUpdates()
  }
  
  func controller(controller: NSFetchedResultsController,
  didChangeObject anObject: AnyObject, atIndexPath
  indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType,
  newIndexPath: NSIndexPath?) {
    switch type {
    case .Insert:
      print("*** NSFetchedResultsChangeInsert (object)")
      tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
      
    case .Delete:
      print("*** NSFetchedResultsChangeDelete (object)")
      tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
      
    case .Update:
      print("*** NSFetchedResultsChangeUpdate (object)")
      if let _ = tableView.cellForRowAtIndexPath(indexPath!) as? MemedImageTableViewCell {
        _ = controller.objectAtIndexPath(indexPath!) as! Meme
       // cell.configureForLocation(meme)
      }
    case .Move:
      print("*** NSFetchedResultsChangeMove (object)")
      tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
      tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
    }
  }
  
  func controller(controller: NSFetchedResultsController,
  didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
   atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    switch type {
    case .Insert:
      print("*** NSFetchedResultsChangeInsert (section)")
      tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
      
    case .Delete:
      print("*** NSFetchedResultsChangeDelete (section)")
      tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
      
    case .Update:
      print("*** NSFetchedResultsChangeUpdate (section)")
      
    case .Move:
      print("*** NSFetchedResultsChangeMove (section)")
    }
  }
  
  func controllerDidChangeContent(controller: NSFetchedResultsController) {
    print("*** controllerDidChangeContent")
    tableView.endUpdates()
  }
}


	
	
	
	
	







