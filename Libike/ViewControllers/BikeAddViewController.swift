//
//  BikeAddViewController.swift
//  Libike
//
//  Created by Clément Vion on 19/12/2017.
//  Copyright © 2017 clementvion. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation

class BikeAddViewController: UIViewController {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPrice: UITextField!
    @IBOutlet weak var textFieldDescription: UITextField!
    @IBOutlet weak var labelSuccessMessage: UILabel!
    
    var refBikes: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refBikes = Database.database().reference().child("bikes")
    }
    
    @IBAction func tapedOnButtonAdd(_ sender: Any) {
        addBike()
    }
    
    func addBike() {
        let key = refBikes.childByAutoId().key
       
        geoCodeAddress { (coordinate) in
            let bike = ["id": key,
                        "name": self.textFieldName.text! as String,
                        "price": (self.textFieldPrice.text! as NSString).floatValue,
                        "description": self.textFieldDescription.text! as String,
                        "latitude": coordinate.latitude as CLLocationDegrees,
                        "longitude": coordinate.longitude as CLLocationDegrees] as [String : Any]
            
            self.refBikes.child(key).setValue(bike)
            
            self.labelSuccessMessage.text = "Votre vélo a été ajouté !"
        }
        
    }
    
    func geoCodeAddress(completion: @escaping (_ value:CLLocationCoordinate2D) ->()) {
        let address = textFieldAddress.text
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                self.labelSuccessMessage.text = "L'adresse entrée n'a pas été trouvée."
                return
            }
            completion(location.coordinate)
        }
    }

}
