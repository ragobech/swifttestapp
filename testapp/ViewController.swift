//
//  ViewController.swift
//  testapp
//
//  Created by Chris Ragobeer on 2016-02-18.
//  Copyright © 2016 Chris Ragobeer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: BaseViewController,MKMapViewDelegate,CLLocationManagerDelegate, SimpleAPIProtocol {

    var venuesList = [VenueModel]()
    var locationManager: CLLocationManager?
    var APIManager = SimpleAPIManager.sharedInstance
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager?.delegate = self
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }

        APIManager.delegate = self;
        self.self.mapView.delegate = self
     
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {
        case .NotDetermined:
            self.locationManager?.requestWhenInUseAuthorization()
            break
        case .AuthorizedWhenInUse:
            self.locationManager?.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            break
        case .AuthorizedAlways:
            self.locationManager?.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            break
        case .Restricted:
            // restricted
            break
        case .Denied:
            // user denied 
            break
   
        }
    }
 
    

    func didReceiveVenues(results: [VenueModel]) {

        self.venuesList = results;
        self.createAnnotationsWithVenues(results)

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

          //  guard let location = locations.last as? CLLocation else { return }
            let location = locations.last
            let center = CLLocationCoordinate2D(latitude:location!.coordinate.latitude,longitude:location!.coordinate.longitude)
            let region  = MKCoordinateRegion(center:center,span:MKCoordinateSpan(latitudeDelta: 0.05,longitudeDelta: 0.05))
            self.mapView.setRegion(region,animated:true)

           APIManager.getFourSquareVenuesRequest(location!)
           self.locationManager?.stopUpdatingLocation()
    }
    
    func createAnnotationsWithVenues(venues: [VenueModel]) {
        
        for ven: VenueModel in venues {
            
            let locationInfo = ven.coordinate
            let lat = locationInfo.coordinate.latitude as CLLocationDegrees
            let lng = locationInfo.coordinate.longitude as CLLocationDegrees
            let coordinate = CLLocationCoordinate2DMake(lat, lng)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = ven.title
            annotation.subtitle = NSLocalizedString("Let's go!", comment: "comment")
            mapView.addAnnotation(annotation)
            
        }
       
        
    }

    func locationManager(manager:CLLocationManager,didFailWithError error: NSError){
        print ("Errors" + error.localizedDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "MyCustomAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let x : VenueModel = self.venuesList.last as VenueModel!
            
            let vImage = UIImageView(image: x.venueImage())
            vImage.frame = CGRectMake(0,0, 30,30)
            
            annotationView?.leftCalloutAccessoryView = vImage
   
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

}





