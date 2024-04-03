import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession(configuration: .default)
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code  else {
            DispatchQueue.main.async {
                completion(.failure(AuthServiceError.invalidRequest))
            }
            return
        }
        
        lastCode = code
        
        guard let urlRequest = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if
                    let data = data,
                    let statusCode =  (response as? HTTPURLResponse)?.statusCode {
                    switch statusCode {
                        case 200...299:
                            print("fetchOAuthToken - Status Code = \(statusCode)")
                            do {
                                let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                                    completion(.success(response.accessToken))
                            } catch {
                                    print("fetchOAuthToken error: \(String(describing: error))")
                                    completion(.failure(error))
                            }
                        default:
                            guard let error = error else { return }
                            print("fetchOAuthToken - Status Code = \(statusCode) \n fetchOAuthToken error: \(String(describing: error))")
                                completion(.failure(error))
                    }
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlString = URLComponents(string: Constants.unsplashTokenRequestBaseURLString) else { return nil }
        urlString.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirecrtURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: Constants.grandType)
        ]
        guard let url = urlString.url else {
            print("Failed to create URL with baseURL and parameters.")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
}
