//
//  AnnotationPin.swift
//  Libike
//
//  Created by Clément Vion on 18/12/2017.
//  Copyright © 2017 clementvion. All rights reserved.
//

import MapKit

class AnnotationPin: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var bike: Bike!
    
    init(withTheTitle newTitle: String, andTheSubtitle newSubtitle: String, andCoordinatesOf newCoordinate: CLLocationCoordinate2D, andABike newBike: Bike) {
        self.title = newTitle
        self.subtitle = newSubtitle
        self.coordinate = newCoordinate
        self.bike = newBike
    }
}
