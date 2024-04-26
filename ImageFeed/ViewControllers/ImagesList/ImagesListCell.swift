import UIKit

final class ImagesListCell: UITableViewCell {
    static let  reuseIdentifier = "ImagesListCell"
    let imagesListService =  ImagesListService()
    var photoId = String()
    var isAlreadyLiked = Bool()
    weak var delegate: ImagesListCellDelegateProtocol?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.didTapLikeButton(from: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
}
