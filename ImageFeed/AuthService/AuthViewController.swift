import UIKit

final class AuthViewController: UIViewController {
    
    //MARK: - Public Properties
    
    weak var delegate: AuthViewControllerDelegateProtocol?
    
    //MARK: - Private Properties
    
    private let webViewController = WebViewViewController()
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
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

//MARK: - WebViewViewControllerDelegateProtocol

extension AuthViewController: WebViewViewControllerDelegateProtocol {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                
                self.oAuth2TokenStorage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("AuthViewController webViewViewController (33) - Token request failed: \(error.localizedDescription)")
            }
        }
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}
