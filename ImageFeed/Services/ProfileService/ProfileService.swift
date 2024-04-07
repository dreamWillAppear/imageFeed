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
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResponseBodyModel, Error>) in
            
            guard let self = self else { return }
            
            switch result {
            case.success(let responseBody):
                let profile = ProfileModel(from: responseBody)
                self.profile = profile
                completion(.success(profile))
            case.failure(let error):
                completion(.failure(error))
            }
            self.taskIsActive = false
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
        
        return request
    }
}
