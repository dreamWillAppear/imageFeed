import UIKit

class SplashViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private let showAuthenticationScreenSegueIdentifier = "showAuthView"
    private let showImageListScreenSegueIdentifier = "showImageListView"
    
    //MARK: - Public Methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //отладочное
        //UserDefaults.standard.setValue("test", forKey: OAuth2TokenStorage.shared.tokenKey)
        //UserDefaults.standard.removeObject(forKey: OAuth2TokenStorage.shared.tokenKey)
        
        completedAuthorizationCheck(accessToken: OAuth2TokenStorage.shared.token)
    }
    
    //MARK: - Private Methods
    
    private func completedAuthorizationCheck(accessToken: String?) {
        if let _ = accessToken {
            switchToTabBarController()
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
        switchToTabBarController()
        vc.dismiss(animated: true)
        performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: self)
    }
}
