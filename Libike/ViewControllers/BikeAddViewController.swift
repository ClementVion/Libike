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
    @IBOutlet weak var buttonAddImage: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    
    var refBikes: DatabaseReference!
    
    var imageUploadManager: ImageUploadManager?
    var imageURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refBikes = Database.database().reference().child("bikes")
    }
    
    @IBAction func tapedOnButtonAddImage(_ sender: Any) {
        showImagePicker()
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
                        "imageURL": self.imageURL as String,
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
    
    func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

}

extension BikeAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)
            self.buttonAdd.isEnabled = false
            self.buttonAddImage.isEnabled = false
            
            imageUploadManager = ImageUploadManager()
            imageUploadManager?.uploadImage(image, progressBlock: { (percentage) in
                let intPercentage = Int(percentage)
                self.buttonAddImage.setTitle("Téléchargement de l'image : \(intPercentage) %", for: .normal)
            }, completionBlock: { (fileURL, errorMessage) in
                self.buttonAdd.isEnabled = true
                self.buttonAddImage.isEnabled = true
                self.buttonAddImage.setTitle("Changer d'image", for: .normal)
                self.imageURL = fileURL?.absoluteString
                print("imageURL : \(self.imageURL)")
            })
        }
    }
}
