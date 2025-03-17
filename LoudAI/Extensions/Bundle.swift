//
//  Bundl.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation

public extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
