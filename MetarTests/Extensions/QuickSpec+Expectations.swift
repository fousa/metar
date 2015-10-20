//
//  QuickSpec+Expectations.swift
//  Metar
//
//  Created by Jelle Vandebeeck on 20/10/15.
//  Copyright © 2015 Jelle Vandebeeck. All rights reserved.
//

import Quick

extension QuickSpec {
    func fullFillExpectation(name: String, block: (XCTestExpectation) -> ()) {
        let expectation = expectationWithDescription(name)
        
        block(expectation)
        
        // Wait for expection to complete.
        waitForExpectationsWithTimeout(5) { error in
            XCTAssertNil(error, "🚓 \(error?.localizedDescription)")
        }
    }
}