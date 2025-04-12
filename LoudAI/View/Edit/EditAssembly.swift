//
//  EditAssembly.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 13.04.25.
//

import Foundation
import LoudAIViewModel
import LoudAIModel
import Swinject
import SwinjectAutoregistration

final class EditAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IEditViewModel.self, argument: EditNavigationModel.self,
                               initializer: EditViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IEditService.self, initializer: EditService.init)
    }
}
