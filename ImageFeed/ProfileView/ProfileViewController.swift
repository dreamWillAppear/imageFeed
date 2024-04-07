import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let profilePhoto = UIImageView()
    private var nameLabel = UILabel()
    private var username = UILabel()
    private let profileDescription = UILabel()
    private var logoutButton = UIButton()
    private let appDelegate = AppDelegate()
    private let profileInfo = ProfileService.shared.profile
    private var profileImageObserver: NSObjectProtocol?
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIProfileViewController()
        
    }
    
    
    // MARK: - Private Methods
    
    private func addObserver() {
        profileImageObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main,
                using: { [weak self] _ in
                    guard let self = self else { return }
                    self.setProfileImage()
                }
            )
    }
    
    private func setProfileImage() {
        guard
            let profileImageURL = ProfileImageService.shared.profileImageURL,
            let url = URL(string: profileImageURL)
        else {
            print("ProfileViewController setProfileImage(45) - profileImageURL is nil!")
            return
        }
        //TODO use kingfisher
    }
    
    private func setUIProfileViewController() {
        updateProfileDetails(profile: profileInfo) //Getting data from ProfileService
        setProfilePhotoStyle()
        setProfileNameLabelStyle()
        setProfileUsernameStyle()
        setProfileDescriptionStyle()
        setLogoutButton()
        setConstraints()
    }
    
    private func setProfilePhotoStyle() {
        profilePhoto.image = UIImage(named: "User Mock Photo")
        view.addSubview(profilePhoto)
    }
    
    private func updateProfileDetails(profile: ProfileModel?) {
        
        guard let profile else
        {
            print("ProfileViewController updateProfileDetails (70) - Failed to get data from ProfileService!")
            return
        }
        
        username.text = "@" + profile.username
        nameLabel.text = profile.nameLabel
        profileDescription.text = profile.bio
    }
    
    private func setProfileNameLabelStyle() {
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.textColor = .ypWhite
        view.addSubview(nameLabel)
    }
    
    private func setProfileUsernameStyle() {
        username.font = .systemFont(ofSize: 13)
        username.textColor = .ypGray
        view.addSubview(username)
    }
    
    private func setProfileDescriptionStyle() {
        profileDescription.font = .systemFont (ofSize: 13)
        profileDescription.textColor = .ypWhite
        view.addSubview(profileDescription)
        
    }
    
    private func setLogoutButton() {
        logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward") ?? .stub,
            target: self,
            action: #selector(self.didTapLogoutButton))
        
        logoutButton.tintColor = .ypRed
        view.addSubview(logoutButton)
        logoutButton.imageView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logoutButton.imageView?.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func setConstraints() {
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //profilePhoto
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70),
            profilePhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            //nameLabel
            nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            
            //nickname
            username.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            username.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            //profileDescription
            profileDescription.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            
            //logoutButton
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15.66)
        ])
    }
    
    //MARK: - @objc
    
    @objc
    private func didTapLogoutButton() {
        print("ProfileViewController: - Did tap Logout Button!")
        print(ProfileImageService.shared.profileImageURL!)
    }
}
