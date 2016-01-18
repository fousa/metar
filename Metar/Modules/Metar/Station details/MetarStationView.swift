//
//  MetarStationView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MetarStationView: UIView {
    
    @IBOutlet var stationNameLabel: UILabel!
    @IBOutlet var stationSiteLabel: UILabel!
    @IBOutlet var stationCountryLabel: UILabel!
    
    @IBOutlet var heightValueLabel: UILabel!
    @IBOutlet var heightUnitLabel: UILabel!
    
    @IBOutlet var distanceContainerView: UIView!
    @IBOutlet var distanceValueLabel: UILabel!
    @IBOutlet var distanceUnitLabel: UILabel!
    
    @IBOutlet var temperatureValueLabel: UILabel!
    @IBOutlet var temperatureUnitLabel: UILabel!
    
    // MARK: - Configure

    func configure(metar metar: Metar, currentLocation: CLLocation?) {
        // Station data
        stationNameLabel.text = metar.station.name?.uppercaseString
        stationSiteLabel.text = metar.station.site?.uppercaseString ?? metar.station.name?.uppercaseString
        stationCountryLabel.text = metar.station.country?.uppercaseString
        
        // Elevation data
        if let elevation = metar.station.elevation {
            heightValueLabel.text = String(elevation)
        } else {
            heightValueLabel.text = "--"
        }
        heightUnitLabel.text = NSLocalizedString("metar_unit_feet", comment: "").uppercaseString
        
        // Location data
        if let currentLocation = currentLocation, let location = metar.station.location {
            distanceContainerView.hidden = false
            
            let distance = currentLocation.distanceFromLocation(location)
            let (value, unit) = MTRDistanceFormatter.formattedComponents(distance: distance)
            distanceValueLabel.text = value
            distanceUnitLabel.text = unit?.uppercaseString
        } else {
            distanceContainerView.hidden = true
        }
        
        // Temperature data
        if let temperature = metar.temperature {
            temperatureValueLabel.text = "\(temperature)°"
        } else {
            temperatureValueLabel.text = "--"
        }
        temperatureUnitLabel.text = NSLocalizedString("metar_unit_celsius", comment: "").uppercaseString
    }
    
}