//
//  SceneDelegate.swift
//  PrimeWords
//
//  Created by Aaron Tunney on 13/01/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var view: UIViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

        createRootModule(scene)
    }
}

extension SceneDelegate {
    func createRootModule(_ scene: UIWindowScene) {
        guard let view = HomeRouter.createModule()
            else { return }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = scene

        window?.rootViewController = view
        window?.makeKeyAndVisible()

        self.view = view
    }
}
