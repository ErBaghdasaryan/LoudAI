//
//  CreateAssembly.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 11.04.25.
//

import Foundation
import LoudAIViewModel
import LoudAIModel
import Swinject
import SwinjectAutoregistration

final class CreateAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(ICreateViewModel.self, argument: AdvancedSendModel.self,
                               initializer: CreateViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(ICreateService.self, initializer: CreateService.init)
    }
}
