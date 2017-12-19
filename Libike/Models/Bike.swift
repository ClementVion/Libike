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
    let latitude: Double
    let longitude: Double
    let price: Float
    let description: String
    
    init(withTheName newName: String, andALatitudeOf newLatitude: Double, andALongitudeOf newLongitude: Double, andAPriceOf newPrice: Float, andADescription newDescription: String) {
        self.name = newName
        self.latitude = newLatitude
        self.longitude = newLongitude
        self.price = newPrice
        self.description = newDescription
    }
}

