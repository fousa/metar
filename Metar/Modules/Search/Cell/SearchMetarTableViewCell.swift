//
//  SearchMetarTableViewCell.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SearchMetarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var stationSiteLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceUnitLabel: UILabel!
    
    // MARK: - Configure
    
    func configure(withMetar metar: Metar, currentLocation: CLLocation?) {
        stationNameLabel.text = metar.station.name?.uppercaseString
        stationSiteLabel.text = metar.station.site?.uppercaseString
        
        if let currentLocation = currentLocation, let location = metar.station.location {
            let distance = currentLocation.distanceFromLocation(location)
            let (value, unit) = MTRDistanceFormatter.formattedComponents(distance: distance)
            distanceLabel.text = value
            distanceUnitLabel.text = unit?.uppercaseString
        } else {
            distanceLabel.text = nil
        }
    }
}