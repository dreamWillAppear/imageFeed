import UIKit

class AuthViewController: UIViewController, WebViewViewControllerDelegateProtocol {
    
    private let webViewViewController = WebViewViewController()
    private let showWebView = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = .backwardButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = .backwardButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebView{
            guard
                let webViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebView)")}
            webViewController.delete(self)
        } else {
                super.prepare(for: segue, sender: sender)
            }
        }
        
        func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
            <#code#>
        }
        
        func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
            dismiss(animated: true)
        }
    }
    
