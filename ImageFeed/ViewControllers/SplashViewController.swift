import WebKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let showAuthenticationScreenSegueIdentifier = "showAuthView"
    private let showImageListScreenSegueIdentifier = "showImageListView"
    
    //UI
    private lazy var splashScreenLogo = UIImageView()
    
    //MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUISplashViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureCache()
        completedAuthorizationCheck(accessToken: KeychainWrapper.standard.string(forKey: "Auth token"))
    }
    
    //MARK: - Private Methods
    
    //UI
    private func  setUISplashViewController() {
        super.view.backgroundColor = .ypBlack
        view.addSubview(splashScreenLogo)
        splashScreenLogo.image = UIImage(named: "Unsplash Launch Screen Logo")
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splashScreenLogo.heightAnchor.constraint(equalToConstant: 77.68),
            splashScreenLogo.widthAnchor.constraint(equalToConstant: 75),
            splashScreenLogo.centerXAnchor.constraint(equalTo: super.view.centerXAnchor),
            splashScreenLogo.centerYAnchor.constraint(equalTo: super.view.centerYAnchor)
        ])
    }
    
    private func completedAuthorizationCheck(accessToken: String?) {
        UIBlockingProgressHUD.show()
        
        if let _ = accessToken {
            fetchProfile(token: KeychainWrapper.standard.string(forKey: "Auth token"))
            UIBlockingProgressHUD.dismiss()
        } else {
            switchToAuthViewController()
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func switchToTabBarController() {
        // Получаем экземпляр `window` приложения
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("SplashViewController (33) - Invalid window configuration")
            return
        }
        
        // Создаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
        
    }
    
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    
    private func fetchProfile(token: String?) {
        
        guard let token = token else
        {
            print("SplashViewController fetchProfile (51) - Token Is Missing!")
            return
        }
        
        UIBlockingProgressHUD.show()
        
        profileService.fetchUserProfileInfo(accesToken: token) { [weak self] result in
            
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
                case .success(let result):
                    self.switchToTabBarController()
                    fetchProfilePhoto(token: token, username: result.username)
                case.failure(let error):
                    print("SplashViewController fetchUserProfileInfo (100) - \(String(describing: error))")
                    return
            }
        }
    }
    
    private func fetchProfilePhoto(token: String, username: String) {
        
        profileImageService.fetchProfileImage(accesToken: token, username: username) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                case.success(_):
                    self.switchToTabBarController()
                case.failure(let error):
                    print("SplashViewController fetchProfileImage (114) - \(String(describing: error))")
                    return
            }
        }
    }
}

//MARK: - AuthViewControllerDelegateProtocol

extension SplashViewController: AuthViewControllerDelegateProtocol {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        fetchProfile(token: KeychainWrapper.standard.string(forKey: "Auth token"))
    }
}

