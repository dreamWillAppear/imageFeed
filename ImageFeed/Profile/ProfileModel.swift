public struct ProfileModel {
    var username: String
    var nameLabel: String
    var bio: String
    
    init(from body: ProfileResponseBodyModel) {
        self.username = body.username
        self.nameLabel = body.firstName + " " + (body.lastName ?? "")
        self.bio = body.bio ?? ""
    }
}

