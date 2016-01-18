//
//  MTRDistanceFormatterTests.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 18/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import Nimble
import Quick

import CoreLocation

@testable import Metar

class MTRDistanceFormatterTests: QuickSpec {
    override func spec() {
        it("should format the distance") {
            let formattedDistance = MTRDistanceFormatter.format(distance: 1000)
            expect(formattedDistance) == "0.6 miles"
        }
        
        it("should format the distance in components") {
            let formattedDistance = MTRDistanceFormatter.formattedComponents(distance: 1000)
            expect(formattedDistance.value) == "0.6"
            expect(formattedDistance.unit) == "miles"
        }
    }
}