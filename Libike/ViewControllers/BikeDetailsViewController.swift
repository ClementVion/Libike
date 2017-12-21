//
//  BikeDetailsViewController.swift
//  Libike
//
//  Created by Clément Vion on 18/12/2017.
//  Copyright © 2017 clementvion. All rights reserved.
//

import UIKit
import Firebase


class BikeDetailsViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var bike: Bike!
    var reservation: Reservation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getImage(bike.imageURL, imageView)
        
        labelTitle.text = bike.name
        labelPrice.text = "\(bike.price.description)€"
        textDescription.text = bike.description
        
        print("/////////////////////////////////BIKE////////////////////////////////")
        Analytics.logEvent("bike", parameters: [
            "bike_price": self.bike.price as NSObject,
            "bike_name": self.bike.name as NSObject,
            "bike_location": "\(self.bike.latitude),\(self.bike.longitude)" as NSString,
        ])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showReservation" {
            
            let destination = segue.destination
            if let reservationController = destination as? ReservationViewController {
                
                let date = datePicker.date
                let currentDate = Date()
                
                print("DATE : \(currentDate)")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                
                reservation = Reservation(withTheBikeName: bike.name, andAtTheDate: date)
                
                reservationController.reservation = reservation
                
                Analytics.logEvent("booking", parameters: [
                    "booking_date": "\(formatter.string(for: date))" as NSString,
                    "booking_actual_date": "\(formatter.string(for: currentDate))" as NSString,
                ])
                
                Analytics.setUserProperty(formatter.string(for: currentDate), forName: "average_day_booking")
                
                formatter.dateFormat = "h:m"
                Analytics.setUserProperty(formatter.string(for: currentDate), forName: "average_hour_booking")
                
            }
            
        }
    }
    
    // Sample code from : https://www.youtube.com/watch?v=Z6D68MMx2pw
    func getImage(_ url_str:String, _ imageView:UIImageView) {
        let url:URL = URL(string: url_str)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if data != nil {
                let image = UIImage(data: data!)
                if(image != nil) {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                        imageView.alpha = 0
                        
                        UIView.animate(withDuration: 1, animations: {
                            imageView.alpha = 1.0
                        })
                    })
                }
            }
        })
        task.resume()
    }

}
