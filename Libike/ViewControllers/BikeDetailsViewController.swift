//
//  BikeDetailsViewController.swift
//  Libike
//
//  Created by Clément Vion on 18/12/2017.
//  Copyright © 2017 clementvion. All rights reserved.
//

import UIKit

class BikeDetailsViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    
    var bike: Bike!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.text = bike.name
        
        // Do any additional setup after loading the view.
    }

}
