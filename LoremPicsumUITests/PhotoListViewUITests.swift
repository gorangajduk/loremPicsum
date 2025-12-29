import XCTest

final class PhotoListViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Success State Tests
    
    func testSuccessState_PhotosAreDisplayed() throws {
        app.launchArguments = ["UI-Testing"]
        app.launch()
        
        // Wait for photo grid
        let photoGrid = app.scrollViews["photoGrid"]
        XCTAssertTrue(photoGrid.waitForExistence(timeout: 5))
        
        // Check that at least one photo cell exists within the photo grid
        let firstPhotoCell = photoGrid.buttons.matching(identifier: "photoCell_0").firstMatch
        XCTAssertTrue(firstPhotoCell.waitForExistence(timeout: 2))
    }
        
    // MARK: - Empty State Tests
    
    func testEmptyState_ShowsNoPhotosMessage() throws {
        // Configure app to return empty results
        app.launchArguments = ["UI-Testing", "Empty-State"]
        app.launch()
        
        // Verify empty state messages are displayed
        let noPhotosText = app.staticTexts["No Photos Available"]
        XCTAssertTrue(noPhotosText.waitForExistence(timeout: 5))

        let pullToRefreshHint = app.staticTexts["Pull down to refresh"]
        XCTAssertTrue(pullToRefreshHint.exists)

        // Verify the empty state icon is displayed
        let emptyIcon = app.images["photo.on.rectangle.angled"]
        XCTAssertTrue(emptyIcon.exists)
    }
    
    // MARK: - Error State Tests
    
    func testErrorState_ShowsErrorMessage() throws {
        // Configure app to return an error
        app.launchArguments = ["UI-Testing", "Error-State"]
        app.launch()
        
        // Wait for error state to appear
        let errorTitle = app.staticTexts["errorTitle"]
        XCTAssertTrue(errorTitle.waitForExistence(timeout: 5))
        
        // Verify error title is correct
        XCTAssertEqual(errorTitle.label, "Failed to load photos.")
        
        // Verify error message exists
        let errorMessage = app.staticTexts["errorMessage"]
        XCTAssertTrue(errorMessage.exists)
        
        // Verify retry button exists and is tappable
        let retryButton = app.buttons["retryButton"]
        XCTAssertTrue(retryButton.exists)
        XCTAssertTrue(retryButton.isEnabled)
    }
    
    // MARK: - Navigation Tests
    
    func testNavigationTitle_IsDisplayed() throws {
        app.launchArguments = ["UI-Testing"]
        app.launch()
        
        let navigationTitle = app.navigationBars["Photos"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 5))
    }
}
