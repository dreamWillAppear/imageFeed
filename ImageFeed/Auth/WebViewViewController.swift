import UIKit
import WebKit

class WebViewViewController: UIViewController {

    weak var delegate: WebViewViewControllerDelegateProtocol?
    private var progressView = UIProgressView()
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var backwardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webView.navigationDelegate = self
        loadAuthView()
        configureProgressView()
        addAllSubviews()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.removeObserver(self, forKeyPath:
                                #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
 
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.reirecrtURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print ("WebViewViewController(56) - Failed to create URL for loadAuthView")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @IBAction func didTapBackwardButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
        
    }
    
    override func observeValue(
        forKeyPath keyPath:
        String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                updateProgress()
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1) <= 0.0001
    }
    
    private func configureProgressView() {
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = .black
        
    }
    
    private func addAllSubviews() {
        [
            progressView
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        [
            progressView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: backwardButton.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
    
extension WebViewViewController: WKNavigationDelegate {
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            print(url.absoluteString)
            print("codeItem is \(String(describing: codeItem.value))")
            return codeItem.value
        } else {
            print("code is nil")
            return nil
        }
}

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
}
