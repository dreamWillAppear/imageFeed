import UIKit

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    
    // MARK: - Public Properties
    
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession(configuration: .default)
    private var urlString = Constants.unsplashProfileRequestBaseURLString
    private var accessToken = OAuth2TokenStorage.shared.token
    private var taskIsActive = false
    private(set) var profile: ProfileModel?
    
    //MARK: - Public Methods
    
    func fetchUserProfileInfo(accesToken: String?, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if taskIsActive {
            print("ProfileService fetchUserProfileInfo(37) - User Profile Info Request is already in progress!")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        guard let accesToken = accesToken else
        {
            completion(.failure(ProfileServiceError.invalidRequest))
            print("ProfileService fetchUserProfileInfo(31) - Acces Token is nil")
            return
        }
        
        guard let request = requestProfileInfo(token: accesToken) else
        {
            completion(.failure(ProfileServiceError.invalidRequest))
            print("ProfileService fetchUserProfileInfo(42) - Failed to create request")
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                
                guard
                    let data = data,
                    let statusCode = (response as? HTTPURLResponse)?.statusCode else
                {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        print("ProfileService fetchUserProfileInfo(60) - Unknown error")
                        completion(.failure(ProfileServiceError.invalidRequest))
                    }
                    return
                }
                
                print("ProfileService fetchUserProfileInfo  \(statusCode)")
                
                switch statusCode {
                case 200...299:
                    do {
                        let result = try decoder.decode(ProfileResponseBodyModel.self, from: data)
                        let profile = ProfileModel(from: result)
                        self.profile = profile
                        completion(.success(profile))
                    } catch {
                        print("fetchUserProfileInfo error: \(String(describing: error))")
                        completion(.failure(error))
                    }
                default:
                    completion(.failure(ProfileServiceError.invalidRequest))
                }
                self.taskIsActive = false
            }
        }
        taskIsActive = true
        task.resume()
    }
    
    
    // MARK: - Private Methods
    
    private init() {}
    
    private func requestProfileInfo(token: String) -> URLRequest? {
        
        guard let url = URL(string: urlString) else
        {
            print("ProfileService requestProfileInfoRequest(32) - Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        print(request)
        
        return request
        
    }
    
}
