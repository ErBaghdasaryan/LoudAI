//
//  Setupable.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation

protocol ISetupable {
    associatedtype SetupModel
    func setup(with model: SetupModel)
}
