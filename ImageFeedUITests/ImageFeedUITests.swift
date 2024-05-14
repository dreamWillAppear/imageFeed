@testable import ImageFeed
import XCTest
import WebKit

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        // логин и пароль от учетки проверяющего
        let login = "<УЗ ревьюера>"
        let password = "<УЗ ревьюера>"
        
        let webView = app.webViews["UnsplashWebView"]
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        
        app.buttons["Authenticate"].tap()
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        app.toolbars.buttons["Done"].tap()
        passwordTextField.tap()
        passwordTextField.typeText(password)
        app.toolbars.buttons["Done"].tap()
        sleep(1)
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let table = app.tables.element(boundBy: 0)
        let image = app.scrollViews.images.element(boundBy: 0)
        let cell =  tablesQuery.children(matching: .cell).element(boundBy: 0)
        let likeButton = cell.children(matching: .button).element(matching: .button, identifier: "LikeButton")
        let backwardButton = app.buttons["BackwardButton"]
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        table.swipeUp()
        sleep(1)
        table.swipeDown()
        
        likeButton.tap()
        sleep(3)
        
        likeButton.tap()
        sleep(3)
        
        cell.tap()
        
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        backwardButton.tap()
        
        sleep(2)
    }
    
    func testProfile() throws {
        let table = app.tables.element(boundBy: 0)
        let profileButton = app.tabBars.buttons.element(boundBy: 1)
        let logoutButton = app.buttons["ipad.and.arrow.forward"]
        
        XCTAssertTrue(table.waitForExistence(timeout: 3))
        
        profileButton.tap()
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["<УЗ ревьюера>"].exists)
        XCTAssertTrue(app.staticTexts["<УЗ ревьюера>"].exists)
        
        logoutButton.tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        sleep(3)
    }
}
