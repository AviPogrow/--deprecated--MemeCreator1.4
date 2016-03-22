//
// MeMeEditorViewController.swift
//  DataModel1
//
//  Created by new on 5/11/15.
//  Copyright (c) 2015 Avi Pogrow. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

class MemeEditorViewController: UIViewController, UITextFieldDelegate  {


@IBOutlet weak var topField: UITextField!

@IBOutlet weak var imageView: UIImageView!

//@IBOutlet weak var shareButton: UIBarButtonItem!

	//this variable stores the compositeImage created by the meme editor
	// of all the views
	var compositeImage:UIImage!
	var memes = [Meme]()

	var image:UIImage!
	
	var soundID: SystemSoundID = 0
	
	 var tapRecognizer: UITapGestureRecognizer? = nil
	
	lazy var sharedContext = {
		CoreDataStackManager.sharedInstance().managedObjectContext
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		//loadSoundEffect("Sound.caf")
		//playSoundEffect()
		
		tapRecognizer = UITapGestureRecognizer(target: self,
											   action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
		
		
		//don't let the user send a meme until they have selected a photo
		//shareButton.enabled = false

		topField.text = "Enter Text Here"
		topField.delegate = self
	
		//bottomField.text = "Bottom"
		//bottomField.delegate = self
		//bottomField.enabled = false
	}
	
	override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		
		
		
		/* Add tap recognizer to dismiss keyboard */
        self.addKeyboardDismissRecognizer()
        
        /* Subscribe to keyboard events so we can adjust the view to show hidden controls */
       // self.subscribeToKeyboardNotifications()
    }
	
	
	override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Remove tap recognizer */
        self.removeKeyboardDismissRecognizer()
        
