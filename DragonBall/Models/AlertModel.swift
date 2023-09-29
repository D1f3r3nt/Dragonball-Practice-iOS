import UIKit

class AlertModel {
    static func noAuthorizetAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Not authorized",
            message: "Your username or passowrd is not valid",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Okey", style: .cancel))
        return alert
    }
}
