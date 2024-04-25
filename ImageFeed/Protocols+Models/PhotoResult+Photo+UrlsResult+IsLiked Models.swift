import Foundation

//MARK: - Types

struct Photo: Codable {
    let id: String
    let size: CGSize
    let createdAt: String
    let welcomeDescription: String?
    let thumbImageURL: URL?
    let fullImageURL: URL?
    let likedByUser: Bool
    
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = result.createdAt
        self.welcomeDescription = result.description
        self.thumbImageURL = URL(string: result.urls.regular) 
        self.fullImageURL = URL(string: result.urls.full)
        self.likedByUser = result.likedByUser
    }
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width: CGFloat
    let height: CGFloat
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct IsLiked: Codable {
    let photo: PhotoResult
}
