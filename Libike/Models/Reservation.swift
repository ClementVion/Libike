//
//  Reservation.swift
//  Libike
//
//  Created by Clément Vion on 20/12/2017.
//  Copyright © 2017 clementvion. All rights reserved.
//

import Foundation

class Reservation {
    let bikeName: String
    let date: Date

    
    init(withTheBikeName newBikeName: String, andAtTheDate newDate: Date) {
        self.bikeName = newBikeName
        self.date = newDate
    }
}
