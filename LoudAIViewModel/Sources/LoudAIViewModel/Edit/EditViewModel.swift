//
//  EditViewModel.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 13.04.25.
//

import Foundation
import LoudAIModel
import Combine

public protocol IEditViewModel {
    var model: EditNavigationModel { get }
}

public class EditViewModel: IEditViewModel {

    private let editService: IEditService

    public var model: EditNavigationModel

    public init(editService: IEditService,
                navigationModel: EditNavigationModel) {
        self.editService = editService
        self.model = navigationModel
    }
}
