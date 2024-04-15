import UIKit



final class ImagesListCell: UITableViewCell {
    static let  reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegateProtocol?
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print(" imageCell.kf.cancelDownloadTask()")
    }
    
}
