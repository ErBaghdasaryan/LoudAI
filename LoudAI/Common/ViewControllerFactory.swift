//
//  ViewControllerFactory.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation
import Swinject
import LoudAIModel
import LoudAIViewModel

final class ViewControllerFactory {
    private static let commonAssemblies: [Assembly] = [ServiceAssembly()]

    //MARK: Onboarding
    static func makeOnboardingViewController() -> OnboardingViewController {
        let assembler = Assembler(commonAssemblies + [OnboardingAssembly()])
        let viewController = OnboardingViewController()
        viewController.viewModel = assembler.resolver.resolve(IOnboardingViewModel.self)
        return viewController
    }

    //MARK: Notification
    static func makeNotificationViewController() -> NotificationViewController {
        let assembler = Assembler(commonAssemblies + [NotificationAssembly()])
        let viewController = NotificationViewController()
        viewController.viewModel = assembler.resolver.resolve(INotificationViewModel.self)
        return viewController
    }

    //MARK: Payment
    static func makePaymentViewController() -> PaymentViewController {
        let assembler = Assembler(commonAssemblies + [PaymentAssembly()])
        let viewController = PaymentViewController()
        viewController.viewModel = assembler.resolver.resolve(IPaymentViewModel.self)
        return viewController
    }
}
