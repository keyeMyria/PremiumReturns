//
//  ModelControllerTests.swift
//  BiasBike
//
//  Created by Bruce McTigue on 9/10/16.
//  Copyright © 2016 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class ModelControllerTests: XCTestCase {
    
    func testClear() {
        let modelController = ModelController()
        modelController.clear()
        XCTAssertTrue(true)
    }
}
