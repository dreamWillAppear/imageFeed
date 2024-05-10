import Foundation
import UIKit
public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func viewDidLoad()
    func updateTableViewAnimated()
    func configDateString(from date: String) -> String
    func calculateHeight(forRowAt index:  IndexPath, from tableView: UITableView) -> CGFloat
    func getUrlStringForSingleImageView(for row: IndexPath) -> URL?
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func didTapLikeButton(from cell: ImagesListCell)
    func fetchPhotosNextPage()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var photosCount: Int {
        photos.count
    }
    
    var imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        view?.tableView.rowHeight = 200
    }   
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                view?.tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func configDateString(from date: String) -> String {
        var  formattedDateString = ""
        guard let date = DateFormatters.inputFormatter.date(from: date) else {
            print("configDateString - failed to get date!")
            return formattedDateString
        }
        
        DateFormatters.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        DateFormatters.dateFormatter.locale = Locale(identifier: "ru_RU")
        DateFormatters.dateFormatter.dateFormat = "d MMMM yyyy"
        formattedDateString = DateFormatters.dateFormatter.string(from: date)
        return formattedDateString
    }
    
    func calculateHeight(forRowAt index:  IndexPath, from tableView: UITableView) -> CGFloat {
        let photoWidth =  photos[index.row].size.width
        let photoHeight = photos[index.row].size.height
        return photoHeight * (tableView.bounds.width / photoWidth)
    }
    
    func getUrlStringForSingleImageView(for row: IndexPath) -> URL? {
        photos[row.row].fullImageURL
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        let photoUrl = photo.thumbImageURL
        let dateLabel = configDateString(from: photo.createdAt)
        cell.likeButton.imageView?.image = photo.likedByUser ? .likeButtonActive : .likeButtonInactive
        cell.isAlreadyLiked = photo.likedByUser
        cell.photoId = photo.id
        cell.dateLabel.text = dateLabel
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(with: photoUrl, placeholder: UIImage(named: "Image Cell Placeholder")) { [weak self] _ in
            guard let self = self, let indexPath = self.view?.tableView.indexPath(for: cell) else { return }
            view?.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.imageCell.kf.indicatorType = .none
        }
    }
    
    func didTapLikeButton(from cell: ImagesListCell) {
        guard let indexPath = view?.tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: cell.isAlreadyLiked ? false : true) { [weak self] result in
            guard let self = self else  { return }
            switch result {
            case.success(let result):
                cell.likeButton.imageView?.image = result.photo.likedByUser ? .likeButtonActive : .likeButtonInactive
                cell.isAlreadyLiked = result.photo.likedByUser
                self.view?.uiBlockingProgressHUD(mustBeShown: false)
            case.failure(let error):
                self.view?.uiBlockingProgressHUD(mustBeShown: false)
                print(String(describing: error))
            }
        }
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
}
