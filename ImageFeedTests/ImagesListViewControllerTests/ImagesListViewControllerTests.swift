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

        let presenter = ImagesListPresenterSpy()
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.photo =  ImagesListPresenterSpy.Photo(id: "123", size: CGSize(), createdAt: "2016-05-03T11:00:28-04:00", welcomeDescription: "", thumbImageURL: URL(string: ""), fullImageURL: URL(string: "https://mock.url.string"), likedByUser: true)
        
        presenter.configCell(for: presenter.cell, with: indexPath)
        
       // XCTAssertEqual(cell.isAlreadyLiked, true)
    }
 
    
    func testTest() {
    let cell = ImagesListCell()
        XCTAssertNotNil(cell)
    
    }
//    func testConfigCell()  {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//          // Создаем экземпляр контроллера, из которого загрузим ячейку
//          let viewController = ImagesListViewController()
//          // Загружаем таблицу
//
//        _ = viewController.view
//        let presenter = ImagesListPresenterSpy()
//        let cell = ImagesListCell()
//        let indexPath = IndexPath(row: 0, section: 0)
//        guard let cell = viewController.tableView(viewController.tableView, cellForRowAt: indexPath) as? ImagesListCell else {
//                XCTFail("Could not get cell")
//                return
//            }
//        presenter.photo = ImagesListPresenterSpy.Photo(id: "1223", size: CGSize(), createdAt: "2016-05-03T11:00:28-04:00", welcomeDescription: nil, thumbImageURL: nil, fullImageURL: nil, likedByUser: true)
//
//        presenter.configCell(for: cell, with: indexPath)
//        
//        XCTAssertEqual(cell.photoId, "1223")
//        XCTAssertEqual(cell.dateLabel.text, "3 мая 2016")
//        XCTAssertEqual(cell.isAlreadyLiked, true)
//    }
    
}
class MockTableView: UITableView {
    
    // Свойство, которое будет использоваться для хранения числа строк в таблице
    var numberOfRows = 0
    
    // Переопределение метода для имитации возвращения числа строк в секции
    override func numberOfRows(inSection section: Int) -> Int {
        return numberOfRows
    }
    
    // Другие методы и свойства UITableView, которые вы хотите имитировать
}
