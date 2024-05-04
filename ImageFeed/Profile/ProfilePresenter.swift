import Foundation
import SwiftKeychainWrapper
import WebKit

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()
    
}

final class ProfileViewPresenter: ProfilePresenterProtocol {

    // MARK: - Public Properties
    
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        print("PRESENTER!!")
    }
    
    func logout() {
        print("presenter!!!!logout")
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
