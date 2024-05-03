import Foundation

protocol AuthHelperProtocol {
    func authRequsest() -> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standart) {
        self.configuration = configuration
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.unsplashAuthorizeURLString) else {
            print ("AuthHelper - Failed to create URL for loadAuthView")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents.url
    }
    
    func authRequsest() -> URLRequest? {
        guard let url = authURL() else {
            print ("AuthHelper authRequsest - Failed to get URL for loadAuthView")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
}
