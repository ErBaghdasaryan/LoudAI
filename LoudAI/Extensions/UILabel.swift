//
//  UILabel.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit

public extension UILabel {
    convenience init(text: String, textColor: UIColor, font: UIFont?) {
        self.init()

        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = .center
    }

    func addIconForLabel(imageName: String, passedText: String) {
        guard let image = UIImage(named: imageName) else {
            return
        }

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image

        let font = self.font ?? UIFont.systemFont(ofSize: 17)
        let fontCapHeight = font.capHeight
        let imageHeight = image.size.height
        let yOffset = (fontCapHeight - imageHeight) / 2

        imageAttachment.bounds = CGRect(x: 0, y: yOffset, width: image.size.width, height: image.size.height)

        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let textAfterIcon = NSAttributedString(string: " \(passedText)")
        
        let completeText = NSMutableAttributedString()
        completeText.append(textAfterIcon)
        completeText.append(attachmentString)
        
        self.attributedText = completeText
        self.textAlignment = .center
    }
}
