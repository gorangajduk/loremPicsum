//
//  PhotoDetailViewUITests.swift
//  LoremPicsum
//
//  Created by Goran Gajduk on 29.12.25.
//


import XCTest

final class PhotoDetailViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Content Display Tests

    func testPhotoDetail_DisplaysAllElements() throws {
        app.launchArguments = ["UI-Testing"]
        app.launch()
        
        // Navigate to detail
        let photoGrid = app.scrollViews["photoGrid"]
        XCTAssertTrue(photoGrid.waitForExistence(timeout: 5))
        
        let firstPhotoCell = photoGrid.buttons.matching(identifier: "photoCell_0").firstMatch
        XCTAssertTrue(firstPhotoCell.waitForExistence(timeout: 2))
        firstPhotoCell.tap()
        
        // Verify title
        let detailTitle = app.staticTexts["photoDetailTitle"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 2))
        XCTAssertEqual(detailTitle.label, "Photo Details")
        
        // Verify image or loading indicator exists
        let detailImage = app.images["photoDetailImage"]
        let loadingIndicator = app.otherElements["photoDetailImageLoading"]
        XCTAssertTrue(detailImage.exists || loadingIndicator.exists, "Either image or loading indicator should be present")
        
        // Verify author information
        let authorText = app.staticTexts.matching(identifier: "photoDetailAuthor").firstMatch
        XCTAssertTrue(authorText.waitForExistence(timeout: 2))
        XCTAssertTrue(authorText.label.contains("Author:"))
        XCTAssertTrue(authorText.label.contains("Mock Author 0"))
        
        // Verify ID information
        let idText = app.staticTexts["photoDetailID"]
        XCTAssertTrue(idText.exists)
        XCTAssertTrue(idText.label.contains("ID:"))
        XCTAssertTrue(idText.label.contains("0"))
        
        // Verify size information
        let sizeText = app.staticTexts["photoDetailSize"]
        XCTAssertTrue(sizeText.exists)
        XCTAssertTrue(sizeText.label.contains("Size:"))
        XCTAssertTrue(sizeText.label.contains("4.000"))
        XCTAssertTrue(sizeText.label.contains("3.000"))
        
        // Verify URL link
        let urlLink = app.buttons["photoDetailURL"]
        XCTAssertTrue(urlLink.exists)
        XCTAssertTrue(urlLink.label.contains("URL:"))
        XCTAssertTrue(urlLink.label.contains("https://unsplash.com/photos/mock-0"))
    }
    
    // MARK: - Multiple Photos Test
    
    func testPhotoDetail_DifferentPhotos_ShowDifferentData() throws {
        app.launchArguments = ["UI-Testing"]
        app.launch()
        
        // Wait for photo grid
        let photoGrid = app.scrollViews["photoGrid"]
        XCTAssertTrue(photoGrid.waitForExistence(timeout: 5))
        
        // Navigate to first photo and get author
        let firstPhotoCell = photoGrid.buttons.matching(identifier: "photoCell_0").firstMatch
        firstPhotoCell.tap()
        
        let firstAuthor = app.staticTexts["photoDetailAuthor"]
        XCTAssertTrue(firstAuthor.waitForExistence(timeout: 2))
        let firstAuthorName = firstAuthor.label
        
        // Go back
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(photoGrid.waitForExistence(timeout: 2))
        
        // Navigate to second photo and get author
        let secondPhotoCell = photoGrid.buttons.matching(identifier: "photoCell_1").firstMatch
        XCTAssertTrue(secondPhotoCell.waitForExistence(timeout: 2))
        secondPhotoCell.tap()
        
        let secondAuthor = app.staticTexts["photoDetailAuthor"]
        XCTAssertTrue(secondAuthor.waitForExistence(timeout: 2))
        let secondAuthorName = secondAuthor.label
        
        // Authors should be different
        XCTAssertNotEqual(firstAuthorName, secondAuthorName)
    }
}
