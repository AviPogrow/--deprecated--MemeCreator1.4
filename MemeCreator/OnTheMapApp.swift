//
//  InformationPostViewController.swift
//  ApiClient
//
//  Created by new on 8/13/15.
//  Copyright (c) 2015 Avi Pogrow. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

	let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate
											as! AppDelegate
	
	
	@IBOutlet weak var mapView: MKMapView!
	
	@IBOutlet weak var debugTextLabel: UILabel!
	
	@IBOutlet weak var enterLink: UILabel!
	
	@IBOutlet weak var whereAreYouStudying: UILabel!
	
	@IBOutlet weak var mediaURL: UITextField!
	
	@IBOutlet weak var city: UITextField!
	
	@IBOutlet weak var state: UITextField!
	
	@IBOutlet weak var submit: UIButton!
	
	@IBOutlet weak var findOnMap: UIButton!
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	
	var apiClient: OTMAAPIClient!
	var session: NSURLSession!
	
	
	var geoString:String!
	
	let geocoder = CLGeocoder()
	var coordinate:CLLocationCoordinate2D!
	var lastGeocodingError: NSError?
	var placemark:CLPlacemark?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		mapView.delegate = self
		
		session = NSURLSession.sharedSession()
		apiClient = OTMAAPIClient.sharedInstance()
		
		enterLink.hidden = true
		mediaURL.hidden = true
		submit.hidden = true
		debugTextLabel.hidden = true
		
		activityIndicator.alpha = 0.0
		
    }

	@IBAction func postData(sender: AnyObject) {
		self.apiClient.hostViewController = self 
		let userMediaURL = mediaURL.text
		appDelegate.userMediaURL = userMediaURL
		self.apiClient.postStudentDataToParse { (success) in
		
			if success {
			
				self.dismissViewControllerAnimated(true, completion: nil)
			} else {
				
				// if there is an error on the server side this method will get called
				self.showNetworkError()
			}
			
		}
	
	}

	@IBAction func cancelButtonPressed(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func zoomToSpot(sender: AnyObject) {
	
		city.resignFirstResponder()
		state.resignFirstResponder()
		activityIndicator.alpha = 1.0
		activityIndicator.startAnimating()
		
		//Create the CLGeocoder object
		
		let geoCoder = CLGeocoder()
		
		var comma:String = ","
		geoString = "\(city.text)\(comma)\(state.text)"
		
		self.appDelegate.userMapString = geoString
		self.debugTextLabel.hidden = false
		self.debugTextLabel.text = "Geocoding..."
		self.view.alpha = 0.5
		geoCoder.geocodeAddressString(geoString,
		completionHandler: {
		 placemarks, error in
		 
		  if error != nil {
		 
		self.debugTextLabel.hidden = false
		self.debugTextLabel.text = "Geocode failed"
		return
		
		} else if placemarks!.count > 0 { // if placemarks.count is more than zero we know we 
		// we got a result and can move on
			self.activityIndicator.stopAnimating()
			self.activityIndicator.alpha = 0.0
			
			self.debugTextLabel.hidden = false
			self.debugTextLabel.text = "Geo Done"
			
			//The geocoder creates an object of type CLPPlacemark to represent the location data
			
			let placemark = placemarks![0] as! CLPlacemark
			
			
			//We extract the longitude and latitude data from the placemark object and store it
			self.appDelegate.userLongitude = placemark.location!.coordinate.longitude
			self.appDelegate.userLatitude = placemark.location!.coordinate.latitude
			
			// We use the longitude and latitude values and encapsulate them
			// in a CLLocationCoordinate2D object
			self.appDelegate.userCoordinate = CLLocationCoordinate2D(latitude: self.appDelegate.userLatitude!,
			 											longitude: self.appDelegate.userLongitude!)
			
			
			// This creates an annotation object that will put
			// a pin on the user's location that we zoom to
			var annotation = MKPointAnnotation()
            annotation.coordinate = self.appDelegate.userCoordinate!
			
			
			
			
			
			//The mapView uses the CLLocationCoordinate2D object to know where to focus
			//We want the map to show us an area of 5,000 X 5,000 meters around the
			//coordinates so we get a nice perspective of the area
			 let region = MKCoordinateRegionMakeWithDistance(self.appDelegate.userCoordinate!, 5000, 5000)
			
			
			 //This is the method that will zoom to the coordinates
			 self.mapView.setRegion(region, animated: true)
			 self.view.alpha = 1.0
			// and add the pin
			 self.mapView.addAnnotation(annotation)
			 self.enterLink.hidden = false
			 self.mediaURL.hidden = false
			 self.submit.hidden = false
			 
			 self.city.hidden = true
			 self.state.hidden = true
			 self.findOnMap.hidden = true
			 self.whereAreYouStudying.hidden = true
			
			 
			}
		})
		}
	
  func showNetworkError() {
  dispatch_async(dispatch_get_main_queue(),{
      let alert = UIAlertController(
      title: "Whoops...",
      message: "There was an error on the server side.",
      preferredStyle: .Alert)
    
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    
   self.presentViewController(alert, animated: true, completion: nil)
  })
}
}
extension InformationPostViewController  {
 // 1
 	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
	//guard annotation is annotation else {
    //  return nil
   // }
		let identifier = "pin"
		var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
												 as! MKPinAnnotationView!
	//3
	if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
		
		annotationView.canShowCallout = false
		annotationView.enabled = true
	} else {
      annotationView.annotation = annotation
    }
		
		return annotationView
	}
}















