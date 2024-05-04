import UIKit
import Kingfisher
import SwiftKeychainWrapper
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    var profilePhoto: UIImageView { get set }
    func viewDidLoad()
}

class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    // MARK: - Public Properties
    
    lazy var profilePhoto = UIImageView()
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Private Properties
    
    private lazy var nameLabel = UILabel()
    private lazy var username = UILabel()
    private lazy var profileDescription = UILabel()
    private lazy var logoutButton = UIButton()
    private  var appDelegate = AppDelegate()
    private  var profileInfo = ProfileService.shared.profile
      
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        setUIProfileViewController()
    }
    
    func setProfileImage() {
       view.addSubview(profilePhoto)
        profilePhoto.layer.masksToBounds = true
       profilePhoto.image = UIImage(named: "ProfileImageStub")
       
        guard let url = presenter?.getProfileImageURL(from:  ProfileImageService.shared.profileImageURL)
       else {
           print("ProfileViewController setProfileImage(45) - profileImageURL is nil!")
           return
       }
       
      let roundProcessor = RoundCornerImageProcessor(cornerRadius: 61)
        
       profilePhoto.kf.setImage(
           with: url,
           placeholder: UIImage(named: "ProfileImageStub"),
           options: [
            .processor(roundProcessor)
              ]
       )
   }
    
    
    // MARK: - Private Methods
        
    private func setUIProfileViewController() {
        super.view.backgroundColor = .ypBlack
        updateProfileDetails(profile: profileInfo) //Getting data from ProfileService
        setProfileImage()
        setProfileNameLabelStyle()
        setProfileUsernameStyle()
        setProfileDescriptionStyle()
        setLogoutButton()
        setConstraints()
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
            with: UIImage(systemName: "ipad.and.arrow.forward") ?? .profileImageStub,
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
    
    private func logoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        
        let approveLogoutButton =  UIAlertAction(title: "Да", style: . default) { [weak self] _ in
            guard let self = self else {return}
            self.presenter?.logout()
        }
        
        let cancelButton = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(approveLogoutButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - @objc
    let imagesService = ImagesListService()
    @objc
    private func didTapLogoutButton() {
        logoutAlert()
    }
}
