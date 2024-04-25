import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService()
    private var imagesListNotificationObserver: NSObjectProtocol?
    private var photos: [Photo] = []
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
    
    //MARK: - Private methods
    
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
    
    private func observeImagesListChanges() {
        imagesListNotificationObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
}

private func configDateString(from date: String) -> String {
    var  formattedDateString = ""
    
    guard let date = DateFormatters.inputFormatter.date(from: date) else {
        print("PhotoResultModel - failed to get date!")
        return formattedDateString
    }
    
    DateFormatters.dateFormatter.dateStyle = .long
    DateFormatters.dateFormatter.timeStyle = .none
    formattedDateString = DateFormatters.dateFormatter.string(from: date)
    return formattedDateString
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
        let photo = self.photos[indexPath.row]
        let photoUrl = photo.thumbImageURL //по факту загружается размер "regular", если грузить "thumb" как указано в курсе - получим ленту шакалов
        let dateLabel = configDateString(from: photo.createdAt)
        cell.likeButton.imageView?.image = photo.likedByUser ? .likeButtonActive : .likeButtonInactive
        cell.isAlreadyLiked = photo.likedByUser
        cell.photoId = photo.id
        cell.dateLabel.text = dateLabel
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(with: photoUrl, placeholder: UIImage(named: "Image Cell Placeholder")) { [weak self] _ in
            guard let self = self, let indexPath = self.tableView.indexPath(for: cell) else { return }
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


