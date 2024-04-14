import UIKit
import SwiftKeychainWrapper

final class ImagesListService {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let accessToken = KeychainWrapper.standard.string(forKey: "Auth token")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var taskIsActive = false
    
    // MARK: - Public Methods
    
    func  fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard taskIsActive == false else {
            print("ImagesListServicen fetchPhotosNextPage - task is already active!")
            return
        }
        
        guard let token = accessToken else {
            print("ImagesListServicen fetchPhotosNextPage - missing token!")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0 ) + 1
        
        guard let request = makePhotosRequest(token: token, page: nextPage) else {
            print("ImagesListServicen fetchPhotosNextPage - failed to create request!")
            return
        }
        
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            
            guard let self = self else {
                print("ImagesListServicen fetchPhotosNextPage - self is nil!")
                return
            }
            
            switch result {
            case .success(let photosResult):
                lastLoadedPage = nextPage
                photos += makePhotosArray(from: photosResult)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification,
                                                                   object: self)
            case.failure(let error):
                print( "ImagesListServicen fetchPhotosNextPage - failed to get photos! \(String(describing: error))")
            }
            self.taskIsActive = false
        }
        taskIsActive = true
        task.resume()
    }
    
    
    // MARK: - Private Methods
    
 
    
    private func makePhotosArray(from photoResultArray: [PhotoResult]) -> [Photo] {
        var photosArray: [Photo] = []
        
        for result in photoResultArray {
            let photo = Photo(from: result)
            photosArray.append(photo)
        }
        return photosArray
    }
    
    private func makePhotosRequest(token: String, page: Int) -> URLRequest? {
        guard var urlString = URLComponents(string: Constants.unsplashRequestPhotosURLString) else {
            print("makePhotosRequest - failed to create urlString!")
            return nil
        }
        //TODO: Перед сдачей на ревью, на всякий случай пояснить внутри ПР почему опущен параметр "per_page" - потому что дефолтно и так 10 Number of items per page. (Optional; default: 10)
        urlString.queryItems = [
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




// MARK: - Public Properties

// MARK: - IBOutlet

// MARK: - Private Properties

// MARK: - Initializers

// MARK: - UIViewController(*)

// MARK: - Public Methods

// MARK: - IBAction

// MARK: - Private Methods
