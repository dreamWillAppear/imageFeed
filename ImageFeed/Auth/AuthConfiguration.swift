import Foundation

enum Constants {
    static let accessKey = "NldrMyPrwcMXq0g5OliQiG7imahCMw90CU5lPSa5Gbs"
    static let secretKey = "RUGHoaLSINPAPWE9PjiWnta8E7Nx3OlDpwbOdykJwAQ"
    static let redirecrtURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURLString = "https://api.unsplash.com/"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenRequestBaseURLString = "https://unsplash.com/oauth/token"
    static let grandType = "authorization_code"
    
    static let unsplashProfileRequestBaseURLString = "https://api.unsplash.com/me"
    static let unsplashProfileImageRequestBaseURLString = "https://api.unsplash.com/users/"
    static let unsplashRequestPhotosURLString = "https://api.unsplash.com/photos"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let unsplashAuthorizeURLString: String
    let unsplashTokenRequestBaseURLString: String
    let grandType: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURLString: String, unsplashAuthorizeURLString: String, unsplashTokenRequestBaseURLString: String, grandType: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.unsplashTokenRequestBaseURLString = unsplashTokenRequestBaseURLString
        self.grandType = grandType
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirecrtURI,
            accessScope: Constants.accessScope,
            defaultBaseURLString: Constants.defaultBaseURLString, 
            unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString,
            unsplashTokenRequestBaseURLString: Constants.unsplashTokenRequestBaseURLString,
            grandType: Constants.grandType
        )
    }
}
