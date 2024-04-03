struct ProfileResponseBodyModel: Codable {
    let username: String
    let firstName: String //First name can't be blank
    let lastName: String?
    let bio: String?

}

/*
 {
 "id": "pXhwzz1JtQU",
 "updated_at": "2016-07-10T11:00:01-05:00",
 "username": "jimmyexample",
 "first_name": "James",
 "last_name": "Example",
 "twitter_username": "jimmy",
 "portfolio_url": null,
 "bio": "The user's bio",
 "location": "Montreal, Qc",
 "total_likes": 20,
 "total_photos": 10,
 "total_collections": 5,
 "followed_by_user": false,
 "downloads": 4321,
 "uploads_remaining": 4,
 "instagram_username": "james-example",
 "location": null,
 "email": "jim@example.com",
 "links": {
 "self": "https://api.unsplash.com/users/jimmyexample",
 "html": "https://unsplash.com/jimmyexample",
 "photos": "https://api.unsplash.com/users/jimmyexample/photos",
 "likes": "https://api.unsplash.com/users/jimmyexample/likes",
 "portfolio": "https://api.unsplash.com/users/jimmyexample/portfolio"
 }
 }
 */
