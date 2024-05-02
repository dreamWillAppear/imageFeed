import Foundation

public protocol WebViewPresenterProtocol {
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    // MARK: - Public Properties
    var authHelper: AuthHelperProtocol
    weak var view: WebViewViewControllerProtocol?
    
    // MARK: - Initializers
    
    init(authHelper: AuthHelperProtocol, view: WebViewViewControllerProtocol? = nil) {
        self.authHelper = authHelper
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        loadWebView()
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
            let newProgressValue = Float(newValue)
            view?.setProgressValue(newProgressValue)
            
            let shouldHideProgress = shouldHideProgress(for: newProgressValue)
            view?.setProgressHidden(shouldHideProgress)
        }
        
        func shouldHideProgress(for value: Float) -> Bool {
            abs(value - 1.0) <= 0.0001
        }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    
    // MARK: - Private Methods

    private func loadWebView() {
        guard let requset = authHelper.authRequsest() else {
            return
        }
        view?.load(request: requset)
    }
}


// MARK: - Public Properties

// MARK: - IBOutlet

// MARK: - Private Properties

// MARK: - Initializers

// MARK: - UIViewController(*)

// MARK: - Public Methods

// MARK: - IBAction

// MARK: - Private Methods
