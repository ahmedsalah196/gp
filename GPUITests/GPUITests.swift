//
//  GPUITests.swift
//  GPUITests
//
//  Created by Ahmed Salah on 5/29/19.
//  Copyright © 2019 Ahmed Salah. All rights reserved.
//

import XCTest

class GPUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        sleep(5)
        snapshot("daily prices")
        tabBarsQuery.buttons["Simulation"].tap()
        sleep(5)
        snapshot("Monte Carlo Simulation")
        tabBarsQuery.buttons["News"].tap()
        sleep(6)
        snapshot("news")
        tabBarsQuery.buttons["Indicators"].tap()
        sleep(4)
        snapshot("simple moving average")
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Simple moving average"].tap()
        let label = app.staticTexts["Hello, world!"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: label) { () -> Bool in
            snapshot("options")
            return true
        }
        waitForExpectations(timeout: 2, handler: nil)
        elementsQuery.tables/*@START_MENU_TOKEN@*/.staticTexts["MACD"]/*[[".cells.staticTexts[\"MACD\"]",".staticTexts[\"MACD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(6)
        snapshot("MACD")
        app.navigationBars["GP.TechnicalView"].buttons["Commodities"].tap()
        snapshot("commodities")
    }
    
}
