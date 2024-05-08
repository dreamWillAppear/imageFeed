import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    var tableView: UITableView! { get set }
    func uiBlockingProgressHUD(mustBeShown :Bool)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    //MARK: - Public Properties
    
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - IBOutlet
    
    @IBOutlet  var tableView: UITableView!
    
    // MARK: - Private Properties
    private let imagesListService = ImagesListService.shared
    private var imagesListNotificationObserver: NSObjectProtocol?
    private let showSingleImage = "ShowSingleImage"
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        observeImagesListChanges()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: ImagesListService.didChangeNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImage {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            viewController.urlForSingleImageView = presenter?.getUrlStringForSingleImageView(for: indexPath) //передаем в SingleImageViewController url на fullSize фото
          uiBlockingProgressHUD(mustBeShown: true)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func uiBlockingProgressHUD(mustBeShown :Bool) {
        mustBeShown ? UIBlockingProgressHUD.show() : UIBlockingProgressHUD.dismiss()
    }
    
    //MARK: - Private methods
    
    private func updateTableViewAnimated() {
        presenter?.updateTableViewAnimated()
    }
    
    private func observeImagesListChanges() {
        imagesListNotificationObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.presenter?.updateTableViewAnimated()
        }
        presenter?.fetchPhotosNextPage()
    }
}

//MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount ?? 0
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
        guard let height =  presenter?.calculateHeight(forRowAt: indexPath, from: tableView)  else {
            print("ImagesListViewController calculateHeight: Error calculate height for row!")
            return 200
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.photosCount {
            presenter?.fetchPhotosNextPage()
        }
    }
    
}

//MARK: - configCell

extension ImagesListViewController: ImagesListCellDelegateProtocol {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        presenter?.configCell(for: cell, with: indexPath)
    }
    
    func didTapLikeButton(from cell: ImagesListCell) {
        uiBlockingProgressHUD(mustBeShown: true)
        presenter?.didTapLikeButton(from: cell)
    }
}


