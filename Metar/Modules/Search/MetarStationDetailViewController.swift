//
//  MetarStationDetailViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import CoreLocation

class MetarStationDetailViewController: UIViewController {
    
    var metarStatioView: MetarStationView! { return self.view as! MetarStationView }
    
    var metar: Metar!
    
    private var locationManager: CLLocationManager?
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the location manager.
        locationManager = CLLocationManager()
        
        metarStatioView.configure(metar: metar, currentLocation: locationManager!.location)
    }
}
