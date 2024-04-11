struct ProfileImageModel: Codable {
    let profileImage: ProfileImageURL
}

struct ProfileImageURL: Codable {
    let large: String
}

