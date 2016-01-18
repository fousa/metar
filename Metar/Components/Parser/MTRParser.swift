//
//  MTRParser.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Foundation

class MTRParser: NSObject {
    // MARK: - Properties
    
    private var metar: Metar
    
    static var ICAO: NSDictionary? = {
        if let path = NSBundle.mainBundle().pathForResource("ICAO", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        return nil
    }()
    
    static var countryNames: [String:String] = {
        let countryCodes = NSLocale.ISOCountryCodes()
        
        var countries = [String:String]()
        for countryCode in countryCodes {
            let identifier = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode:countryCode])
            let countryName = NSLocale.currentLocale().displayNameForKey(NSLocaleIdentifier, value: identifier)
            countries[countryCode] = countryName
        }
        return countries
    }()
    
    // MARK: - Init
    
    init(metar: Metar) {
        self.metar = metar
    }
    
    // MARK: - Parsing
    
    func parse() -> Metar? {
        parseCommonData()
        parseStationData()
        parsePressureData()
        parseVisibilityData()
        parseTemperatureData()
        parseCloudData()
        parseRunwayData()
        parseWindData()
        
        return metar
    }
    
    private func parseCommonData() {
        metar.observationTime = match(pattern: "\\s\\d{6}Z")?.formatDate()
        metar.noSignificantChange = match(pattern: "\\sNOSIG") != nil
    }
    
    // MARK: - Name
    
    private func parseStationData() {
        metar.station.site = MTRParser.ICAO?[metar.station.name!]?["name"] as? String
        
        if let countryName = MTRParser.ICAO?[metar.station.name!]?["country"] as? String {
            metar.station.country = MTRParser.countryNames[countryName.uppercaseString]
        }
    }
    
    // MARK: - Pressure
    
    private func parsePressureData() {
        if let pressureString = match(pattern: "\\s(Q|A)\\d{4}") {
            metar.pressure = Pressure()
            metar.pressure?.unit = Pressure.PressureUnit(rawValue: String(pressureString.substring(0, length: 1)!))
            if let value = pressureString.substring(1, length: 4)?.integerValue {
                if let unit = metar.pressure?.unit where unit == .Pascal {
                    metar.pressure?.value = Float(value)
                } else {
                    metar.pressure?.value = Float(value) / 100.0
                }
            }
        }
    }
    
    // MARK: - Visibility
    
    private func parseVisibilityData() {
        metar.visibility = Visibility(cavok: match(pattern: "\\sCAVOK") != nil)
        if metar.visibility!.cavok {
            return
        }
        
        if let visibilityString = match(pattern: "\\s\\d{4}\\s") {
            metar.visibility?.value = visibilityString
            metar.visibility?.unit = .Meters
        } else if let visibilityString = match(pattern: "\\s[^\\s.]+SM") {
            metar.visibility?.value = visibilityString
            metar.visibility?.unit = .Miles
        }
    }
    
    // MARK: - Temperature
    
    private func parseTemperatureData() {
        if let temperatureString = match(pattern: "(\\sM?\\d{2})/(M?\\d{2})") {
            if let values = matchMultiple(pattern: "M?\\d{2}", string: temperatureString) where values.count == 2 {
                metar.temperature = parseTemperature(values.first!)
                metar.dewpoint = parseTemperature(values.last!)
            }
        }
    }
    
    private func parseTemperature(temperatureString: String = "0") -> Int {
        if temperatureString.characters.contains("M") {
            return -(temperatureString.substring(1, length: 2)?.integerValue ?? 0)
        } else {
            return (temperatureString as NSString).integerValue
        }
    }
    
    // MARK: - Clouds
    
    private func parseCloudData() {
        let coverages = Cloud.CloudCoverage.allValues() as NSArray
        let regexCoverages = coverages.componentsJoinedByString("|")
        if let values = matchMultiple(pattern: "(\(regexCoverages))\\d{3}\\s") {
            for value in values {
                var cloud = Cloud()
                cloud.coverage = Cloud.CloudCoverage(rawValue: value.substring(0, length: value.characters.count - 3) as! String)
                cloud.base = (value.substring(value.characters.count - 3, length: 3)?.integerValue ?? 0) * 100
                metar.clouds.append(cloud)
            }
        }
    }
    
    // MARK: - Runways
    
    private func parseRunwayData() {
        let trends = Runway.RunwayTrend.allValues() as NSArray
        let regexTrends = trends.componentsJoinedByString("|")
        if let values = matchMultiple(pattern: "R\\d{2}(\\w)?/P\\d{4}(\(regexTrends))?") {
            for value in values {
                var runway = Runway()
                let name = match(pattern: "R\\d{2}(\\w)?", string: value)!
                runway.name = String(name.substring(1, length: name.characters.count - 1)!)
                let visualRange = match(pattern: "/P\\d{4}", string: value)!
                runway.visualRange = visualRange.substring(2, length: visualRange.characters.count - 2)!.integerValue
                if let trend = match(pattern: "(\(regexTrends))$", string: value) {
                    runway.trend = Runway.RunwayTrend(rawValue: trend)!
                }
                metar.runways.append(runway)
            }
        }
    }
    
    // MARK: - Wind
    
    private func parseWindData() {
        let units = Wind.WindUnit.allValues() as NSArray
        let regexUnits = units.componentsJoinedByString("|")
        if let windString = match(pattern: "(VRB)?(\\d{3})?(\\d{2,3})(G\\d{2})?(\(regexUnits))") {
            metar.wind = Wind()
            if let speedUnit = match(pattern: "(\(regexUnits))$", string: windString) {
                metar.wind?.unit = Wind.WindUnit(rawValue: speedUnit)
                if let gusts = match(pattern: "(G\\d{2})\(speedUnit)$", string: windString) {
                    let gustSpeed = match(pattern: "G\\d{2}", string: gusts)
                    metar.wind?.gustSpeed = gustSpeed?.substring(1, length: 2)?.integerValue
                }
                if let direction = match(pattern: "^\\d{3}", string: windString) {
                    metar.wind?.direction = (direction as NSString).integerValue
                    if let speed = match(pattern: "^\(direction)\\d{2,3}", string: windString) {
                        metar.wind?.speed = speed.substring(3, length: speed.characters.count - 3)?.integerValue
                    }
                }
            }
            
            if let variableString = match(pattern: "\\s\\d{3}V\\d{3}") {
                metar.wind?.varying = true
                metar.wind?.minimumDirection = (match(pattern: "^\\d{3}", string: variableString) as NSString?)?.integerValue
                metar.wind?.maximumDirection = (match(pattern: "\\d{3}$", string: variableString) as NSString?)?.integerValue
            }
        }
    }
    
    // MARK: - Utilities
    
    private func match(pattern pattern: String, string: String? = nil) -> String? {
        return (matchedString(string) =~ pattern).items.first?.trim()
    }
    
    private func matchMultiple(pattern pattern: String, string: String? = nil) -> [String]? {
        return (matchedString(string) =~ pattern).items.map { $0.trim() }
    }
    
    private func matchedString(string: String? = nil) -> String {
        if let string = string {
            return string
        } else {
            return metar.raw
        }
    }
}