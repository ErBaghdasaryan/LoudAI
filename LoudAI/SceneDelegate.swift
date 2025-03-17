//
//  SceneDelegate.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit
import LoudAIViewModel

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let appStorageService = AppStorageService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        setSceneView()
    }

    func setSceneView() {
        if appStorageService.hasData(for: .skipOnboarding) {
            if appStorageService.hasData(for: .isEnabled) {
                startNotificationFlow()
                //Tabbar
            } else {
                startNotificationFlow()
            }
        }else {
            appStorageService.saveData(key: .skipOnboarding, value: true)
            startOnboardingFlow()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    func startOnboardingFlow() {
        let onboardingViewController = ViewControllerFactory.makeOnboardingViewController()
        startFlow(for: onboardingViewController)
    }

    func startTabBarFlow() {
//        let tabBarViewController = ViewControllerFactory.makeTabBarViewController()
//        startTabFlow(for: tabBarViewController)
    }

    func startFlow(for viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func startTabFlow(for viewController: UIViewController) {
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

    func startNotificationFlow() {
        let ntfViewController = ViewControllerFactory.makeNotificationViewController()
        startFlow(for: ntfViewController)
    }
}

