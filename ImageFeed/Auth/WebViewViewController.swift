import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadAuthView()
        configureWebView()
        addAllSubview()
        setConstraints()
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else {
            print ("WebViewViewController:  urlComponents - initialization failure (string #18)")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.reirecrtURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else { 
            print ("WebViewViewController:  urlComponents.url is failure (string #27)")
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    private func configureWebView() {
        webView.backgroundColor = .ypWhite
    }
    
    private func addAllSubview() {
        view.addSubview(webView)
    }
    
    private func setConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 92),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    
}
