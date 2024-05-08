import Foundation
import SwiftKeychainWrapper
import WebKit


public struct ProfileInfo {
    var username: String
    var nameLabel: String
    var profileDescription: String
}

public protocol ProfilePresenterProtocol {
    var profileInfo: ProfileInfo { get set }
    func logout()
    func getProfileImageURL(from URLString: String?) -> URL?
    func getProfileInfo(from profileModel: ProfileModel?)
}

final class ProfileViewPresenter: ProfilePresenterProtocol {
    
    // MARK: - Public Properties
    
    weak var view: ProfileViewControllerProtocol?
    var profileInfo = ProfileInfo(username: "", nameLabel: "", profileDescription: "")
    
    // MARK: - Public Methods
    
    func logout() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
        ) { records in
            records.forEach {
                record in
                WKWebsiteDataStore.default().removeData(
                    ofTypes: record.dataTypes,
                    for: [record],
                    completionHandler: {}
                )
            }
        }
        
        KeychainWrapper.standard.remove(forKey: "Auth token")
        guard let window = UIApplication.shared.windows.first else {fatalError("ProfileViewPresenter logout - Fatal error!")}
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    func getProfileImageURL(from URLString: String?) -> URL? {
        guard let urlString = URLString else {
            print("ProfilePresenter getProfileImageURL - Failed to get URLString")
            return nil
        }
        return  URL(string: urlString)
    }
    
    func getProfileInfo(from profileModel: ProfileModel?) {
        guard let profileModel else
        {
            print("ProfilePresenter getProfileInfo - Failed to get data from ProfileService!")
            return
        }
        profileInfo.username = profileModel.username
        profileInfo.nameLabel = profileModel.nameLabel
        profileInfo.profileDescription = profileModel.bio
    }
    
}

// MARK: - Types

// MARK: - Constants

// MARK: - Public Properties

// MARK: - IBOutlet

// MARK: - Private Properties

// MARK: - Initializers

// MARK: - UIViewController(*)

// MARK: - Public Methods

// MARK: - IBAction

// MARK: - Private Methods
