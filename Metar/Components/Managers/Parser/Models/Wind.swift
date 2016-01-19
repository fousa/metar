//
//  Wind.swift
//  METAR
//
//  Created by Jelle Vandenbeeck on 13/05/15.
//  Copyright (c) 2015 Jelle Vandenbeeck. All rights reserved.
//

import Foundation

struct Wind {
    enum WindUnit: String {
        case Knots = "KT"
        case MetersPerSecond = "MPS"
        case KilometersPerHour = "KPH"
        
        static func allValues() -> [String] {
            return [
                WindUnit.Knots.rawValue,
                WindUnit.MetersPerSecond.rawValue,
                WindUnit.KilometersPerHour.rawValue
            ]
        }
        
        func format() -> String {
            switch self {
            case Knots: return "kt"
            case MetersPerSecond: return "m/s"
            case KilometersPerHour: return "km/h"
            }
        }
        
    }
    
    var speed: Int?
    var unit: WindUnit?
    var gustSpeed: Int?
    
    var varying: Bool = false
    var direction: Int?
    var minimumDirection: Int?
    var maximumDirection: Int?
}