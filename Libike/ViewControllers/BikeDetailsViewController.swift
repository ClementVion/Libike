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
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    
    var bike: Bike!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.text = bike.name
        labelPrice.text = bike.price.description
        textDescription.text = bike.description
        
    }

}
