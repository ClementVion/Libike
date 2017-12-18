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

class BikesViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var map: MKMapView!
    
    let manager = CLLocationManager()
    
    var bikes = ["bike 1", "bike 2", "bike 3", "bike 4", "bike 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add anotation on the map
        let annotation = MKPointAnnotation()
        let annotationLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(48.785478, 2.445296)
        annotation.coordinate = annotationLocation
        annotation.title = "Hello"
        annotation.subtitle = "It's me"
        map.addAnnotation(annotation)

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bikes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BikeCollectionViewCell", for: indexPath) as! BikeCollectionViewCell
        
        cell.label.text = bikes[indexPath.row]
        
        return cell
    }

}
