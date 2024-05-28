//
//  SceneDelegate.swift
//  DNS_test
//
//  Created by Vagan Galstian on 27.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            
            let navigationController = UINavigationController()
            let assemblyBuilder = AssemblyModuleBuilder()
            let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
            router.initialLibraryVC()
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
}
