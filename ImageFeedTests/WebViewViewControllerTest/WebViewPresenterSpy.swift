import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var view: WebViewViewControllerProtocol?
    var viewDidLoadCalled = false
    var loadRequestCalled = false
    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        load(request: nil)
    }
    
    func load(request: URLRequest?) {
        loadRequestCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        nil
    }
    
}
