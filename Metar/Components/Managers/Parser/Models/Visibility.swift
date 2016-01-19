//
//  Visibility.swift
//  METAR
//
//  Created by Jelle Vandenbeeck on 13/05/15.
//  Copyright (c) 2015 Jelle Vandenbeeck. All rights reserved.
//

import Foundation

struct Visibility {
    enum VisiblityUnit {
        case Meters
        case Miles
        
        func format() -> String {
            switch self {
            case Meters: return "m"
            case Miles: return "mi"
            }
        }
        
    }
    
    var value: String?
    var unit: VisiblityUnit?
    var cavok: Bool = false
    
    init(cavok: Bool) {
        self.cavok = cavok
    }
    
    // MARK: - Category
    
    var category: MetarCategory? {
        if cavok {
            return .VFR
        } else if let miles = miles() {
            if miles > 5 {
                return .VFR
            } else if miles <= 5 && miles > 3 {
                return .MVFR
            } else if miles <= 3 && miles > 1 {
                return .IFR
            } else {
                return .LIFR
            }
        }
        return nil
    }
    
    private func miles() -> Float? {
        if let value: NSString = value, let unit = unit {
            return unit == .Miles ? value.floatValue : (value.floatValue * 0.000621371)
        }
        return nil
    }

}