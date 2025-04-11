//
//  GeneratorRouter.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import Foundation
import UIKit
import LoudAIViewModel
import LoudAIModel

final class GeneratorRouter: BaseRouter {
    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showCreateViewController(in navigationController: UINavigationController, navigationModel: AdvancedSendModel) {
        let viewController = ViewControllerFactory.makeCreateViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
