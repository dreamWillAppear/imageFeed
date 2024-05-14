import ImageFeed
import UIKit
import Kingfisher

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    internal  struct Photo: Codable {
        let id: String
        let size: CGSize
        let createdAt: String
        let welcomeDescription: String?
        let thumbImageURL: URL?
        let fullImageURL: URL?
        let likedByUser: Bool
    }
    
    internal var photo = Photo(id: "", size: CGSize(), createdAt: "", welcomeDescription: nil, thumbImageURL: nil, fullImageURL: nil, likedByUser: true)
    
    var view: (any ImageFeed.ImagesListViewControllerProtocol)?
    let cell = ImagesListCell()
    var photosCount: Int = 0
    var viewDidLoadDidCall = false
    var updateTableViewAnimatedDidCall = false
    var didTapLikeButtonDidCall = false
    var fetchPhotosNextPageDidCall = false
    
    
    func viewDidLoad() {
        viewDidLoadDidCall = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedDidCall = true
    }
    
    func configDateString(from date: String) -> String {
        enum DateFormatters {
            static let dateFormatter = DateFormatter()
            static let inputFormatter = ISO8601DateFormatter()
        }
        
        var  formattedDateString = ""
        guard let date = DateFormatters.inputFormatter.date(from: date) else {
            print("PhotoResultSpy configDate - failed to get date!")
            return formattedDateString
        }
        
        DateFormatters.dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        DateFormatters.dateFormatter.locale = Locale(identifier: "ru_RU")
        DateFormatters.dateFormatter.dateFormat = "d MMMM yyyy"
        formattedDateString = DateFormatters.dateFormatter.string(from: date)
        return formattedDateString
    }
    
    func calculateHeight(forRowAt index: IndexPath, from tableView: UITableView) -> CGFloat {
        let photos = Array(repeating: photo, count: 3)
        let photoWidth =  photos[index.row].size.width
        let photoHeight = photos[index.row].size.height
        return photoHeight * (tableView.bounds.width / photoWidth)
    }
    
    func getUrlStringForSingleImageView(for row: IndexPath) -> URL? {
        let photos = Array(repeating: photo, count: 3)
        return  photos[row.row].fullImageURL
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photos = Array(repeating: photo, count: 3)
        let photo = photos[indexPath.row]
        
        cell.isAlreadyLiked = photo.likedByUser
        cell.photoId = photo.id
    }
    
    func didTapLikeButton(from cell: ImageFeed.ImagesListCell) {
        didTapLikeButtonDidCall = true
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageDidCall = true
    }
}




