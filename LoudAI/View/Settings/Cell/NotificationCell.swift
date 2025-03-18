//
//  NotificationCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import UIKit
import LoudAIModel

class NotificationCell: UICollectionViewCell, IReusableView {

    private let icon = UIImageView()
    private let title = UILabel()

    private let switchControl = UISwitch()
    
    func configure(with item: SettingsItem) {
        icon.tintColor = .white
        title.textColor = .white
        title.font = UIFont(name: "SFProText-Regular", size: 16)

        self.title.text = "Notification"
        self.icon.image = UIImage(named: "ntf")

        contentView.addSubview(switchControl)
        contentView.addSubview(icon)
        contentView.addSubview(title)

        icon.frame = CGRect(x: 12, y: 16, width: 20, height: 20)
        title.frame = CGRect(x: 44, y: 16, width: contentView.frame.width - 56, height: 20)
        switchControl.onTintColor = UIColor(hex: "#00B212")
        switchControl.layer.borderWidth = 1.5
        switchControl.layer.borderColor = UIColor(hex: "#5F6E85")?.cgColor
        switchControl.layer.masksToBounds = true
        switchControl.layer.cornerRadius = 15
        switchControl.frame = CGRect(x: contentView.frame.width - 70, y: 10, width: 50, height: 30)

        contentView.backgroundColor = UIColor(hex: "#1E1E1E")
        contentView.layer.cornerRadius = 16
    }
}
