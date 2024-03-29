import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let profilePhoto = UIImageView()
    private let username = UILabel()
    private let nickname = UILabel()
    private let profileDescription = UILabel()
    private var logoutButton = UIButton()
    private let appDelegate = AppDelegate()
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIProfileViewController()
    }
    
    // MARK: - Private Methods
    
    private func setUIProfileViewController() {
        setProfileImageStyle()
        setProfileUsername()
        setProfileNickname()
        setProfileDescription()
        setLogoutButton()
        setConstraints()
    }
    
    private func setProfileImageStyle() {
        profilePhoto.image = UIImage(named: "User Mock Photo")
        view.addSubview(profilePhoto)
    }
    
    private func setProfileUsername() {
        username.text = "Екатерина Новикова"
        username.font = .boldSystemFont(ofSize: 23)
        username.textColor = .ypWhite
        view.addSubview(username)
    }
    
    private func setProfileNickname() {
        nickname.text = "@ekaterina_nov"
        nickname.font = .systemFont(ofSize: 13)
        nickname.textColor = .ypGray
        view.addSubview(nickname)
    }
    
    private func setProfileDescription() {
        profileDescription.text = "Hello, world!"
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
        username.translatesAutoresizingMaskIntoConstraints = false
        nickname.translatesAutoresizingMaskIntoConstraints = false
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //profilePhoto
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70),
            profilePhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            //username
            username.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8),
            username.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            
            //nickname
            nickname.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 8),
            nickname.leadingAnchor.constraint(equalTo: username.leadingAnchor),
            
            //profileDescription
            profileDescription.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 8),
            profileDescription.leadingAnchor.constraint(equalTo: nickname.leadingAnchor),
            
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
        UserDefaults.standard.removeObject(forKey: OAuth2TokenStorage.shared.tokenKey)
        appDelegate.resetApp()
    }
}
