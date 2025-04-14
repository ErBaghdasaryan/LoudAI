//
//  FreeUsageService.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 14.04.25.
//

import Foundation
import ApphudSDK

public final class FreeUsageManager {

    public static let shared = FreeUsageManager()
    private init() {}

    private let key = ApphudUserPropertyKey.freeUsageCount

    public func initializeFreeUsageIfNeeded(defaultCount: Int = 1) {
        guard getCachedCount() == nil else {
            return
        }
        
        Apphud.setUserProperty(key: .init(key.rawValue), value: defaultCount, setOnce: true)
        cacheValue(defaultCount)
    }

    public func decrementFreeUsage() {
        let current = getCachedCount() ?? 0
        let newValue = current - 1

        Apphud.setUserProperty(key: .init(key.rawValue), value: newValue, setOnce: false)
        cacheValue(newValue)
    }

    public func getFreeUsageCount() -> Int {
        return getCachedCount() ?? 0
    }

    public func hasFreeUsages() -> Bool {
        return getFreeUsageCount() > 0
    }

    public func resetFreeUsage(to value: Int) {
        Apphud.setUserProperty(key: .init(key.rawValue), value: value, setOnce: false)
        cacheValue(value)
    }

    private func cacheValue(_ value: Int) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private func getCachedCount() -> Int? {
        let value = UserDefaults.standard.integer(forKey: key.rawValue)
        return value > 0 ? value : nil
    }
}

enum ApphudUserPropertyKey: String {
    case freeUsageCount
}
