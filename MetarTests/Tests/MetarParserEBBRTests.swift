//
//  MetarParserEBBRTests.swift
//  MetarTests
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Nimble
import Quick

@testable import Metar

class MetarParserEBBRTests: QuickSpec {
    override func spec() {
        
        describe("EBBR") {
            
            var metar: Metar!
            beforeEach {
                metar = Metar(raw: "EBBR 111220Z 23008G30KT CAVOK 24/M10 Q1020 NOSIG")
                metar.station.name = "EBBR"
                MetarParser(metar: metar).parse()
            }
            
            context("Common data") {
                it("should correctly parse the station name.") {
                    expect(metar.station.name) == "EBBR"
                }
                it("should correctly parse the observation time.") {
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.componentsInTimeZone(NSTimeZone(abbreviation: "UTC")!, fromDate: NSDate())
                    components.day = 11
                    components.hour = 12
                    components.minute = 20
                    components.second = 0
                    let date = calendar.dateFromComponents(components)
                    
                    expect(metar.observationTime?.description) == date?.description
                }
            }
            
            context("Pressure data") {
                it("should correctly parse the pressure unit.") {
                    expect(metar.pressure?.unit) == .Pascal
                }
                it("should correctly parse the pressure value.") {
                    expect(metar.pressure?.value) == 1020.0
                }
            }
            
            context("Visibility data") {
                it("should correctly parse the visibility unit.") {
                    expect(metar.visibility?.unit).to(beNil())
                }
                it("should correctly parse the visibility value.") {
                    expect(metar.visibility?.value).to(beNil())
                }
                it("should correctly parse the cavok value.") {
                    expect(metar.visibility?.cavok) == true
                }
            }
            
            context("Temperature data") {
                it("should correctly parse the temperature value.") {
                    expect(metar.temperature) == 24
                }
                it("should correctly parse the dewpoint value.") {
                    expect(metar.dewpoint) == -10
                }
            }
            
            context("Significant change data") {
                it("should correctly parse the significant change value.") {
                    expect(metar.noSignificantChange) == true
                }
            }
            
            context("Cloud data") {
                it("should correctly parse the cloud count.") {
                    expect(metar.clouds.count) == 0
                }
            }
            
            context("Runway data") {
                it("should correctly parse the runway count.") {
                    expect(metar.runways.count) == 0
                }
            }
            
            context("Wind data") {
                it("should correctly parse the wind unit.") {
                    expect(metar.wind?.unit) == .Knots
                }
                it("should correctly parse the wind speed.") {
                    expect(metar.wind?.speed) == 8
                }
                it("should correctly parse the wind direction.") {
                    expect(metar.wind?.direction) == 230
                }
                it("should correctly parse the wind varying.") {
                    expect(metar.wind?.varying).to(beFalse())
                }
                it("should correctly parse the wind gusts.") {
                    expect(metar.wind?.gustSpeed) == 30
                }
                it("should correctly parse the wind minimum direction.") {
                    expect(metar.wind?.minimumDirection).to(beNil())
                }
                it("should correctly parse the wind maximum direction.") {
                    expect(metar.wind?.maximumDirection).to(beNil())
                }
            }
            
            pending("Phenomena data", nil)
            pending("Remarks data", nil)
        }
    }
}
