import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let network = NetworkModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didTapLogin(_ sender: Any) {
        
        let home = HomeTableViewController()
        
        network.login(
            user: usernameTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ) { [weak self] result in
            
            switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self?.navigationController?.show(home, sender: nil)
                    }
                    
                case let .failure(error):
                    print("Error: \(error)")
            }
        }
    }
}
