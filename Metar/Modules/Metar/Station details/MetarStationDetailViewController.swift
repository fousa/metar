//
//  MetarStationDetailViewController.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MetarStationDetailViewController: UIViewController {
    
    var metarStatioView: MTRStationView! { return self.view as! MTRStationView } // tailor:disable
    
    var metar: Metar!
    
    // MARK: - View flow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metarStatioView.configure(metar: metar, currentLocation: MTRLocationManager.sharedInstance.currentLocation)
    }
    
}