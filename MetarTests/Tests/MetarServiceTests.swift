//
//  MetarServiceTests.swift
//  MetarTests
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import XCTest
import CoreLocation

import Mockingjay
import Nimble

@testable import Metar

class MetarServiceTests: XCTestCase {
    // MARK: Fetch list by station name
    
    func testFetchListStation() {
        fullFillExpectation("testFetchListStation") { expectation in
            self.stub(everything, builder: http(200, headers: nil, data: NSData()))
            
            MetarService().fetchList(station: "EBAW") { (error, data) -> () in
                expect(error).to(beNil())
                expect(data).toNot(beNil())
                expectation.fulfill()
            }
        }
    }
    
    func testErrorFetchListStation() {
        fullFillExpectation("testErrorFetchListStation") { expectation in
            let stubbedError = NSError(domain: "Some error", code: 0, userInfo: nil)
            self.stub(everything, builder: failure(stubbedError))
        
            MetarService().fetchList(station: "EBBT") { (error, data) -> () in
                expect(error).toNot(beNil())
                expect(data).to(beNil())
                expectation.fulfill()
            }
        }
    }
    
    // MARK: Fetch list by location
    
    func testFetchListLocation() {
        fullFillExpectation("testFetchListLocation") { expectation in
            self.stub(everything, builder: http(200, headers: nil, data: NSData()))
            
            MetarService().fetchList(location: CLLocation()) { (error, data) -> () in
                expect(error).to(beNil())
                expect(data).toNot(beNil())
                expectation.fulfill()
            }
        }
    }
    
    func testErrorFetchListLocation() {
        fullFillExpectation("testErrorFetchListLocation") { expectation in
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
