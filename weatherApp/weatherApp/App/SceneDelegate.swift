//
//  SceneDelegate.swift
//  weatherApp
//
//  Created by Roman Romanyshyn on 08.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        if let window = window {
            let appCoordinator = Coordinator(window: window)

            coordinator = appCoordinator
            appCoordinator.start()
        }
    }
}

//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//    var window: UIWindow?
//    var coordinator: AppCoordinator?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//
//        let navigation = UINavigationController()
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//
//        if let window = window {
//            let appCoordinator = AppCoordinator(with: AppCoordinator.Config(navigation, window))
//
//            coordinator = appCoordinator
//            appCoordinator.start()
//        }
//        return true
//    }
//}

