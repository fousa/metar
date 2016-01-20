//
//  MTRStationViewModel.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Foundation
import CoreLocation

protocol MTRStationViewModel {

    var stationName: String? { get }
    var stationSite: String? { get }
    var stationCountry: String? { get }
    var stationLocation: CLLocation? { get }
    var stationElevation: Int? { get }

    var temperature: Int? { get }
    
}