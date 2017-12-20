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
    @IBOutlet weak var imageView: UIImageView!
    
    var bike: Bike!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(bike)
        
        getImage(bike.imageURL, imageView)
        
        labelTitle.text = bike.name
        labelPrice.text = bike.price.description
        textDescription.text = bike.description
        
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
