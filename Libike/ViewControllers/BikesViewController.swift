//
//  BikesViewController.swift
//  Libike
//
//  Created by Clément Vion on 18/12/2017.
//  Copyright © 2017 clementvion. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class BikesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    var annotation:AnnotationPin!
    var bikesList = [Bike]()
    
    var refBikes: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        // Get bikes from Firebase
        refBikes = Database.database().reference().child("bikes")
        
        refBikes.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount > 0 {
                self.bikesList.removeAll()
                
                for bikes in snapshot.children.allObjects as![DataSnapshot]{
                    
                    let bikeObject = bikes.value as? [String: AnyObject]
                    let bikeName = bikeObject!["name"]
                    let bikeLatitude = bikeObject!["latitude"]
                    let bikeLongitude = bikeObject!["longitude"]
                    let bikePrice = bikeObject!["price"]
                    let bikeDescription = bikeObject!["description"]
                    
                    let bike = Bike(withTheName: bikeName as! String, andALatitudeOf: bikeLatitude as! Double, andALongitudeOf: bikeLongitude as! Double, andAPriceOf: bikePrice as! Float, andADescription: bikeDescription as! String)
                    
                    self.bikesList.append(bike)
                }
                
                self.initBikesAnnotations()
            }
        })
        
        // Setup to get user location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // Add bikes as annotations on the map
    func initBikesAnnotations() {
        for bikeItem in bikesList {
            
            let annotationLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(bikeItem.latitude, bikeItem.longitude)
            annotation = AnnotationPin(withTheTitle: bikeItem.name, andTheSubtitle: "test", andCoordinatesOf: annotationLocation, andABike: bikeItem)
            map.addAnnotation(annotation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "bikeDetails" {
            
            let destination = segue.destination
            if let bikeDetailsController = destination as? BikeDetailsViewController {
                
                bikeDetailsController.bike = (sender as! AnnotationPin).bike
            }
        
        }
    }
    
    // Get user location on real time
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
    }
    
    // Customize pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        let reuseId = "customAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // Tap on custom pin
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation as! AnnotationPin
        performSegue(withIdentifier: "bikeDetails", sender: annotation)
    }

}
