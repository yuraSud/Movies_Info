//
//  SceneDelegate.swift
//  Movies
//
//  Created by Olga Sabadina on 04.01.2024.
//
import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        FirebaseApp.configure()
        
        let startVC = LoginViewController()
        let navigationVC = UINavigationController(rootViewController: startVC)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator.init(navigationVC, type: .app)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationVC.navigationBar.tintColor = .label
        navigationVC.navigationBar.standardAppearance = appearance
        navigationVC.navigationBar.compactAppearance = appearance
        navigationVC.navigationBar.scrollEdgeAppearance = appearance
    }
}

