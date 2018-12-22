//
//  MapTableViewController.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 12/16/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

class MapTableViewController: UITableViewController {
    
    var locations = [Location]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        locations = appDelegate.locations
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTabCell")!
        let location = self.locations[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.imageView?.image = UIImage(named: "icon_pin.png")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let location = locations[(indexPath as NSIndexPath).row]
        if let mediaUrlValue = location.mediaURL as! String?,  mediaUrlValue.isEmpty == false {
           if (verifyUrl(urlString: mediaUrlValue)) {
               app.openURL(URL(string: location.mediaURL)!)
           }
        }
    }
    
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}
