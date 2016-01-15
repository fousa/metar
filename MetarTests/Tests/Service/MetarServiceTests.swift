//
//  MetarServiceTests.swift
//  MetarTests
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import CoreLocation

import Nimble
import Quick
import Mockingjay

@testable import Metar

class MetarServiceTests: QuickSpec {
    override func spec() {
        context("Fetch list by station name") {
            it("should return data.") {
                self.fullFillExpectation("GET by station name") { expectation in
                    self.stub(everything, builder: http(200, headers: nil, data: NSData()))
                    
                    MetarService().fetchList(station: "EBAW") { (error, data) -> () in
                        expect(error).to(beNil())
                        expect(data).toNot(beNil())
                        expectation.fulfill()
                    }
                }
            }
            
            it("should return an error.") {
                self.fullFillExpectation("GET by station name with error") { expectation in
                    let stubbedError = NSError(domain: "Some error", code: 0, userInfo: nil)
                    self.stub(everything, builder: failure(stubbedError))
                    
                    MetarService().fetchList(station: "EBBT") { (error, data) -> () in
                        expect(error).toNot(beNil())
                        expect(data).to(beNil())
                        expectation.fulfill()
                    }
                }
            }
        }
        
        context("Fetch list by location") {
            it("should return data.") {
                self.fullFillExpectation("GET by location") { expectation in
                    self.stub(everything, builder: http(200, headers: nil, data: NSData()))
                    
                    MetarService().fetchList(location: CLLocation()) { (error, data) -> () in
                        expect(error).to(beNil())
                        expect(data).toNot(beNil())
                        expectation.fulfill()
                    }
                }
            }
            
            it("should return an error.") {
                self.fullFillExpectation("GET by location with error") { expectation in
                    let stubbedError = NSError(domain: "Some error", code: 0, userInfo: nil)
                    self.stub(everything, builder: failure(stubbedError))
                    
                    MetarService().fetchList(location: CLLocation()) { (error, data) -> () in
                        expect(error).toNot(beNil())
                        expect(data).to(beNil())
                        expectation.fulfill()
                    }
                }
            }
        }
    }
}
