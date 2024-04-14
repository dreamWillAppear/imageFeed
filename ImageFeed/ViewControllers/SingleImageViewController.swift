import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image ?? .stub)
        }
    }
    
    var imageUrl: URL! {
           didSet {
               guard isViewLoaded else {return}
               setSingleImage()
           }
       }
    
    
    // MARK: - IBOutlet
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Private Properties
    
    private var imageListViewController = ImagesListViewController()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image ?? .stub)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        setSingleImage()
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
    
    private func  setImageFromUrl() {
          imageView.kf.setImage(with: imageUrl) { [weak self] result in
              UIBlockingProgressHUD.dismiss()
              guard let self = self else { return }
              switch result {
              case .success(let imageResult):
                  self.rescaleAndCenterImageInScrollView(image: imageResult.image)
              case .failure:
                  self.showImageError(imageUrl: imageUrl)
              }
          }
      }
    
    private func showImageError(imageUrl: URL) {
           let alert = UIAlertController(
                       title: "Что-то пошло не так",
                       message: "Не удалось поставить лайк",
                       preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .cancel))
           alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
               guard let self = self else { return }
               self.setImageFromUrl()
           }))
                   self.present(alert, animated: true, completion: nil)
       }

    
  private  func setSingleImage() {
         UIBlockingProgressHUD.show()
         setImageFromUrl()
     }
    
}

//MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
