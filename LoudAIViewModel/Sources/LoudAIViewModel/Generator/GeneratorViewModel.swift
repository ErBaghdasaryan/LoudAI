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
    var genreItems: [GenreModel] { get set }
    func loadGenres()

    var byPromptResponse: ByPromptResponseModel? { get set }
    var createByPromptSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func createByPromptRequest(userId: String, bundle: String, prompt: String)
}

public class GeneratorViewModel: IGeneratorViewModel {

    public let generatorService: IGeneratorService
    public let networkService: INetworkService

    public var byPromptResponse: ByPromptResponseModel?
    public var createByPromptSuccessSubject = PassthroughSubject<Bool, Never>()

    public var genreItems: [GenreModel] = []

    public init(generatorService: IGeneratorService,
                networkService: INetworkService) {
        self.generatorService = generatorService
        self.networkService = networkService
    }

    public func loadGenres() {
        genreItems = generatorService.getGenreItems()
    }

    public func createByPromptRequest(userId: String, bundle: String, prompt: String) {
        Task {
            do {
                let response = try await networkService.createByPromptRequest(userId: userId, appBundle: bundle, prompt: prompt)
                byPromptResponse = response
                self.createByPromptSuccessSubject.send(true)
            } catch let error {
                print("##########")
                print(error)
                self.createByPromptSuccessSubject.send(false)
            }
        }
    }
}
