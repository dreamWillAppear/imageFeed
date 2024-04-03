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
    private let accessToken = OAuth2TokenStorage.shared.token
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
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [self] in
                
                guard
                    let data = data,
                    let statusCode = (response as? HTTPURLResponse)?.statusCode else
                {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        print("ProfileImageService fetchUserProfileImage(58) - Unknown error")
                        completion(.failure(ProfileServiceError.invalidRequest))
                    }
                    return
                }
                
                print("ProfileImageService fetchProfileImage  \(statusCode)")
                
                switch statusCode {
                case 200...299:
                    do {
                        let result = try decoder.decode(ProfileImageModel.self, from: data)
                        let profileImage = result
                        self.profileImage = profileImage
                        self.profileImageURL = profileImage.profileImage.small
                        completion(.success(profileImage.profileImage.small))
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.didChangeNotification,
                                object: self,
                                userInfo: ["URL": profileImageURL]
                            )
                    } catch {
                        print("fetchProfileImage error: \(String(describing: error))")
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
        print(request)
        
        return request
        
    }
    
}
