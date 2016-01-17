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

class MetarStationView : UIView {
    
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
    
    // MARK: - Formatter
    
    private static var distanceFormatter: MKDistanceFormatter {
        struct Static {
            static let instance : MKDistanceFormatter = {
                let formatter = MKDistanceFormatter()
                formatter.unitStyle = .Full
                return formatter
            }()
        }
        return Static.instance
    }
    
    // MARK: - Configure

    func configure(metar metar: Metar, currentLocation: CLLocation?) {
        stationNameLabel.text = metar.station.name
        stationSiteLabel.text = metar.station.site
        stationCountryLabel.text = metar.station.country
        
        if let currentLocation = currentLocation, let location = metar.station.location {
            distanceContainerView.hidden = false
            
            let distance = currentLocation.distanceFromLocation(location)
            let formattedDistance = MetarStationView.distanceFormatter.stringFromDistance(distance)
            let components = formattedDistance.characters.split { $0 == " " }.map { String($0) }
            distanceValueLabel.text = components.first
            distanceUnitLabel.text = components.last?.uppercaseString
        } else {
            distanceContainerView.hidden = true
        }
    }
}