//
//  SettingsItem.swift
//  LoudAIModel
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit

public struct SettingsItem {
    public let icon: UIImage?
    public let title: String
    public let isSwitch: Bool
    public let isVersion: Bool

    public init(icon: UIImage?, title: String, isSwitch: Bool, isVersion: Bool) {
        self.icon = icon
        self.title = title
        self.isSwitch = isSwitch
        self.isVersion = isVersion
    }
}

public enum SettingsSection {
    case share
    case setting
    case info
}
