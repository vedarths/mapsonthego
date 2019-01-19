//
//  AddLocationViewController.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 12/22/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import Foundation

import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var answerField: UITextField!
    var location: String = ""
    var coordinate:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showEnterLocation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        answerField.resignFirstResponder()
        
        if searchButton.isHidden == false {
            findLocation(searchButton)
        } else {
            submitLocation(submitButton)
        }
        return true
    }

    /*
     * Prepare screen views to step one - "Enter location"
     */
    private func showEnterLocation() {
        location = ""
        coordinate = nil
        
        questionLbl.text = "Where are you\nstudying today?"
        answerField.text = ""
        answerField.placeholder = "Enter your location here"
        answerField.returnKeyType = .search
        searchButton.isHidden = false
        submitButton.isHidden = true
        mapViewHeight.constant = 0
    }
    
    /*
     * Prepare screen views to step two - "Enter link"
     */
    private func showEnterLink() {
        questionLbl.text = "What is the link\nyou want to share?"
        answerField.text = ""
        answerField.placeholder = "Enter your link here"
        answerField.returnKeyType = .send
        searchButton.isHidden = true
        submitButton.isHidden = false
        
        // Show map animated :)
        UIView.animate(withDuration: 0.5, animations: {
            self.mapViewHeight.constant = self.answerField.frame.size.height / 2
            self.view.layoutIfNeeded()
        })
    }
    
    func showError(message: String, dismissButtonTitle: String = "OK") {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        
        self.present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func findLocation(_ sender: Any) {
        // ensure location was provided
        guard let location = answerField.text, location != "" else {
            showError(message: "Location is Mandatory")
            return
        }
        ViewManager.shared.hideDefaultView()
        // find the co-ordinates to show a preview
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in ViewManager.shared.hideDefaultView()
            
            guard error == nil else {
                self.showError(message: "Location was not found.")
                return
            }
            self.location = location
            self.coordinate = placemark?.first!.location!.coordinate
            self.pin(coordinate: self.coordinate!, location: location, mapView: self.mapView)
            self.showEnterLink()
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func submitLocation(_ sender: Any) {
        //ensure URL was provided & is valid
        guard let urlAnswer = answerField.text, urlAnswer != "" else {
           showError(message: "Link is mandatory")
           return
        }
        ViewManager.shared.hideDefaultView()
        guard let url = NSURL(string:urlAnswer) ,UIApplication.shared.canOpenURL(url as URL)
            else {
                showError(message: "Invalid link URL specified. Please ensure url starts with \"http://\"")
                return
            }
        ViewManager.shared.showView(view: view)
        
        // create location for user
        UdacityClient.sharedInstance().getUser(id: UdacityClient.sharedInstance().userId!) { (success, user, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    ViewManager.shared.hideDefaultView()
                    self.showError(message: error!)
                }
                return
            }
        
        let locationToAdd = Location(dictionary: [
            "firstName": user!.firstName as AnyObject,
            "lastName": user!.lastName as AnyObject,
            "longitude": Double(self.coordinate!.longitude) as AnyObject,
            "latitude": Double(self.coordinate!.latitude) as AnyObject,
            "mediaURL": url as AnyObject,
            "mapString": self.location as AnyObject,
            "uniqueKey": user!.id as AnyObject,
            "objectId": "" as AnyObject,
            ])
        
        ParseClient.sharedInstance().postStudentLocation(location: locationToAdd) { (success, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    ViewManager.shared.hideDefaultView()
                    print("error occurred adding student location \(String(describing: error))")
                    //self.showError(message:  error!)
                }
                return
            }
            }
        }
    }



/*
 * Create "pin" on the map with coordinates (preview the mark on map)
 */
private func pin(coordinate: CLLocationCoordinate2D, location: String, mapView: MKMapView) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = location
    
    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    DispatchQueue.main.async {
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
    }
}

}







