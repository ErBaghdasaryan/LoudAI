//
//  Untitled.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//
import UIKit
import LoudAIModel

class VersionCell: UICollectionViewCell, IReusableView {
    private let versionLabel = UILabel()
    
    func configure(with item: SettingsItem) {
        versionLabel.text = item.title
        versionLabel.font = UIFont(name: "SFProText-Regular", size: 12)
        versionLabel.textColor = UIColor(hex: "#808080")

        versionLabel.textAlignment = .center

        contentView.addSubview(versionLabel)
        versionLabel.frame = contentView.bounds
    }
}
