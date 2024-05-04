import Foundation
import SwiftKeychainWrapper
import WebKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()
    func getProfileImageURL(from URLString: String?) -> URL?
    
}

final class ProfileViewPresenter: ProfilePresenterProtocol {
    
    // MARK: - Public Properties
    
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        
    }
    
    func logout() {
        view?.profilePhoto.image = .stub
        
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
