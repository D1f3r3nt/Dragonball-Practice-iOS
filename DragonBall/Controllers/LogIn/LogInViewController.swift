import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    let network = NetworkModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapLogin(_ sender: Any) {
        let home = HomeTableViewController()
        
        zoomOut()
        
        network.login(
            user: usernameTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ) { [weak self] result in
            
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self?.navigationController?.setViewControllers([home], animated: true)
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self?.present(AlertModel.noAuthorizetAlert(), animated: true)
                    }
            }
        }
    }
    
    @IBAction func didTouchingLogin(_ sender: Any) {zoomIn()}
}

//MARK: - Frontend Features
extension LogInViewController {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.buttonLogin.transform = .identity.scaledBy(x: 0.94, y: 0.94)
        }
    }
    
    func zoomOut() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.buttonLogin.transform = .identity
        }
    }
}
