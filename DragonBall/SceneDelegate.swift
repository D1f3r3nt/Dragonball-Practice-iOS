import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Prepara escena
        guard let scene = (scene as? UIWindowScene) else {
            return
        }
        let window = UIWindow(windowScene: scene)
        
        // Referencia de pantalla
        let viewController = LogInViewController()
        
        // Referencia NavigationController
        let navController = UINavigationController(rootViewController: viewController)
        
        // Especificar la referencia inicial
        window.rootViewController = navController
        
        // Hacer visible la referencia
        window.makeKeyAndVisible()
        self.window = window
    }
}
