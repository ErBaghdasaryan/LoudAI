//
//  GeneratorViewModel.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import Foundation
import LoudAIModel
import Combine

public protocol IGeneratorViewModel {

}

public class GeneratorViewModel: IGeneratorViewModel {

    public let generatorService: IGeneratorService

    public init(generatorService: IGeneratorService) {
        self.generatorService = generatorService
    }
}
