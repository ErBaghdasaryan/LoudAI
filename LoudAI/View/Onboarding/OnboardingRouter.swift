//
//  OnboardingRouter.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation
import UIKit
import LoudAIViewModel

final class OnboardingRouter: BaseRouter {
    static func showNotificationViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeNotificationViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
