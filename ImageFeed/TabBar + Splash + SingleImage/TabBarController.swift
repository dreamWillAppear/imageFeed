import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Public Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard  let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { 
            print("TabBarController awakeFromNib - Unable to instantiate ImagesListViewController from storyboard!")
            return
        }
        
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        let profileVewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenter()
        profileVewController.presenter = profilePresenter
        
        
        
        configureTabBarButtonsFor(profileVewController, and: imagesListViewController)
        
        self.viewControllers = [imagesListViewController, profileVewController]
        
    }
    
    // MARK: - Private Methods
    
    private func configureTabBarButtonsFor(_ profileViewController: UIViewController, and imagesListViewController: UIViewController) {
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(
                named: "Tab Profile Active"
            ),
            selectedImage: nil
        )
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "Tab Editorial Active"),
            selectedImage: nil
        )
        
    }
}
