//
//  SceneDelegate.swift
//  DragonBall
//
//  Created by Marc Santisteban Ruiz on 28/8/23.
//

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
        
        // Especificar la referencia inicial
        window.rootViewController = viewController
        
        // Hacer visible la referencia
        window.makeKeyAndVisible()
        self.window = window
    }


}