        /* Unsubscribe to all keyboard events */
        self.unsubscribeToKeyboardNotifications()
    }
	/* ============================================================
    * Functional stubs for handling UI problems
    * ============================================================ */
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
	  func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
	func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
	   func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
	  func keyboardWillShow(notification: NSNotification) {
       // if self.photoImageView.image != nil {
        //    self.defaultLabel.alpha = 0.0
        //}
        self.view.frame.origin.y -= self.getKeyboardHeight(notification) / 2
    }
    
    func keyboardWillHide(notification: NSNotification) {
      //  if self.photoImageView.image == nil {
      //      self.defaultLabel.alpha = 1.0
      //  }
        self.view.frame.origin.y += self.getKeyboardHeight(notification) / 2
    }
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
	
	/*/move the view down when the keyboard is finished
	func keyboardWillHide(notification: NSNotification) {
		
		if bottomField.editing {
		
		//when the main view slides down reveal the toolbar with the addPhoto
		// button
		toolBar.hidden = false
		self.view.frame.origin.y += getKeyboardHeight(notification)
	 } else {
	 	self.view.frame.origin.y = self.view.frame.origin.y
		}
	}
	/**************************************************************/*/

	
	// MARK: - 3 TextField Delegate methods
	//1 This method listens for changes to the text field and asks "Can I make changes?"
	func textField(textField: UITextField,
		shouldChangeCharactersInRange range: NSRange,
									  replacementString string: String) -> Bool {

        // Figure out what the new text will be, if we return true
        var newText: NSString = textField.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        
		// returning true gives the text field permission to change its text
        return true
    }

	//2 This method gets invoked if the user taps the return on the keyboard
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true
	}
 
 	//3 This method gets invoked when the user clicks inside the field
 	//this method clears the field
	func textFieldDidBeginEditing(textField: UITextField) {
		textField.text = ""
 	}
	
	//If the user wants to select an image from the photo album this method gets
	// called and the imagePicker view controller is presented
	@IBAction func pickAnImage(sender: AnyObject) {
		
		pickPhoto()
	}
	
	@IBAction func doneButtonClicked(sender: AnyObject) {
		
		//1 call the method that creates an image by capturing all the views
		self.createMemeObjectAndSave()
		//playSoundEffect()
	}

	//create meme object and add it to memes array
	func createMemeObjectAndSave() {
		
		//take snapshot of all the views (top field, bottom field, photo)
		compositeImage = generateCompositeImage()
		
		let hudView = HudView.hudInView(navigationController!.view, animated: true)
		
		hudView.text = "Updated"
		
		
		
	//*** New User Generated Object created and stored ***********//
		
		//Declare a new instance of the meme model object
		let meme: Meme
		
		//init and insert this meme object into the manageObjectContext
		meme  = NSEntityDescription.insertNewObjectForEntityForName("Meme",
							inManagedObjectContext: sharedContext) as! Meme
		
		
		meme.topField = self.topField.text
		//meme.bottomField = self.bottomField.text
		
		//call this Class function to create a unique id for the composite image
		// that we can use to create the path to store and fetch the image file
		// from
		let id = Meme.nextImageID() + 1
		print("the value of id is \(id)")
		
		// continue setting the instance properties of the meme model object
		// here we set the unique id:Int the picture will be associated with
	
		if let _ = compositeImage {
			
			//set the id property of the meme object 
			// nextImageId func creates a new unique int value using 
			// NSUserDefaults
			// take that int and set the coreData attribute for this meme
			meme.compositeImageID = Meme.nextImageID() + 1
			
			}
		
		//convert the compositeImage into binary data format
		if let data = UIImageJPEGRepresentation(compositeImage, 0.5) {
		 
		 //store the file in the docs directory at the location returned
		 // by the compositeImagePath computed property
		 do {
          try data.writeToFile(meme.compositeImagePath, options: .DataWritingAtomic)
			
			//if something went wrong handle it
			} catch {
          		print("Error writing file: \(error)")
	
		  }
      }
		//The composite image is already stored in docs directory
		// now we need to store the other attributes of the meme object
		// in core data
    	do {
     		 try sharedContext.save()
   			 } catch {
     		 print("core data error")
    	}
		
	afterDelay(1.6) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
		}
		
	func generateCompositeImage() -> UIImage {

		
    	// Render view to an image
    	UIGraphicsBeginImageContext(self.view.frame.size)
    	self.view.drawViewHierarchyInRect(self.view.frame,
    							afterScreenUpdates: true)
	 	let compositeImage: UIImage  =
    		UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()

		
	
		return compositeImage
	}
	

	@IBAction func cancel(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
		//Mark: - networking call
	
	var flickr = Flickr()
	
	
	func getFlickrPhotos() {
		
		//TODO: switch flickr call from location based to phrase based
		//flickr.longitude = location.longitude
		//flickr.latitude = location.latitude
		//flickr.pageToFetch = location.flickrPageToFetch++
		
			dispatch_async(dispatch_get_main_queue()) {
			CoreDataStackManager.sharedInstance().saveContext()
		}
	
		flickr.newSearchFlickrForPhotosByLatLon () { JSONResult, error in
			
			if let error = error {
				
				print(error)
			
			} else {
			
		if let photosDictionary = JSONResult.valueForKey("photos") as? [String:AnyObject] {
		
		if let photosArrayOfDictionaries = photosDictionary["photo"] as? [[String: AnyObject]] {
		
			dispatch_async(dispatch_get_main_queue()) {
		
		//TODO: switch code from location images to phrase image
		/*
		
		let _ = photosArrayOfDictionaries.map() { (dictionary: [String : AnyObject]) -> Photo in
			
			let photo = Photo(dictionary: dictionary, context: self.sharedContext)
			
				photo.location = self.location
			
					
					return photo
				}
		*/
				
				CoreDataStackManager.sharedInstance().saveContext()
				
						}
					}
				}
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/*
	//MARK: - Sound effect
	
	 func loadSoundEffect(name: String){
	 	if let path = NSBundle.mainBundle().pathForResource(name, ofType: nil) {
			let fileURL = NSURL.fileURLWithPath(path, isDirectory: false)
			let error = AudioServicesCreateSystemSoundID(fileURL, &soundID)
			if error !=  kAudioServicesNoError {
				print("Error code \(error) loading sound at path: \(path)")
			}
		}
	}
	func unloadSoundEffect() {
		AudioServicesDisposeSystemSoundID(soundID)
		soundID = 0
	 }
	 func playSoundEffect(){
	 	AudioServicesPlaySystemSound(soundID)
	 }
	*/
	}


extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
/************ Getting an Image for the meme ***************************
This pickPhoto() is called when the user selects the get photo button
// it guides the user through the process of either taking a photo with the camera or 
// from the photo album */

  func pickPhoto() {
    if true || UIImagePickerController.isSourceTypeAvailable(.Camera) {
      showPhotoMenu()
    } else {
      choosePhotoFromLibrary()
    }
  }
	//Present a UIAlertController 
	// with an action sheet offering three choices
	
	//A. Cancel
	func showPhotoMenu() {
    let alertController = UIAlertController(title: nil, message: nil,
									preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    
	//B. take photo with camera
	let takePhotoAction = UIAlertAction(title: "Take Photo",
	style: .Default, handler: { _ in self.takePhotoWithCamera() })
    alertController.addAction(takePhotoAction)
    
	//C. choose photo from library
	let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library",
	 style: .Default, handler: { _ in self.choosePhotoFromLibrary() })
    alertController.addAction(chooseFromLibraryAction)

    presentViewController(alertController, animated: true, completion: nil)
  }
  
  func takePhotoWithCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .Camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .PhotoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }
	
   //MARK: 2 ImagePicker Delegate Methods
	
  //Delegate Method #1
  //take the image the user just generated and set the imageView behind the
  // textFields
  func imagePickerController(picker: UIImagePickerController,
  					didFinishPickingMediaWithInfo info: [String : AnyObject]) {
	
	//extract the image from the media info dictionary
	image = info[UIImagePickerControllerEditedImage] as? UIImage
    
    //check that the image property is not nil
	if let image = image {
	  //populate the UI
	  showImage(image)
    }
}
  func showImage(image: UIImage) {
    imageView.image = image
    imageView.hidden = false
	
	imageView.image = image
	
	//dismiss the imagePicker ViewController to get back to the meme editor
	dismissViewControllerAnimated(true, completion: nil)
	}
	
  //Delegate Method #2
  //this delegate method is invoked by the imagePicker if the user clicks cancel
  // it dismisses the imagePicker to reveal the memeEditor
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}