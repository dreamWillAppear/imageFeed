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
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
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
            
            viewController.urlForSinglImageView = photos[indexPath.row].fullImageURL //передаем в SingleImageViewController url на fullSize фото
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
        
        cell.delegate = self
        
        let photoUrl = photos[indexPath.row].thumbImageURL //по факту загружается размер "regular", если грзуить "thumb" как в курсе - получим ленту шакалов
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.kf.setImage(with: photoUrl, placeholder: UIImage(named: "Image Cell Placeholder")) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.imageCell.kf.indicatorType = .none
        }
    }
    
}


