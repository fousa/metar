//
//  Pressure.swift
//  METAR
//
//  Created by Jelle Vandenbeeck on 13/05/15.
//  Copyright (c) 2015 Jelle Vandenbeeck. All rights reserved.
//

import Foundation

struct Pressure {
    enum PressureUnit: String {
        case Pascal =  "Q"
        case Mercury = "A"
        
        func format() -> String {
            switch self {
            case Pascal: return "hPa"
            case Mercury: return "inHg"
            }
        }
        
    }
    
    var value: Float?
    var unit: PressureUnit?
}