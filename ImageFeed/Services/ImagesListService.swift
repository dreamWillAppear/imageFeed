import Foundation

final class ImagesListService {
    
    //MARK: - Types
    
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        let isLiked: Bool
    }
    
    struct PhotoResult: Codable {
        let id: String
        let createdAt: String
        let likedByUser: Bool
        let description: String?
    }
    
    struct UrlsResult: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var taskIsActive = false
    
    // MARK: - Public Methods
    
    func  fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage ?? 0 ) + 1
    }
    
    // MARK: - Private Methods
    
    
}



// MARK: - Public Properties

// MARK: - IBOutlet

// MARK: - Private Properties

// MARK: - Initializers

// MARK: - UIViewController(*)

// MARK: - Public Methods

// MARK: - IBAction

// MARK: - Private Methods
