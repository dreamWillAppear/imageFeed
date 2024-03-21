import UIKit

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}


/*https://unsplash.com/documentation/user-authentication-workflow
 If successful, the response body will be a JSON representation of your user’s access token:
 
 {
 "access_token": "091343ce13c8ae780065ecb3b13dc903475dd22cb78a05503c2e0c69c5e98044",
 "token_type": "bearer",
 "scope": "public read_photos write_photos",
 "created_at": 1436544465
 }*/
