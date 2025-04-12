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
                                        header: "Welcome to HitLab",
                                        subheader: "Create music in the app "),
            OnboardingPresentationModel(image: "onboarding2",
                                        header: "Feel like a cool DJ",
                                        subheader: ""),
            OnboardingPresentationModel(image: "onboarding3",
                                        header: "Generate music",
                                        subheader: "Using many different instruments and genres"),
            OnboardingPresentationModel(image: "onboarding4",
                                        header: "Help us become better!",
                                        subheader: "We value your opinion. Leave a review about our application to help other users learn about its capabilities.")
        ]
    }
}
