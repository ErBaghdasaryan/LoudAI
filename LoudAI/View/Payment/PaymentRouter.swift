//
//  PaymentRouter.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation
import UIKit
import LoudAIViewModel

final class PaymentRouter: BaseRouter {
    static func showTabBarViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeTabBarViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showTabBarFromIntroViewController(in navigationController: UINavigationController) {
//        let viewController = ViewControllerFactory.makeTabBarViewController()
//        navigationController.setViewControllers([viewController], animated: true)
    }

    static func showPrivacyViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePrivacyViewController()
        viewController.navigationItem.hidesBackButton = false
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showTermsViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeTermsViewController()
        viewController.navigationItem.hidesBackButton = false
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
