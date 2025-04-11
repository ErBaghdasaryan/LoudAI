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
    var userID: String { get set }
    var byPromptResponse: ResponseModel? { get set }
    func getMusic(by musicID: UUID)
    var fetchGenerationModel: ResponseModel? { get set }
    var fetchGenerationSuccessSubject: PassthroughSubject<Bool, Never> { get }
    var createByPromptSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func createByPromptRequest(userId: String, bundle: String, prompt: String)
}

public class GeneratorViewModel: IGeneratorViewModel {

    public let generatorService: IGeneratorService
    public let networkService: INetworkService
    public let appStorageService: IAppStorageService

    public var byPromptResponse: ResponseModel?
    public var fetchGenerationModel: ResponseModel?
    public var fetchGenerationSuccessSubject = PassthroughSubject<Bool, Never>()
    public var createByPromptSuccessSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    public var genreItems: [GenreModel] = []

    public var userID: String {
        get {
            return appStorageService.getData(key: .apphudUserID) ?? ""
        } set {
            appStorageService.saveData(key: .apphudUserID, value: newValue)
        }
    }

    public init(generatorService: IGeneratorService,
                networkService: INetworkService,
                appStorageService: IAppStorageService,) {
        self.generatorService = generatorService
        self.networkService = networkService
        self.appStorageService = appStorageService
    }

    public func loadGenres() {
        genreItems = generatorService.getGenreItems()
    }

    public func getMusic(by musicID: UUID) {
        networkService.getMusic(by: musicID)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.fetchGenerationSuccessSubject.send(false)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.fetchGenerationModel = response
                self?.fetchGenerationSuccessSubject.send(true)
            })
            .store(in: &cancellables)
    }

    public func createByPromptRequest(userId: String, bundle: String, prompt: String) {
        Task {
            do {
                let response = try await networkService.createByPromptRequest(userId: userId, appBundle: bundle, prompt: prompt)
                byPromptResponse = response
                self.createByPromptSuccessSubject.send(true)
            } catch let error {
                self.createByPromptSuccessSubject.send(false)
            }
        }
    }
}
