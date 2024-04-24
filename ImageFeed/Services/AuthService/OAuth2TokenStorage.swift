import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    //token записывается в методе webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) класса AuthViewController
    var token = KeychainWrapper.standard.string(forKey: "Auth token")
    
}
