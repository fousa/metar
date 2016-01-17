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
    
    func configure(withMetar metar: Metar, currentLocation: CLLocation?) {
        stationNameLabel.text = metar.station.name?.uppercaseString
        stationSiteLabel.text = metar.station.site?.uppercaseString
        
        if let currentLocation = currentLocation, let location = metar.station.location {
            let distance = currentLocation.distanceFromLocation(location)
            let formattedDistance = SearchMetarTableViewCell.distanceFormatter.stringFromDistance(distance)
            let components = formattedDistance.characters.split { $0 == " " }.map { String($0) }
            distanceLabel.text = components.first
            distanceUnitLabel.text = components.last?.uppercaseString
        } else {
            distanceLabel.text = nil
        }
    }
}