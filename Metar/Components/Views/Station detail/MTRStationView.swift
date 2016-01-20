//
//  MTRStationView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MTRStationView: UIView {
    
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

    func configure(viewModel: MTRStationViewModel, currentLocation: CLLocation?) {
        // Station data
        stationNameLabel.text = viewModel.stationName?.uppercaseString
        stationSiteLabel.text = viewModel.stationSite?.uppercaseString ?? viewModel.stationName?.uppercaseString
        stationCountryLabel.text = viewModel.stationCountry?.uppercaseString
        
        // Elevation data
        if let elevation = viewModel.stationElevation {
            heightValueLabel.text = String(elevation)
        } else {
            heightValueLabel.text = "--"
        }
        heightUnitLabel.text = NSLocalizedString("metar_unit_feet", comment: "").uppercaseString
        
        // Location data
        if let currentLocation = currentLocation, let location = viewModel.stationLocation {
            let distance = currentLocation.distanceFromLocation(location)
            let (value, unit) = MTRDistanceFormatter.formattedComponents(distance: distance)
            distanceValueLabel.text = value
            distanceUnitLabel.text = unit?.uppercaseString
        } else {
            distanceValueLabel.text = "--"
            distanceUnitLabel.text = "KM"
        }
        
        // Temperature data
        if let temperature = viewModel.temperature {
            temperatureValueLabel.text = "\(temperature)°"
        } else {
            temperatureValueLabel.text = "--"
        }
        temperatureUnitLabel.text = NSLocalizedString("metar_unit_celsius", comment: "").uppercaseString
    }
    
}