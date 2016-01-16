//
//  MetarXMLParser.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Foundation
import CoreLocation
import Ono
import ObjectiveC

class MetarXMLParser: NSObject {
    
    // MARK: - Properties
    
    private let data: NSData?
    
    // MARK: - Init
    
    init?(data: NSData?) {
        self.data = data
        super.init()
        
        if self.data == nil {
            return nil
        }
    }
    
    // MARK: - Station
    
    func parseMetars(sortByDistanceOnLocation location: CLLocation? = nil) -> [Metar] {
        let document = try? ONOXMLDocument(data: data)
        
        var metars = [Metar]()
        if let document = document, let data = document.rootElement.firstChildWithTag("data") {
            for element in data.childrenWithTag("METAR") {
                if let raw = element.firstChildWithTag("raw_text")?.stringValue() {
                    let metar = Metar(raw: raw)
                    
                    // Parse the station name.
                    metar.station.name = element.firstChildWithTag("station_id")?.stringValue()
                    parseStationDataFromFile(metar: metar)
                    
                    // Parse the station location.
                    if let latitude: NSString = element.firstChildWithTag("latitude")?.stringValue(), let longitude: NSString = element.firstChildWithTag("longitude")?.stringValue() {
                        if let elevation: NSString = element.firstChildWithTag("elevation_m")?.stringValue() {
                            metar.station.location = CLLocation(coordinate: CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue), altitude: elevation.doubleValue, horizontalAccuracy: 1.0, verticalAccuracy: 1.0, timestamp: NSDate())
                        } else {
                            metar.station.location = CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
                        }
                    }
                    
                    // Parse the metar data.
                    MetarParser(metar: metar).parse()
                    
                    metars.append(metar)
                }
            }
        }
        
        if let location = location {
            // When a current location is given we sort the array according to the distance to the current location.
            metars.sortInPlace({ $0.station.location?.distanceFromLocation(location) < $1.station.location?.distanceFromLocation(location) })
        }
        
        return metars
    }
    
    private func parseStationDataFromFile(metar metar: Metar) {
        // Parse sitename.
        metar.station.site = MetarParser.ICAO?[metar.station.name!]?["name"] as? String
        
        // Parse country name
//        if let countryName = MetarParser.ICAO?[metar.station.name!]?["country"] as? String {
//            metar.station.country = MetarParser.countryNames[countryName.uppercaseString]
//        }
    }
}