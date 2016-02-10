//
//  Metar+Formatter.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 10/02/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Foundation

extension Metar {
    
    func formatWindDirection() -> String? {
        guard let direction = wind?.direction else { return nil }
        return "\(direction)°"
    }

    func formatWindSpeed() -> String? {
        guard let speed = wind?.speed, let unit = wind?.unit else { return nil }
        return "\(speed) \(unit.format())"
    }

    func formatGustSpeed() -> String? {
        guard let speed = wind?.gustSpeed, let unit = wind?.unit else { return nil }
        return "\(speed) \(unit.format())"
    }

    func formatVarying() -> String? {
        guard let varying = wind?.varying, let minimumDirection = wind?.minimumDirection, let maximumDirection = wind?.maximumDirection where varying else { return nil }
        return "\(minimumDirection)° - \(maximumDirection)°"
    }

    func formatVisibility() -> String? {
        guard let value = visibility?.value, let unit = visibility?.unit else { return nil }
        return "\(value) \(unit.format())"
    }

    func formatPressure() -> String? {
        guard let value = pressure?.value, let unit = pressure?.unit else { return nil }
        return "\(value) \(unit.format())"
    }

}