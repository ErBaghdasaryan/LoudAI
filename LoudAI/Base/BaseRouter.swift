//
//  BaseRouter.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit
import Combine
import LoudAIViewModel

class BaseRouter {

    class func popViewController(in navigationController: UINavigationController, completion: (() -> Void)? = nil) {
        completion?()
        navigationController.popViewController(animated: true)
    }
}
