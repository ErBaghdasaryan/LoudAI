//
//  HistoryViewModel.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import Foundation
import LoudAIModel

public protocol IHistoryViewModel {

}

public class HistoryViewModel: IHistoryViewModel {

    private let historyService: IHistoryService

    public init(historyService: IHistoryService) {
        self.historyService = historyService
    }
}
