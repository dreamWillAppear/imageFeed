import XCTest
@testable import ImageFeed

final class ProfileViewControllerTest: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileInfo: .init(username: "", nameLabel: "", profileDescription: ""))
        viewController.presenter = presenter
        
        presenter.logout()
        
        XCTAssertTrue(presenter.logoutDidCall)
    }
    
    func testViewControllerCallsGetProfileImageURL() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileInfo: .init(username: "", nameLabel: "", profileDescription: ""))
        viewController.presenter = presenter
        
        viewController.setProfileImage()
        
        XCTAssertTrue(presenter.getProfileImageURLdidCall)
    }
    
    func testViewControllerCallsGetProfileInfo() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy(profileInfo: .init(username: "", nameLabel: "", profileDescription: ""))
        viewController.presenter = presenter
        
        viewController.presenter?.getProfileInfo(from: nil)
        
        XCTAssertTrue(presenter.getProfileInfoDidCall)
    }
    
}
