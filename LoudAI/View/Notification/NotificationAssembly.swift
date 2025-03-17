//
//  NotificationAssembly.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation
import LoudAIViewModel
import Swinject
import SwinjectAutoregistration

final class NotificationAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(INotificationViewModel.self, initializer: NotificationViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(INotificationService.self, initializer: NotificationService.init)
    }
}
