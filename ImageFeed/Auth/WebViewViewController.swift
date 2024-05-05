import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegateProtocol: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {

    //MARK: - Public Properties
    
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegateProtocol?
    
    //MARK: - IBOutlet
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var backwardButton: UIButton!
    
    //MARK: - Private Properties
    
    private lazy var progressView = UIProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
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
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             }
        )
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    //MARK: - IBAction
    
    @IBAction func didTapBackwardButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
        
    }
    
    //MARK: - Private Methods
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
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
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
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


