//
//  EditRouter.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 13.04.25.
//

import Foundation
import UIKit
import LoudAIViewModel

final class EditRouter: BaseRouter {
    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
