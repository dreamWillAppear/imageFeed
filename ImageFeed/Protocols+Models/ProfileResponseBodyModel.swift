struct ProfileResponseBodyModel: Codable {
    let username: String
    let firstName: String //First name can't be blank
    let lastName: String?
    let bio: String?
    
}
