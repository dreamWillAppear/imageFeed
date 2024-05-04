import Foundation

final class ProfileImageService {
    
    enum ProfileImageServiceError: Error {
        case invalidRequest
    }
    
    // MARK: - Public Properties
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProvoderDidChange")
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession(configuration: .default)
    private var urlString = Constants.unsplashProfileImageRequestBaseURLString
    private var taskIsActive = false
    private var profileImage: ProfileImageModel?
    private(set) var profileImageURL: String?
    
    // MARK: - Public Methods
    
    func fetchProfileImage(accesToken: String?, username: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if taskIsActive {
            print("ProfileImageService fetchProfileImage(20) - User Profile Image Request is already in progress!")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        guard let accesToken = accesToken else
        {
            completion(.failure(ProfileServiceError.invalidRequest))
            print("ProfileImageService fetchProfileImage(32) - Acces Token is nil")
            return
        }
        
        guard let request = requestProfileImage(accessToken: accesToken, username: username) else
        {
            completion(.failure(ProfileServiceError.invalidRequest))
            print("ProfileImageService fetchProfileImage(39) - Failed to create request")
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileImageModel ,Error>) in
            
            guard let self = self else { return }
            
            switch result {
                case .success(let responseBody):
                    let profileImage = responseBody
                    self.profileImage = profileImage
                    self.profileImageURL = profileImage.profileImage.large
                    completion(.success(profileImage.profileImage.large))
                case .failure(let error):
                    completion(.failure(error))
            }
            self.taskIsActive = false
        }
        taskIsActive = true
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private init() {}
    
    private func updateTableViewAnimated() {
        
    }
    
    private func requestProfileImage(accessToken: String, username: String) -> URLRequest? {
        
        let urlString = urlString + username
        guard let url = URL(string: urlString) else
        {
            print("ProfileImageService requestProfileImage(96) - Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        return request
    }
}
