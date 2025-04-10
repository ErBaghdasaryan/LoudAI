//
//  HistoryRouter.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import Foundation
import UIKit
import LoudAIViewModel

final class HistoryRouter: BaseRouter {
    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
