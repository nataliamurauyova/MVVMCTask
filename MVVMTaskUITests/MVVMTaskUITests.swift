//
//  MVVMTaskUITests.swift
//  MVVMTaskUITests
//
//  Created by Nataliya Murauyova on 1/31/21.
//

import XCTest

class MVVMTaskUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin_Success() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let emailLabel = app.textFields["emailLabel"]
        emailLabel.tap()
        emailLabel.typeText("user")

        let passwordLabel = app.textFields["passwordLabel"]
        passwordLabel.tap()
        passwordLabel.typeText("123qwe")

        // Hiding keyboard
        XCUIApplication().keyboards.buttons["Return"].tap()

        let loginButton = app.buttons["loginButton"]
        loginButton.tap()

        // Checking that user navigated to second screen with table view
        XCTAssertNotNil(app.tableRows["stringCellId"])
    }

    func testLogin_Failure() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let emailLabel = app.textFields["emailLabel"]
        emailLabel.tap()
        emailLabel.typeText("useeeeer")

        let passwordLabel = app.textFields["passwordLabel"]
        passwordLabel.tap()
        passwordLabel.typeText("123qweeeee")

        // Hiding keyboard
        XCUIApplication().keyboards.buttons["Return"].tap()

        let loginButton = app.buttons["loginButton"]
        loginButton.tap()

        // Checking that user not navigated to second screen with table view
        XCTAssertTrue(emailLabel.exists)
        XCTAssertTrue(passwordLabel.exists)
    }

    func testSegmentedControl() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let emailLabel = app.textFields["emailLabel"]
        emailLabel.tap()
        emailLabel.typeText("user")

        let passwordLabel = app.textFields["passwordLabel"]
        passwordLabel.tap()
        passwordLabel.typeText("123qwe")

        // Hiding keyboard
        XCUIApplication().keyboards.buttons["Return"].tap()

        let loginButton = app.buttons["loginButton"]
        loginButton.tap()

        let segmentedControlSection1 = app.segmentedControls.buttons.element(boundBy: 0)
        XCTAssertEqual(segmentedControlSection1.label, "As is")

        let segmentedControlSection2 = app.segmentedControls.buttons.element(boundBy: 1)
        XCTAssertEqual(segmentedControlSection2.label, "A-Z")

        let segmentedControlSection3 = app.segmentedControls.buttons.element(boundBy: 2)
        XCTAssertEqual(segmentedControlSection3.label, "Z-A")
    }
}
