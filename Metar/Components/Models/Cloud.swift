//
//  Cloud.swift
//  METAR
//
//  Created by Jelle Vandenbeeck on 13/05/15.
//  Copyright (c) 2015 Jelle Vandenbeeck. All rights reserved.
//

import Foundation

struct Cloud {
    enum CloudCoverage: String {
        case SkyClear =            "SKC"
        case NoCloudsBelow12000 =  "CLR"
        case NoSignificantClouds = "NSC"
        case Few =                 "FEW"
        case Scattered =           "SCT"
        case Broken =              "BKN"
        case Overcast =            "OVC"
        case VerticalVisibility =  "VV"
        
        static func allValues() -> [String] {
            return [
                CloudCoverage.SkyClear.rawValue,
                CloudCoverage.NoCloudsBelow12000.rawValue,
                CloudCoverage.NoSignificantClouds.rawValue,
                CloudCoverage.Few.rawValue,
                CloudCoverage.Scattered.rawValue,
                CloudCoverage.Broken.rawValue,
                CloudCoverage.Overcast.rawValue,
                CloudCoverage.VerticalVisibility.rawValue
            ]
        }
        
        func format() -> String {
            switch self {
            case SkyClear:            return "Sky clear"
            case NoCloudsBelow12000:  return "No clouds below 12.000ft"
            case NoSignificantClouds: return "No significant clouds"
            case Few:                 return "Few"
            case Scattered:           return "Scattered"
            case Broken:              return "Broken"
            case Overcast:            return "Overcast"
            case VerticalVisibility:  return "Vertical Visibility"
            }
        }
    }
    
    var base: Int?
    var coverage: CloudCoverage?
}