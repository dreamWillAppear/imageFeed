import UIKit

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    //token записывается в методе webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) класса AuthViewController
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "ImageFeedAuthToken")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "ImageFeedAuthToken")
        }
    }
}
