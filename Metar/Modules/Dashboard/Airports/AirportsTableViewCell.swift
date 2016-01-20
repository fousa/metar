//
//  AirportsTableViewCell.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AirportsTableViewCell: UITableViewCell {

    @IBOutlet var metarStationView: MTRStationView!

    // MARK: - Configure

    func configure(withAirport airport: MTRAirport, currentLocation: CLLocation?) {
        metarStationView.configure(airport, currentLocation: currentLocation)
    }
    
}