import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    //MARK: - Public Properties
    var urlForSinglImageView: URL?
    var image = UIImage()
    // MARK: - IBOutlet
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Private Properties
    
    private var imageListViewController = ImagesListViewController()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = UIImage() //инициализируем imageView, что бы не получить краш при переходе из ImagesListViewController
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
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    // MARK: - Private Methods

    //если viewWillAppear следует после viewDidLoad, то imageView уже инициализированна, загружаем в нее фото из url, переданного из ImagesListViewController - это выглядит проще и короче, чем предложенное решение из Спринт 9/20: 9 → Тема 2/6: Навигация → Урок 6/7 ViewDidLoad-хаки и честное решение:
    private func setImage(from url: URL?, to imageView: UIImageView) {
        imageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
            let visibleRectSize = scrollView.bounds.size
            let imageSize = image.size
            
            // Вычисляем масштаб, чтобы изображение занимало всю доступную область scrollView
            let hScale = visibleRectSize.width / imageSize.width
            let vScale = visibleRectSize.height / imageSize.height
            let scale = max(hScale, vScale)
            
            // Устанавливаем масштабирование изображения
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // Вычисляем новый размер contentSize
            let newContentSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
            
            // Устанавливаем contentSize
            scrollView.contentSize = newContentSize
            
            // Центрируем изображение
            let x = max(0, (newContentSize.width - visibleRectSize.width) / 2)
            let y = max(0, (newContentSize.height - visibleRectSize.height) / 2)
            scrollView.contentOffset = CGPoint(x: x, y: y)
    }
    
    
}

//MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
           if scale > scrollView.minimumZoomScale && scale < scrollView.maximumZoomScale {
               let imageSize = imageView.image?.size ?? .zero
               let visibleRectSize = scrollView.bounds.size
               let hScale = visibleRectSize.width / imageSize.width
               let vScale = visibleRectSize.height / imageSize.height
               let newScale = max(hScale, vScale)
               scrollView.setZoomScale(newScale, animated: true)
           }
       }
    
}
