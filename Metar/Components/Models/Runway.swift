//
//  Runway.swift
//  METAR
//
//  Created by Jelle Vandenbeeck on 13/05/15.
//  Copyright (c) 2015 Jelle Vandenbeeck. All rights reserved.
//

import Foundation

struct Runway {
    enum RunwayTrend: String {
        case Upward = "U"
        case Downward = "D"
        case NoChange = "N"
        
        static func allValues() -> [String] {
            return [
                RunwayTrend.Upward.rawValue,
                RunwayTrend.Downward.rawValue,
                RunwayTrend.NoChange.rawValue
            ]
        }
        
        func format() -> String {
            switch self {
            case Upward: return "UPWARD"
            case Downward: return "DOWNWARD"
            default: return "NO CHANGE"
            }
        }
    }
    
    var name: String?
    var visualRange: Int?
    var trend: RunwayTrend = .NoChange
}