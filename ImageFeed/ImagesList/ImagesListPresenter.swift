import Foundation
public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func updateTableViewAnimated()
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
   weak var view: ImagesListViewControllerProtocol?
   // var photos: [Photo] = []
    var imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        view?.tableView.rowHeight = 200
    }
    
    func updateTableViewAnimated() {

        print("table presenter!!")
        guard  let oldCount = view?.photos.count else { return }
        let newCount = imagesListService.photos.count
        view?.photos = imagesListService.photos
        if oldCount != newCount {
            view?.tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                view?.tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    /*
     et oldCount = photos.count
     let newCount = imagesListService.photos.count
     photos = imagesListService.photos
     if oldCount != newCount {
     tableView.performBatchUpdates {
     let indexPaths = (oldCount..<newCount).map { i in
     IndexPath(row: i, section: 0)
     }
     tableView.insertRows(at: indexPaths, with: .automatic)
     } completion: { _ in }
     }
     */
}
