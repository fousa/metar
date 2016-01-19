//
//  Metar.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Foundation

enum MetarCategory: Int {
    case LIFR = 0
    case IFR
    case MVFR
    case VFR
}

class Metar {
    
    // MARK: - Common
    
    var observationTime: NSDate?
    var raw: String
    var saved: Bool = false
    
    // MARK: - Significant change
    
    var noSignificantChange: Bool = false
    
    // MARK: - Temperature
    
    var temperature: Int?
    var dewpoint: Int?
    
    // MARK: - To many relations
    
    var clouds = [Cloud]()
    var runways = [Runway]()
    
    var lowestCloudBase: Int {
        if clouds.count > 0 {
            let bases = clouds.map { $0.base ?? Int.max }
            return bases.reduce(Int.max, combine: { min($0, $1) }) as Int
        } else {
            return Int.max
        }
    }
    
    // MARK: - Single relations
    
    var station: Station
    var wind: Wind?
    var visibility: Visibility?
    var pressure: Pressure?
    
    // MARK: - Category
    
    var category: String? {
        let cloudCategory = cloudBaseCategory
        if let visibilityCategory = visibility?.category {
            if visibilityCategory == .LIFR || cloudCategory == .LIFR {
                return "LIFR"
            } else if visibilityCategory == .IFR || cloudCategory == .IFR {
                return "IFR"
            } else if visibilityCategory == .MVFR || cloudCategory == .MVFR {
                return "MVFR"
            } else {
                return "VFR"
            }
        }
        return nil
    }
    
    var cloudBaseCategory: MetarCategory {
        if visibility?.cavok ?? false {
            return .VFR
        } else {
            let lowestBase = lowestCloudBase
            if lowestBase > 3000 {
                return .VFR
            } else if lowestBase <= 3000 && lowestBase > 1000 {
                return .MVFR
            } else if lowestBase <= 1000 && lowestBase > 500 {
                return .IFR
            } else {
                return .LIFR
            }
        }
    }
    
    // MARK: - Init
    
    init(raw: String) {
        self.raw = raw
        station = Station()
    }
}