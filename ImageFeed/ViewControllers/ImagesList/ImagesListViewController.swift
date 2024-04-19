import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService()
    private var imagesListNotificationObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private let photosName: [String] = Array(0...19).map{"\($0)"}
    private let showSingleImage = "ShowSingleImage"
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        observeImagesListChanges()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImage {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else { 
                assertionFailure("Invalid segue destanation")
                return
            }
            
            viewController.urlForSingleImageView = photos[indexPath.row].fullImageURL //передаем в SingleImageViewController url на fullSize фото
            UIBlockingProgressHUD.show()
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
private func updateTableViewAnimated() {
        let oldCount = photos.count
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
    }

    //MARK: - Private methods
    
    private func observeImagesListChanges() {
           imagesListNotificationObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
               self?.updateTableViewAnimated()
           }
           imagesListService.fetchPhotosNextPage()
       }
    
}

private func configDateString(from date: String) -> String {
    var  formatedDateString = ""
    lazy var inputDateFormatter = ISO8601DateFormatter()
    
    guard let date = inputDateFormatter.date(from: date) else {
        print("PhotoResultModel - failed to get date!")
        return formatedDateString
    }
    
    lazy var dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    formatedDateString = dateFormatter.string(from: date)
    return formatedDateString
}


//MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("ImagesListViewController - EMPTY CELL SHOWN!")
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

//MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImage, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photoWidth =  photos[indexPath.row].size.width
        let photoHeight = photos[indexPath.row].size.height
        return photoHeight * (tableView.bounds.width / photoWidth)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
                   imagesListService.fetchPhotosNextPage()
               }
           }
}

//MARK: - configCell

extension ImagesListViewController: ImagesListCellDelegateProtocol {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let photo = photos[indexPath.row]
        let photoUrl = photo.thumbImageURL //по факту загружается размер "regular", если грзуить "thumb" как в курсе - получим ленту шакалов
        let dateLabel = configDateString(from: photo.createdAt)
        cell.likeButton.imageView?.image = photo.likedByUser ? .likeButtonActive : .likeButtonInactive
        cell.isAlreadyLiked = photo.likedByUser
        cell.photoId = photo.id
        cell.dateLabel.text = dateLabel
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(with: photoUrl, placeholder: UIImage(named: "Image Cell Placeholder")) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.imageCell.kf.indicatorType = .none
        }
    }

    func didTapLikeButton(from cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: cell.isAlreadyLiked ? false : true) { [weak self] result in
            guard let _ = self else  { return }
            switch result {
                case.success(let result):
                    //В курсе предлагают просто инвентировать кнопку лайка, но раз запрос после выполнения возвращает состояние фото - логично задействовать это состояние, что бы отобразить действительное наличие лайка. Это сработало, поэтому оставляю так.
                    cell.likeButton.imageView?.image = result.photo.likedByUser ? .likeButtonActive : .likeButtonInactive
                    cell.isAlreadyLiked = result.photo.likedByUser 
                    UIBlockingProgressHUD.dismiss()
                case.failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    print(String(describing: error))
            }
        }
    }
    
}


