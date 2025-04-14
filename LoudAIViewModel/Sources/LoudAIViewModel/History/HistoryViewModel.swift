//
//  HistoryViewModel.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import Foundation
import LoudAIModel

public protocol IHistoryViewModel {
    var savedMusics: [SavedMusicModel] { get set }
    func loadMusics()
    func deleteMusic(at index: Int)
}

public class HistoryViewModel: IHistoryViewModel {

    private let historyService: IHistoryService

    public var savedMusics: [SavedMusicModel] = []

    public init(historyService: IHistoryService) {
        self.historyService = historyService
    }

    public func loadMusics() {
        do {
            self.savedMusics = try self.historyService.getAllSavedMusics()
        } catch {
            print(error)
        }
    }

    public func deleteMusic(at index: Int) {
        do {
            try self.historyService.deleteSavedMusic(by: index)
        } catch {
            print(error)
        }
    }
}
