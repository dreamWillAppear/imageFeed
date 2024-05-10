import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var profileInfo: ImageFeed.ProfileInfo
    var view: ProfileViewControllerProtocol?
    var logoutDidCall = false
    var getProfileImageURLdidCall = false
    var getProfileInfoDidCall = false
    
    
    init(profileInfo: ImageFeed.ProfileInfo) {
        self.profileInfo = profileInfo
    }
    
    func logout() {
        logoutDidCall = true
    }
    
    func getProfileImageURL(from URLString: String?) -> URL? {
        getProfileImageURLdidCall = true
        return nil
    }
    
    func getProfileInfo(from profileModel: ImageFeed.ProfileModel?) {
        getProfileInfoDidCall = true
    }
    
}

