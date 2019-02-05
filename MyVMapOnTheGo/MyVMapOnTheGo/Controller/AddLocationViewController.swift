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

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var addLocationIcon: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var findLocationButton: StyledButton!
    @IBOutlet weak var meadiaUrl: UITextField!
    @IBOutlet weak var locationText: UITextField!
    var location: String = ""
    var url: NSURL!
    var coordinate:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showEnterLocation()
    }
    
    
    /*
     * Prepare screen views to step one - "Enter location"
     */
    private func showEnterLocation() {
        location = ""
        coordinate = nil
        findLocationButton.isHidden = false
        finishButton.isHidden = true
        mapView.isHidden = true
    }
    
    /*
     * Prepare screen views to step two - "Enter link"
     */
    private func showSubmitView() {
        addLocationIcon.isHidden = true
        findLocationButton.isHidden = true
        mapView.isHidden = false
        meadiaUrl.isHidden = true
        finishButton.isHidden = false
        // Show map animated
        UIView.animate(withDuration: 0.5, animations: {
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
    
    
    @IBAction func submitLocationClicked(_ sender: Any) {
        // create location for user
        UdacityClient.sharedInstance().getUser(id: UdacityClient.sharedInstance().userId!) { (success, user, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    //ViewManager.shared.hideDefaultView()
                    self.showError(message: error!)
                }
                return
            }
            
            let locationToAdd = StudentInformation(dictionary: [
                "firstName": user!.firstName as AnyObject,
                "lastName": user!.lastName as AnyObject,
                "longitude": Double(self.coordinate!.longitude) as AnyObject,
                "latitude": Double(self.coordinate!.latitude) as AnyObject,
                "mediaURL": self.url as AnyObject,
                "mapString": self.location as AnyObject,
                "uniqueKey": user!.id as AnyObject,
                "objectId": "" as AnyObject,
                ])
            
            ParseClient.sharedInstance().postStudentLocation(location: locationToAdd) { (success, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        //ViewManager.shared.hideDefaultView()
                        print("error occurred adding student location \(String(describing: error))")
                    }
                    return
                }
                // Refresh map and table
                let navigationController = self.presentingViewController as! UINavigationController
                let studentLocationViewController = navigationController.viewControllers.first as! MainController
                studentLocationViewController.refresh(nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func findLocationClicked(_ sender: Any) {
        // ensure location was provided
        guard let location = locationText.text, location != "" else {
            showError(message: "Location is Mandatory")
            return
        }
        self.location = location
        guard let urlAnswer = meadiaUrl.text, urlAnswer != "" else {
            showError(message: "Link is mandatory")
            return
        }
        guard let url = NSURL(string:urlAnswer) ,UIApplication.shared.canOpenURL(url as URL)
            else {
                showError(message: "Invalid link URL specified. Please ensure url starts with \"http://\"")
                return
        }
        self.url = url
        //ViewManager.shared.hideDefaultView()
        // find the co-ordinates to show a preview
        CLGeocoder().geocodeAddressString(location) { (placemark, error) in //ViewManager.shared.hideDefaultView()
            
            guard error == nil else {
                self.showError(message: "Location was not found.")
                return
            }
            self.location = location
            self.url = url
            self.coordinate = placemark?.first!.location!.coordinate
            self.pin(coordinate: self.coordinate!, location: location, mapView: self.mapView)
            self.showSubmitView()
        }
        
    }
   
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    /*
 * Create "pin" on the map with coordinates (preview the mark on map)
 */
private func pin(coordinate: CLLocationCoordinate2D, location: String, mapView: MKMapView) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = location
    annotation.subtitle = self.url.absoluteString
    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    DispatchQueue.main.async {
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
    }
}

}







