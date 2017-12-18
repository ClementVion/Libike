//
//  Bike.swift
//  Libike
//
//  Created by Clément Vion on 18/12/2017.
//  Copyright © 2017 clementvion. All rights reserved.
//

import Foundation

class Bike {
    let name: String
    let longitude: Double
    let latitude: Double
    
    init(withTheName newName: String, andALatitudeOf newLatitude: Double, andALongitudeOf newLongitude: Double) {
        self.name = newName
        self.longitude = newLongitude
        self.latitude = newLatitude
    }
}

