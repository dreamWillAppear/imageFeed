import UIKit

protocol AuthViewControllerDelegateProtocol: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
