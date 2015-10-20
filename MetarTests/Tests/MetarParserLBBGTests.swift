//
//  MetarParserLBBGTests.swift
//  MetarTests
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Nimble
import Quick

@testable import Metar

class MetarParserLBBGTests: QuickSpec {
    override func spec() {
        
        describe("LBBG") {
            var metar: Metar!
            beforeEach {
                metar = Metar(raw: "LBBG 041600Z 120103MPS 290V310 1400 R04R/P1600 R22/P1500U -SN BKN022 OVC050 M04/M07 Q1020 NOSIG 9949//91")
                metar.station.name = "LBBG"
                MetarParser(metar: metar).parse()
            }
            
            context("Common data") {
                it("should correctly parse the station name.") {
                    expect(metar.station.name) == "LBBG"
                }
                it("should correctly parse the observation time.") {
//                    expect(metar.observationTime?.description) == "2015-06-04 16:00:00 +0000"
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
                    expect(metar.visibility?.unit) == .Meters
                }
                it("should correctly parse the visibility value.") {
                    expect(metar.visibility?.value) == "1400"
                }
                it("should correctly parse the cavok value.") {
                    expect(metar.visibility?.cavok) == false
                }
            }
            
            context("Temperature data") {
                it("should correctly parse the temperature value.") {
                    expect(metar.temperature) == -4
                }
                it("should correctly parse the dewpoint value.") {
                    expect(metar.dewpoint) == -7
                }
            }
            
            context("Significant change data") {
                it("should correctly parse the significant change value.") {
                    expect(metar.noSignificantChange) == true
                }
            }
            
            context("Cloud data") {
                it("should correctly parse the cloud count.") {
                    expect(metar.clouds.count) == 2
                }
                it("should correctly parse the cloud coverage.") {
                    expect(metar.clouds.first!.coverage) == .Broken
                    expect(metar.clouds.last!.coverage) == .Overcast
                }
                it("should correctly parse the cloud base.") {
                    expect(metar.clouds.first!.base) == 2200
                    expect(metar.clouds.last!.base) == 5000
                }
            }
            
            context("Runway data") {
                it("should correctly parse the runway count.") {
                    expect(metar.clouds.count) == 2
                }
                it("should correctly parse the runway name.") {
                    expect(metar.runways.first!.name) == "04R"
                    expect(metar.runways.last!.name) == "22"
                }
                it("should correctly parse the cloud trend.") {
                    expect(metar.runways.first!.trend) == Runway.RunwayTrend.NoChange
                    expect(metar.runways.last!.trend) == Runway.RunwayTrend.Upward
                }
                it("should correctly parse the runway visual range.") {
                    expect(metar.runways.first!.visualRange) == 1600
                    expect(metar.runways.last!.visualRange) == 1500
                }
            }
            
            context("Wind data") {
                it("should correctly parse the wind unit.") {
                    expect(metar.wind?.unit) == .MetersPerSecond
                }
                it("should correctly parse the wind speed.") {
                    expect(metar.wind?.speed) == 103
                }
                it("should correctly parse the wind direction.") {
                    expect(metar.wind?.direction) == 120
                }
                it("should correctly parse the wind varying.") {
                    expect(metar.wind?.varying) == true
                }
                it("should correctly parse the wind gusts.") {
                    expect(metar.wind?.gustSpeed).to(beNil())
                }
                it("should correctly parse the wind minimum direction.") {
                    expect(metar.wind?.minimumDirection) == 290
                }
                it("should correctly parse the wind maximum direction.") {
                    expect(metar.wind?.maximumDirection) == 310
                }
            }
            
            pending("Phenomena data", nil)
            pending("Remarks data", nil)
        }
    }
}
