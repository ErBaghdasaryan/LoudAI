//
//  OnboardingViewModel.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation
import LoudAIModel

public protocol IOnboardingViewModel {
    var onboardingItems: [OnboardingPresentationModel] { get set }
    func loadData()
}

public class OnboardingViewModel: IOnboardingViewModel {

    private let onboardingService: IOnboardingService

    public var onboardingItems: [OnboardingPresentationModel] = []

    public init(onboardingService: IOnboardingService) {
        self.onboardingService = onboardingService
    }

    public func loadData() {
        onboardingItems = onboardingService.getOnboardingItems()
    }
}

