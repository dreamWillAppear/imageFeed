import UIKit

class SplashViewController: UIViewController {
    
    //MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let showAuthenticationScreenSegueIdentifier = "showAuthView"
    private let showImageListScreenSegueIdentifier = "showImageListView"
    
    //MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //отладочное
        //UserDefaults.standard.setValue("test", forKey: OAuth2TokenStorage.shared.tokenKey)
        //UserDefaults.standard.removeObject(forKey: OAuth2TokenStorage.shared.tokenKey)
        configureCache()
        completedAuthorizationCheck(accessToken: storage.token)
    }
    
    //MARK: - Private Methods
    
    private func completedAuthorizationCheck(accessToken: String?) {
        if let _ = accessToken {
            fetchProfile(token: storage.token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: self)
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
                print("SplashViewController fetchUserProfileInfo (71) - \(String(describing: error))")
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
                print("SplashViewController fetchProfileImage (96) - \(String(describing: error))")
                return
            }
            
        }
    
    }
}


//MARK: - Prepare for segue

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("SplashViewController (33) - Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - AuthViewControllerDelegateProtocol

extension SplashViewController: AuthViewControllerDelegateProtocol {
    func didAuthenticate(_ vc: AuthViewController) {
        performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: self)
        vc.dismiss(animated: true)
        fetchProfile(token: storage.token)
        
    }
}

