//
//  MetarParserCategoryTests.swift
//  MetarTests
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Nimble
import Quick

@testable import Metar

class MetarParserCategoryTests: QuickSpec {
    override func spec() {
        context("Visibility in miles") {
            it("should be VFR when more than 5 miles.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: false)
                metar.visibility?.value = "6"
                metar.visibility?.unit = .Miles
                expect(metar.visibility?.category) == .VFR
            }
            
            it("should be VFR when cavok.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: true)
                expect(metar.visibility?.category) == .VFR
            }
            
            it("should be MVFR when between 3-5 miles.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: false)
                metar.visibility?.value = "4"
                metar.visibility?.unit = .Miles
                expect(metar.visibility?.category) == .MVFR
            }
            
            it("should be IFR when between 1-3 miles.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: false)
                metar.visibility?.value = "2"
                metar.visibility?.unit = .Miles
                expect(metar.visibility?.category) == .IFR
            }
            
            it("should be LIFR when lower than 1 mile.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: false)
                metar.visibility?.value = "1"
                metar.visibility?.unit = .Miles
                expect(metar.visibility?.category) == .LIFR
            }
        }
        
        context("Visibility in meters") {
            it("should be VFR when more than 8000 meters.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: false)
                metar.visibility?.value = "9000"
                metar.visibility?.unit = .Meters
                expect(metar.visibility?.category) == .VFR
            }
            
            it("should be MVFR when between 4800-8000 meters.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: false)
                metar.visibility?.value = "6400"
                metar.visibility?.unit = .Meters
                expect(metar.visibility?.category) == .MVFR
            }
            
            it("should be IFR when between 1600-4800 meters.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: false)
                metar.visibility?.value = "2000"
                metar.visibility?.unit = .Meters
                expect(metar.visibility?.category) == .IFR
            }
            
            it("should be LIFR when lower than 1600 meter.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: false)
                metar.visibility?.value = "1000"
                metar.visibility?.unit = .Meters
                expect(metar.visibility?.category) == .LIFR
            }
        }
        
        context("Ceiling") {
            it("should be VFR when cavok.") {
                let metar = Metar(raw: "")
                metar.visibility = Visibility(cavok: true)
                expect(MetarCategory(rawValue: metar.cloudBaseCategory.rawValue)) == .VFR
            }
            
            it("should be VFR when more than 3000 ft.") {
                let metar = Metar(raw: "")
                var cloud = Cloud()
                cloud.base = 4000
                metar.clouds.append(cloud)
                expect(MetarCategory(rawValue: metar.cloudBaseCategory.rawValue)) == .VFR
            }
            
            it("should be MVFR when between 1000-3000 ft.") {
                let metar = Metar(raw: "")
                var cloud = Cloud()
                cloud.base = 2000
                metar.clouds.append(cloud)
                expect(MetarCategory(rawValue: metar.cloudBaseCategory.rawValue)) == .MVFR
            }
            
            it("should be IFR when between 500-1000 ft.") {
                let metar = Metar(raw: "")
                var cloud = Cloud()
                cloud.base = 700
                metar.clouds.append(cloud)
                expect(MetarCategory(rawValue: metar.cloudBaseCategory.rawValue)) == .IFR
            }
            
            it("should be LIFR when lower than 500 meter.") {
                let metar = Metar(raw: "")
                var cloud = Cloud()
                cloud.base = 400
                metar.clouds.append(cloud)
                expect(MetarCategory(rawValue: metar.cloudBaseCategory.rawValue)) == .LIFR
            }
        }
        
    }
}