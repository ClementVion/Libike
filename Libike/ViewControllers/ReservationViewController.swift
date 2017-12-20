//
//  ReservationViewController.swift
//  Libike
//
//  Created by Clément Vion on 20/12/2017.
//  Copyright © 2017 clementvion. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {
    
    @IBOutlet weak var labelBikeName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    var reservation: Reservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        labelBikeName.text = reservation.bikeName
        labelDate.text = formatter.string(for: reservation.date)
    }

}
