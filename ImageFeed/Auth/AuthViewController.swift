import UIKit

final class AuthViewController: UIViewController {
    
    private let webViewController = WebViewViewController()
    private let oAuth2Service = OAuth2Service.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
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

extension AuthViewController: WebViewViewControllerDelegateProtocol {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        oAuth2Service.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                //self.oAuth2TokenStorage.token = token
                print("token is \(token)")
            case .failure(let error):
                print("AuthViewController webViewViewController (33) - Token request failed: \(error.localizedDescription)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}
