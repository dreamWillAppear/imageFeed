import UIKit

class AuthViewController: UIViewController {
    
    private let unsplashLogo = UIImageView()
    @IBOutlet private var loginButton: UIButton!
    //private let loginButton = UIButton(type: .system)
    private let webViewController = WebViewViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBackground
    
        addAllSubbview()
        configureUnsplashLogo()
   //  configureLoginButton()
        configureBackButton()
        setConstraints()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Nav Back Button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .ypBlack
    }
    
    private func configureUnsplashLogo() {
        unsplashLogo.image = UIImage(named: "Logo of Unsplash")
    }
    
    private func configureLoginButton() {
        loginButton.backgroundColor = .ypWhite
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        loginButton.layer.cornerRadius = 16
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    private func addAllSubbview() {
        [unsplashLogo,loginButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        [unsplashLogo,loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            //unsplashLogo
            unsplashLogo.widthAnchor.constraint(equalToConstant: 60),
            unsplashLogo.heightAnchor.constraint(equalToConstant: 60),
            unsplashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unsplashLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            //loginButton
            loginButton.widthAnchor.constraint(equalToConstant: 343),
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90)
        ])
    }
    
    
    
    @objc
    private func didTapLoginButton() {

        self.navigationController?.pushViewController(webViewController, animated: true)
    }

}


//Вы можете сверстать кнопку «Назад» с помощью UIButton и @IBAction. Для этого в решении можно изменить тип сегвея на Present Modally (Kind = Present Modally, Presentation = Over Full Screen), а верхний констрейнт WebView установить равным нижней границе кнопки «Назад». Для реализации функции закрытия экрана можно использовать dismiss, как мы уже делали для SingleImageViewController
