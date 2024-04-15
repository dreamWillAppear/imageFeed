import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    //MARK: - Public Properties
    var urlForSinglImageView: URL?
    var image = UIImage(named: "Image Cell Placeholder")
    // MARK: - IBOutlet
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Private Properties
    
    private var imageListViewController = ImagesListViewController()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image //инициализируем imageView, что бы не получить краш при переходе из ImagesListViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setImage(from: urlForSinglImageView, to: imageView)
    
    }
    
    // MARK: - IBAction
    
    @IBAction func backwardButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [image ?? .stub], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    // MARK: - Private Methods

    //если viewWillAppear следует после viewDidLoad, то imageView уже инициализированна, загружаем в нее фото из url, переданного из ImagesListViewController - это выглядит проще и короче, чем предложенное решение из Спринт 9/20: 9 → Тема 2/6: Навигация → Урок 6/7 ViewDidLoad-хаки и честное решение:
    private func setImage(from url: URL?, to imageView: UIImageView) {
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "Image Cell Placeholder")) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //В настоящем этот метод не работает! Наставники подтвердили и сказали, что на текуших ревью этот момент не рассматривается. В уроке отмечено, что далее теория будет местами отталкиваться от этой реализации, поэтому пока не трогаю.
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    
}

//MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
