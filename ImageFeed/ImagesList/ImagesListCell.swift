import UIKit

public final class ImagesListCell: UITableViewCell {
    static let  reuseIdentifier = "ImagesListCell"
    var photoId = ""
    var isAlreadyLiked = false
    weak var delegate: ImagesListCellDelegateProtocol?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.didTapLikeButton(from: self)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
}
