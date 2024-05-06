import XCTest
@testable import ImageFeed

final class ProfileViewControllerTest: XCTestCase {
    
    func testLogoutDidCall() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileInfo: .init(username: "", nameLabel: "", profileDescription: ""))
        viewController.presenter = presenter
        
        presenter.logout()
        
        XCTAssertTrue(presenter.logoutDidCall)
    }
    
    func testGetProfileImageURLdidCall() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileInfo: .init(username: "", nameLabel: "", profileDescription: ""))
        viewController.presenter = presenter
        
        viewController.setProfileImage()
        
        XCTAssertTrue(presenter.getProfileImageURLdidCall)
    }
    
    func testGetProfileInfo() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileInfo: .init(username: "", nameLabel: "", profileDescription: ""))
        viewController.presenter = presenter
        
        viewController.presenter?.getProfileInfo(from: nil)
        
        XCTAssertTrue(presenter.getProfileInfoDidCall)
    }
        
}
