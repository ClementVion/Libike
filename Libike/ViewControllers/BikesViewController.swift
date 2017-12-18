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

class BikesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    var annotation:AnnotationPin!
    var bikesList = [Bike]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        var bike = Bike(withTheName: "Vélo de qualité", andALatitudeOf: 48.785478, andALongitudeOf: 2.445296)
        self.bikesList.append(bike)
        
        bike = Bike(withTheName: "Vélo de qualité 2", andALatitudeOf: 48.7860525, andALongitudeOf: 2.4438384)
        self.bikesList.append(bike)
        
        // Add anotation on the map
        for bikeItem in bikesList {
            
            let annotationLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(bikeItem.latitude, bikeItem.longitude)
            annotation = AnnotationPin(withTheTitle: bike.name, andTheSubtitle: "test", andCoordinatesOf: annotationLocation, andABike: bikeItem)
            map.addAnnotation(annotation)
        }
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bikeDetails" {
            
            let destination = segue.destination
            if let bikeDetailsController = destination as? BikeDetailsViewController {
                
                bikeDetailsController.bike = (sender as! AnnotationPin).bike
            }
            
        }
    }
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! AnnotationPin
        performSegue(withIdentifier: "bikeDetails", sender: annotation)
    }

}
