//
//  OnboardingService.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit
import LoudAIModel

public protocol IOnboardingService {
    func getOnboardingItems() -> [OnboardingPresentationModel]
}

public class OnboardingService: IOnboardingService {
    public init() { }

    public func getOnboardingItems() -> [OnboardingPresentationModel] {
        [
            OnboardingPresentationModel(image: "onboarding1",
                                        header: "Test",
                                        subheader: "Test"),
            OnboardingPresentationModel(image: "onboarding2",
                                        header: "Test",
                                        subheader: "Test"),
            OnboardingPresentationModel(image: "onboarding3",
                                        header: "Test",
                                        subheader: "Test"),
            OnboardingPresentationModel(image: "onboarding4",
                                        header: "Test",
                                        subheader: "")
        ]
    }
}
