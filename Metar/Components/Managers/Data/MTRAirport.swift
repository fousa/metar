//
//  MTRAirport.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 19/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import CoreData
import CoreLocation

@objc(MTRAirport)
class MTRAirport: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var country: String?
    @NSManaged var site: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var elevation: NSNumber?
    @NSManaged var rawMetarData: String?

    var location: CLLocation? {
        if let latitude = latitude?.doubleValue, let longitude = longitude?.doubleValue where latitude != 0.0 && longitude != 0.0 {
            if let elevation = elevation?.doubleValue {
                return CLLocation(coordinate: CLLocationCoordinate2DMake(latitude, longitude), altitude: elevation, horizontalAccuracy: 1.0, verticalAccuracy: 1.0, timestamp: NSDate())
            } else {
                return CLLocation(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }

    // MARK: - Parser

    func update(fromMetar metar: Metar) {
        site = metar.station.site
        country = metar.station.country
        elevation = metar.station.location?.altitude
        latitude = metar.station.location?.coordinate.latitude
        longitude = metar.station.location?.coordinate.longitude
        rawMetarData = metar.raw
    }

}

extension MTRAirport: MTRStationViewModel {

    var stationName: String? {
        return name
    }

    var stationSite: String? {
        return site
    }

    var stationCountry: String? {
        return country
    }

    var stationLocation: CLLocation? {
        return location
    }

    var stationElevation: Int? {
        return elevation?.integerValue
    }

    var temperature: Int? {
        return 0
    }
    
}