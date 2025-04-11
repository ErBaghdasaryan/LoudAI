//
//  CustomTextView.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 25.03.25.
//

import UIKit

public class CustomTextView: UITextView, UITextViewDelegate {

    private var placeholderText: String = ""
    public var placeholderLabel: UILabel = UILabel()
    private var characterCountLabel: UILabel = UILabel()
    private let maxCharacterLimit = 250

    public convenience init(placeholder: String) {
        self.init()
        self.placeholderText = placeholder

        configure()
    }

    private func configure() {

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.backgroundColor = UIColor(hex: "#1E1E1E")?.withAlphaComponent(0.7)

        placeholderLabel.text = placeholderText
        placeholderLabel.font = UIFont(name: "SFProText-Bold", size: 12)
        placeholderLabel.textAlignment = .left
        placeholderLabel.numberOfLines = 2
        addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(12)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(12)
            view.bottom.equalToSuperview()
        }

        characterCountLabel.text = "0/\(maxCharacterLimit)"
        characterCountLabel.font = UIFont(name: "SFProText-Bold", size: 12)
        characterCountLabel.textColor = UIColor(hex: "#8D929B")
        characterCountLabel.textAlignment = .right

        addSubview(characterCountLabel)

        characterCountLabel.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(8)
            view.trailing.equalToSuperview().inset(8)
        }

        placeholderLabel.isHidden = !text.isEmpty

        self.placeholderLabel.attributedText = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)])

        self.textColor = .white
        self.textAlignment = .left
        self.font = UIFont(name: "SFProText-Regular", size: 16)

        self.delegate = self
    }

    // MARK: UITextViewDelegate
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty

        let currentLength = textView.text.count
        characterCountLabel.text = "\(currentLength)/\(maxCharacterLimit)"

        if currentLength > maxCharacterLimit {
            textView.text = String(textView.text.prefix(maxCharacterLimit))
            characterCountLabel.text = "\(maxCharacterLimit)/\(maxCharacterLimit)"
        }
    }

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: "#4C19DE")?.cgColor
        return true
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
    }
}
