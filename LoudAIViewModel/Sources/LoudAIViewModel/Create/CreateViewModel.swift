//
//  CreateViewModel.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 11.04.25.
//

import Foundation
import LoudAIModel
import Combine

public protocol ICreateViewModel {
    var model: AdvancedSendModel { get }
    var advancedResponse: ResponseModel? { get set }
    var createAdvancedSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func createAdvancedRequest(model: AdvancedSendModel)
    var getMusicSuccessSubject: PassthroughSubject<ResponseModel, Never> { get }
    func startPollingForGeneratedTrack(by musicID: UUID)
    func addMusic(_ model: SavedMusicModel)
}

public class CreateViewModel: ICreateViewModel {

    private let createService: ICreateService
    public let networkService: INetworkService
    public let appStorageService: IAppStorageService

    public var model: AdvancedSendModel

    public var advancedResponse: ResponseModel?
    public var createAdvancedSuccessSubject = PassthroughSubject<Bool, Never>()
    public var getMusicSuccessSubject = PassthroughSubject<ResponseModel, Never>()
    var cancellables = Set<AnyCancellable>()

    public var userID: String {
        get {
            return appStorageService.getData(key: .apphudUserID) ?? ""
        } set {
            appStorageService.saveData(key: .apphudUserID, value: newValue)
        }
    }

    private var pollingCancellable: AnyCancellable?
    private var isPolling = false

    public init(createService: ICreateService,
                networkService: INetworkService,
                appStorageService: IAppStorageService,
                navigationModel: AdvancedSendModel) {
        self.createService = createService
        self.model = navigationModel
        self.networkService = networkService
        self.appStorageService = appStorageService
    }

    public func createAdvancedRequest(model: AdvancedSendModel) {
        Task {
            do {
                let response = try await networkService.createAdvancedRequest(model: model)
                advancedResponse = response
                self.createAdvancedSuccessSubject.send(true)
            } catch let error {
                self.createAdvancedSuccessSubject.send(false)
            }
        }
    }

    public func startPollingForGeneratedTrack(by musicID: UUID) {
        guard !isPolling else { return }
        isPolling = true

        pollingCancellable = Timer
            .publish(every: 25.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.getMusicsRequest(by: musicID)
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

    public func addMusic(_ model: SavedMusicModel) {
        do {
            _ = try self.createService.addSavedMusic(model)
        } catch {
            print(error)
        }
    }
}
