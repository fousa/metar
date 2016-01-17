//
//  MetarStationView.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 17/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import UIKit

class MetarStationView : UIView {
    
    @IBOutlet var stationNameLabel: UILabel!
    @IBOutlet var stationSiteLabel: UILabel!
    @IBOutlet var stationCountryLabel: UILabel!
    
    @IBOutlet var heightValueLabel: UILabel!
    @IBOutlet var heightUnitLabel: UILabel!
    
    @IBOutlet var distanceValueLabel: UILabel!
    @IBOutlet var distanceUnitLabel: UILabel!
    
    @IBOutlet var temperatureValueLabel: UILabel!
    @IBOutlet var temperatureUnitLabel: UILabel!

    func configure(metar metar: Metar) {
        stationNameLabel.text = metar.station.name
        stationSiteLabel.text = metar.station.site
        stationCountryLabel.text = metar.station.country
        
    }
}