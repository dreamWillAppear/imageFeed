import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    //MARK: - Public Properties
    
    weak var delegate: WebViewViewControllerDelegateProtocol?
    
    //MARK: - IBOutlet
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var backwardButton: UIButton!
    
    //MARK: - Private Properties
    
    private var progressView = UIProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Public Methods
    
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
        
     estimatedProgressObservation =  webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else {return}
                 updateProgress()
             }
        )
    }
    
    //MARK: - IBAction
    
    @IBAction func didTapBackwardButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
        
    }
    
    //MARK: - Private Methods
    
    private func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1) <= 0.0001
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirecrtURI),
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
    
    private func configureProgressView() {
        progressView.progressViewStyle = .default
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

//MARK: - WKNavigationDelegate

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


