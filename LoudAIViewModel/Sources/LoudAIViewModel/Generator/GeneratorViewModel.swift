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

    var timeOutSubject: PassthroughSubject<Void, Never> { get }

    var createByPromptSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func createByPromptRequest(userId: String, bundle: String, prompt: String)

    var getMusicSuccessSubject: PassthroughSubject<ResponseModel, Never> { get }
    func startPollingForGeneratedTrack(by musicID: UUID)

    func addMusic(_ model: SavedMusicModel)
}

public class GeneratorViewModel: IGeneratorViewModel {

    public let generatorService: IGeneratorService
    public let networkService: INetworkService
    public let appStorageService: IAppStorageService

    public var byPromptResponse: ResponseModel?
    public var timeOutSubject = PassthroughSubject<Void, Never>()
    public var createByPromptSuccessSubject = PassthroughSubject<Bool, Never>()
    public var getMusicSuccessSubject = PassthroughSubject<ResponseModel, Never>()
    var cancellables = Set<AnyCancellable>()

    private var pollingCancellable: AnyCancellable?
    private var isPolling = false

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

    public func startPollingForGeneratedTrack(by musicID: UUID) {
        guard !isPolling else { return }
        isPolling = true
        
        var elapsedTime: TimeInterval = 0
        let pollingInterval: TimeInterval = 25
        let timeout: TimeInterval = 360
        pollingCancellable = Timer
            .publish(every: pollingInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                elapsedTime += pollingInterval

                if elapsedTime >= timeout {
                    self.timeOutSubject.send()
                    self.pollingCancellable?.cancel()
                    self.isPolling = false
                    return
                }
                
                self.getMusicsRequest(by: musicID)
            }
    }

    public func getMusicsRequest(by musicID: UUID) {
        networkService.getMusic(by: musicID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Get music error: \(error)")
                }
            }, receiveValue: { [weak self] responseModel in
                guard let self = self else { return }

                if !responseModel.items.isEmpty {
                    self.pollingCancellable?.cancel()
                    self.isPolling = false

                    self.getMusicSuccessSubject.send(responseModel)
                } else {
                    print("Still generating... will poll again.")
                }
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

    public func addMusic(_ model: SavedMusicModel) {
        do {
            _ = try self.generatorService.addSavedMusic(model)
        } catch {
            print(error)
        }
    }
}
