import UIKit

public final class ImagesListCell: UITableViewCell {
    static let  reuseIdentifier = "ImagesListCell"
    public var photoId = ""
    public var isAlreadyLiked = false
    weak var delegate: ImagesListCellDelegateProtocol?
    
    @IBOutlet public weak var likeButton: UIButton!
    @IBOutlet public weak var imageCell: UIImageView!
    @IBOutlet public weak var dateLabel: UILabel!
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.didTapLikeButton(from: self)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
}
