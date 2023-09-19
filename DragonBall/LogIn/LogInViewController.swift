import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func didTapLogin(_ sender: Any) {
        let model = NetworkModel()
        model.login(
            user: usernameTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ) { result in
            switch result {
                case let .success(token):
                    print("Token: \(token)")
                    model.getHeroes(token: token) { result in
                        switch result {
                            case let .success(heroes):
                                print("Heroes: \(heroes)")
                            case let .failure(error):
                                print("Error: \(error)")
                        }
                        
                    }
                case let .failure(error):
                    print("Error: \(error)")
            }
        }
    }
}
