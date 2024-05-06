import UIKit
import SwiftKeychainWrapper

final class ImagesListService {
    
    // MARK: - Public Properties
    
    static let shared = ImagesListService()
    
    // MARK: - Private Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let accessToken = KeychainWrapper.standard.string(forKey: "Auth token")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var taskIsActive = false
    private var likeTaskIsActive = false
    
    // MARK: - Public Methods
    
    func  fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard taskIsActive == false else {
            print("ImagesListService fetchPhotosNextPage - task is already active!")
            return
        }
        
        guard let token = accessToken else {
            print("ImagesListService fetchPhotosNextPage - missing token!")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 1)
        
        guard let request = makePhotosRequest(token: token, page: nextPage) else {
            print("ImagesListService fetchPhotosNextPage - failed to create request!")
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            
            guard let self = self else {
                print("ImagesListService fetchPhotosNextPage - self is nil!")
                return
            }
            
            switch result {
                case .success(let photosResult):
                    self.lastLoadedPage = nextPage + 1
                    self.photos += makePhotosArray(from: photosResult)
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                    object: self)
                case.failure(let error):
                    print( "ImagesListService fetchPhotosNextPage - failed to get photos! \(String(describing: error))")
            }
            self.taskIsActive = false
        }
        taskIsActive = true
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<IsLiked, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard taskIsActive == false else {
            print("Like Task Is Already Active!")
            return
        }
        
        taskIsActive = true
        let urlString = Constants.defaultBaseURLString + "photos/\(photoId)/like"
        
        let url = URL(string: urlString)
        guard
            let url = url,
            let token = accessToken else {
            print("changeLike - failed to create url or token is bad!")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" :  "DELETE"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        print(request)
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<IsLiked, Error>) in
            guard self != nil else { return }
            switch result {
                case.success(let result):
                    completion(.success(result))
                case.failure(let error):
                    completion(.failure(error))
                    print("changeLike error - \(String(describing: error))")
            }
        }
        taskIsActive = false
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private init() {}
    
    private func makePhotosArray(from photoResultArray: [PhotoResult]) -> [Photo] {
        var photosArray: [Photo] = []
        
        for result in photoResultArray {
            let photo = Photo(from: result)
            if !photosArray.contains(where: {
                $0.id != photo.id
            }) {
                photosArray.append(photo)
            }
        }
        return photosArray
    }
    
    private func makePhotosRequest(token: String, page: Int) -> URLRequest? {
        guard var urlString = URLComponents(string: Constants.unsplashRequestPhotosURLString) else {
            print("makePhotosRequest - failed to create urlString!")
            return nil
        }
        
        urlString.queryItems = [
            URLQueryItem(name: "per_page", value: "3"),
            URLQueryItem(name: "page", value: String("\(page)"))
        ]
        
        guard let url = urlString.url else {
            print("makePhotosRequest - failed to create url!")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        return request
    }
}

