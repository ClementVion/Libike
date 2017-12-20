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
    @IBOutlet weak var buttonAddImage: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    
    var refBikes: DatabaseReference!
    
    var imageUploadManager: ImageUploadManager?
    var imageURL: String!
    
    var bikeModel: Bike!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refBikes = Database.database().reference().child("bikes")
        
        self.hideKeyboardWhenTappedAround()
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
            self.bikeModel = Bike(
                withTheName: self.textFieldName.text! as String,
                andALatitudeOf: coordinate.latitude as CLLocationDegrees,
                andALongitudeOf: coordinate.longitude as CLLocationDegrees,
                andAPriceOf: (self.textFieldPrice.text! as NSString).floatValue,
                andADescription: self.textFieldDescription.text! as String,
                andAnImageURL: self.imageURL as String)
            
            
            let bikeToSend = [
                "id": key,
                "name": self.bikeModel.name,
                "latitude": self.bikeModel.latitude,
                "longitude": self.bikeModel.longitude,
                "price": self.bikeModel.price,
                "description": self.bikeModel.description,
                "imageURL": self.bikeModel.imageURL as String] as [String : Any]
            
            
            self.refBikes.child(key).setValue(bikeToSend)
            
            self.textFieldName.text = ""
            self.textFieldAddress.text = ""
            self.textFieldPrice.text = ""
            self.textFieldDescription.text = ""
            self.buttonAddImage.setTitle("Ajouter une image", for: .normal)
            
            self.performSegue(withIdentifier: "showBikeDetailsFromAdd", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showBikeDetailsFromAdd" {
            
            let destination = segue.destination
            if let bikeDetailsController = destination as? BikeDetailsViewController {
                
                bikeDetailsController.bike = bikeModel
            }
            
        }
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
