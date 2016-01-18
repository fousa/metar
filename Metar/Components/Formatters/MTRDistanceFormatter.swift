//
//  MTRDistanceFormatter.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 18/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class MTRDistanceFormatter {

    // MARK: - Formatter

    private static var distanceFormatter: MKDistanceFormatter {
        struct Static {
            static let instance: MKDistanceFormatter = {
                let formatter = MKDistanceFormatter()
                formatter.unitStyle = .Full
                return formatter
            }()
        }
        return Static.instance
    }

    // MARK: - Formatters

    static func format(distance distance: CLLocationDistance) -> String {
        return distanceFormatter.stringFromDistance(distance)
    }

    static func formattedComponents(distance distance: CLLocationDistance) -> (value: String?, unit: String?) {
        let formattedDistance = format(distance: distance)
        let components = formattedDistance.characters.split { $0 == " " }.map { String($0) }
        return (value: components.first, unit: components.last)
    }

}
