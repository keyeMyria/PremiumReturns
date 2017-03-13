//
//  StrategyControllerTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/5/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class StrategyControllerTests: XCTestCase {
    
    override func setUp() {
        ModelControllerUtilities.sharedInstance.clearAllModelControllers()
    }
    
    func testFind() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let firstStrategy = StrategyController.sharedInstance.all().first!
        let key = firstStrategy.strategyId
        let strategy = StrategyController.sharedInstance.find(key: key)
        XCTAssertEqual(firstStrategy.name, strategy?.name)
    }
    
    func testFindByName() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let firstStrategy = StrategyController.sharedInstance.all().first!
        let key = firstStrategy.name
        let strategies = StrategyController.sharedInstance.find(name: key)
        XCTAssertEqual(firstStrategy.name, strategies.first?.name)
    }
    
    func testRemove() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let firstStrategy = StrategyController.sharedInstance.all().first!
        StrategyController.sharedInstance.remove(strategy: firstStrategy)
        let count = StrategyController.sharedInstance.all().count
        XCTAssertEqual(count, StrategyType.strategyTypes.count - 2)
    }
    
    func testIsUnique() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let firstStrategy = StrategyController.sharedInstance.all().first!
        var isUniqueStrategy = StrategyController.sharedInstance.isUnique(name: firstStrategy.name)
        XCTAssertFalse(isUniqueStrategy)
        let testStrategy = Strategy.forType(type: .IronCondor, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        isUniqueStrategy = StrategyController.sharedInstance.isUnique(name: testStrategy.name)
        XCTAssertTrue(isUniqueStrategy)
    }
    
    func testStrategyTypeFor() {
        var testStrategy = Strategy.forType(type: .IronCondor, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        var testStrategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: testStrategy)
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .IronFly, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        testStrategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: testStrategy)
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .VerticalSpread, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        testStrategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: testStrategy)
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .Straddle, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        testStrategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: testStrategy)
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .Strangle, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        testStrategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: testStrategy)
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .RatioSpread, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        testStrategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: testStrategy)
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .JadeLizard, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        testStrategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: testStrategy)
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .Custom, name: "Test", legs: 4, maxProfitPercentage: 0, winningProbability: 0)
        testStrategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: testStrategy)
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
    }
}
