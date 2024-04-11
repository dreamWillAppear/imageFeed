import UIKit
import ProgressHUD
import SwiftKeychainWrapper

final class AuthViewController: UIViewController {
    
    //MARK: - Public Properties
    
    weak var delegate: AuthViewControllerDelegateProtocol?
    
    //MARK: - Private Properties
    
    private let webViewController = WebViewViewController()
    private let oAuth2Service = OAuth2Service.shared
    
    //MARK: - Public Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else  { fatalError("AuthViewController (19) - Failed to prepare segue") }
            webViewViewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Private Methods

private func showAuthErrorAlert() -> UIViewController {
    let alert = UIAlertController(
        title: "Что-то пошло не так(",
        message: "Не удалось войти в систему",
        preferredStyle: .alert
    )
    
    let action = UIAlertAction(title: "Ок", style: .default) { _ in
        alert.dismiss(animated: true)
    }
    
    alert.addAction(action)
    
    return alert
}

//MARK: - WebViewViewControllerDelegateProtocol

extension AuthViewController: WebViewViewControllerDelegateProtocol {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
                case .success(let token):
                    KeychainWrapper.standard.set(token, forKey: "Auth token")
                    let isSuccess = KeychainWrapper.standard.set(token, forKey: "Auth token")
                    guard isSuccess else {
                        print("AuthViewController webViewViewController (33) -  Failed to write access token to Keychain!")
                        return
                    }
                    self.delegate?.didAuthenticate(self)
                case .failure(let error):
                    print("AuthViewController webViewViewController (33) - Token request failed: \(String(describing: error))")
                    present(showAuthErrorAlert(), animated: true)
            }
        }
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}
