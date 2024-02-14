//
//  MoviesUITests.swift
//  MoviesUITests
//
//  Created by Olga Sabadina on 04.01.2024.
//

import XCTest

final class MoviesUITests: XCTestCase {
    
    func testHomeScreen() {
        let app = XCUIApplication()
        app.launch()
        
        logIn(app)
        
        let collectionViewsQuery = app.collectionViews
        
        let segmentButtonOnTV = collectionViewsQuery.staticTexts["On TV"]
        
        let predicateIsExist = NSPredicate(format: "exists == true")
        expectation(for: predicateIsExist, evaluatedWith: segmentButtonOnTV, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssert(segmentButtonOnTV.exists)
        segmentButtonOnTV.tap()
        
        let cellIdentifier = "popular_0"
        
        let cell = collectionViewsQuery.cells.matching(identifier: cellIdentifier).firstMatch
        XCTAssertTrue(cell.exists, "Cell with identifier \(cellIdentifier) not found")
        cell.tap()
        
        sleep(2)
        
        let myListsText = app.scrollViews.otherElements.staticTexts["My Lists"]
        
        XCTAssert(myListsText.exists)
        
        app.scrollViews.otherElements.containing(.staticText, identifier:"Series Cast").element.swipeUp()
        
        let cellActor = app.scrollViews.otherElements.collectionViews.otherElements["cellActor_1"]
        
        XCTAssertTrue(cellActor.exists, "Cell with identifier not found")
        
        cellActor.tap()
        
        sleep(1)
        
       let seeMoreButton = app.scrollViews.otherElements.buttons["See More"]
        XCTAssert(seeMoreButton.exists)
    }
    
    func testSearchableScreen() {
        
        let app = XCUIApplication()
        app.launch()
        
        logIn(app)
        
        let searchTabBarButton = app.tabBars["Tab Bar"].buttons["Search"]
        
        let predicateIsExist = NSPredicate(format: "exists == true")
        
        expectation(for: predicateIsExist, evaluatedWith: searchTabBarButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssert(searchTabBarButton.exists)
        
        searchTabBarButton.tap()
        
        let cell = app.tables.otherElements["SearchCell_0"]
        
        XCTAssertTrue(cell.exists, "Cell with identifier SearchCell_0 not found")
        
        cell.tap()
        
        let myListsText = app.scrollViews.otherElements.staticTexts["My Lists"]
        
        XCTAssert(myListsText.exists)
    }
    
    func testProfileScreen() {
        
        let app = XCUIApplication()
        app.launch()
        
        logIn(app)
        
        let profileTabBarButton = app.tabBars["Tab Bar"].buttons["Profile"]
        
        let predicateIsExist = NSPredicate(format: "exists == true")
        
        expectation(for: predicateIsExist, evaluatedWith: profileTabBarButton, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssert(profileTabBarButton.exists)
        
        profileTabBarButton.tap()
        
        let logOutButton = app.buttons["Log Out"]
        
        XCTAssert(logOutButton.exists)
    }
    
    func testLoginScreen() {
        
        let app = XCUIApplication()
        app.launch()
        
        sleep(7)
        
        logOut(app)
        
        sleep(2)
        
        let welcomeTitle = app.staticTexts["Welcome"]

        XCTAssert(welcomeTitle.exists)
        
        logIn(app)
        
        let headerTitle = app.staticTexts["Free To Watch"]
        
        sleep(1)
        XCTAssert(headerTitle.exists)
        XCTAssertFalse(welcomeTitle.exists)
    }
    
    private func logIn(_ app: XCUIApplication) {
        
        let loginTF = app.textFields["LoginTF"]
    
        let passwordTF = app.secureTextFields["PasswordTF"]
        
        guard loginTF.exists && passwordTF.exists else {return}
                   
        loginTF.tap()
        loginTF.typeText("test@test.com")
                
        passwordTF.tap()
        passwordTF.typeText("123456")
        app.buttons["Return"].tap()
        app.staticTexts["LOG IN"].tap()
    }
    
    private func logOut(_ app: XCUIApplication) {
        
        let searchTabBarButton = app.tabBars["Tab Bar"].buttons["Profile"]
        
        guard searchTabBarButton.exists else {return}
        
        searchTabBarButton.tap()
        
        app.buttons["Log Out"].tap()
    }
}
