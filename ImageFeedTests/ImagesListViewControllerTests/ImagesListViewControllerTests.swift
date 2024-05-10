@testable import ImageFeed
import XCTest

class ImagesListViewControllerTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(presenter.viewDidLoadDidCall)
    }
    
    func testViewControllerCallsUpdateTableViewAnimated() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        
        presenter.updateTableViewAnimated()
        
        XCTAssertTrue(presenter.updateTableViewAnimatedDidCall)
    }
    
    func testConfigDateString() {
        let presenter = ImagesListPresenterSpy()
        let inputDateString = "2016-05-03T11:00:28-04:00" //согласно документации unsplash
        let expectedDateString = "3 мая 2016" //согласно макету
        let configuratedDateString = presenter.configDateString(from: inputDateString)
        
        XCTAssertEqual(expectedDateString, configuratedDateString)
    }
    
    func testCalculateHeight() {
        let presenter = ImagesListPresenterSpy()
        presenter.photo = ImagesListPresenterSpy.Photo(id: "", size: CGSize(width: 1500, height: 2000), createdAt: "", welcomeDescription: nil, thumbImageURL: nil, fullImageURL: nil, likedByUser: true)
        let indexPath = IndexPath(row: 0, section: 0)
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 75, height: 150))
        
        let calculatedHeight = presenter.calculateHeight(forRowAt: indexPath, from: tableView)
        
        let expectedHeight = presenter.photo.size.height * (tableView.bounds.width / presenter.photo.size.width)
        
        XCTAssertEqual(calculatedHeight, expectedHeight)
    }
    
    func testGetUrlStringForSingleImageView() {
        let presenter = ImagesListPresenterSpy()
        let mockURL = URL(string: "https://mock.url.string")
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.photo =  ImagesListPresenterSpy.Photo(id: "", size: CGSize(), createdAt: "", welcomeDescription: nil, thumbImageURL: nil, fullImageURL: URL(string: "https://mock.url.string"), likedByUser: true)
        let urlString = presenter.getUrlStringForSingleImageView(for: indexPath)
        
        XCTAssertNotNil(urlString)
        
        XCTAssertEqual(urlString, mockURL)
    }
    
    func testConfigCell() {
        let cell = ImagesListCell()
        let presenter = ImagesListPresenterSpy()
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.photo =  ImagesListPresenterSpy.Photo(id: "123", size: CGSize(), createdAt: "", welcomeDescription: "", thumbImageURL: URL(string: ""), fullImageURL: URL(string: "https://mock.url.string"), likedByUser: true)
        
        presenter.configCell(for: cell, with: indexPath)
        
        XCTAssertEqual(cell.isAlreadyLiked, true)
        XCTAssertEqual(cell.photoId, "123")
    }
    
    func testViewControllerCallsDidTapLikeButton() {
        let presenter = ImagesListPresenterSpy()
        let cell = ImagesListCell()
        
        presenter.didTapLikeButton(from: cell)
        
        XCTAssertEqual(presenter.didTapLikeButtonDidCall, true)    
    }
    
    func testViewControllerCallsFetchPhotosNextPage() {
        let presenter = ImagesListPresenterSpy()
        
        presenter.fetchPhotosNextPage()
        
        XCTAssertEqual(presenter.fetchPhotosNextPageDidCall, true)
    }
    
}
