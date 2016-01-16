//
//  DashboardTests.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 16/01/16.
//  Copyright © 2016 Jelle Vandebeeck. All rights reserved.
//

import XCTest

class DashboardTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
       
        continueAfterFailure = false

        app.launch()
    }
    
    func testPlaceholderAppearance() {
        // Is the placeholder element visible.
        XCTAssert(app.otherElements["placeholder"].hittable)
    }
    
    func testEmptyTable() {
        // Is the airports table empty.
        let table = app.tables.elementBoundByIndex(0)
        XCTAssertEqual(table.cells.count, 0)
    }
}
