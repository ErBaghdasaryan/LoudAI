//
//  CreateViewModel.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 11.04.25.
//

import Foundation
import LoudAIModel

public protocol ICreateViewModel {
    var model: AdvancedSendModel { get }
}

public class CreateViewModel: ICreateViewModel {

    private let createService: ICreateService
    public var model: AdvancedSendModel

    public init(createService: ICreateService, navigationModel: AdvancedSendModel) {
        self.createService = createService
        self.model = navigationModel
    }
}
