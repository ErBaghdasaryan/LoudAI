//
//  TextViewWithCounter.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 11.04.25.
//

import UIKit
import SnapKit

public class TextViewWithCounter: UIView, UITextViewDelegate {

    private var placeholderText: String = ""
    private let maxCharacterLimit = 250

    private let textView = UITextView()
    public let placeholderLabel = UILabel()
    private let characterCountLabel = UILabel()

    public convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholderText = placeholder
        configure()
    }

    private func configure() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(hex: "#1E1E1E")?.withAlphaComponent(0.7)

        textView.delegate = self
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "SFProText-Regular", size: 16)
        textView.textColor = .white
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        self.addSubview(textView)

        textView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        placeholderLabel.text = placeholderText
        placeholderLabel.numberOfLines = 2
        placeholderLabel.font = UIFont(name: "SFProText-Bold", size: 12)
        placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.4)
        placeholderLabel.isHidden = !textView.text.isEmpty
        textView.addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView).offset(8)
            make.leading.equalTo(textView).offset(5)
            make.trailing.equalTo(textView).inset(5)
        }

        characterCountLabel.text = "0/\(maxCharacterLimit)"
        characterCountLabel.font = UIFont(name: "SFProText-Bold", size: 12)
        characterCountLabel.textColor = UIColor(hex: "#8D929B")
        characterCountLabel.textAlignment = .right
        self.addSubview(characterCountLabel)

        characterCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(6)
        }
    }

    // MARK: - Delegate Methods
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty

        let currentLength = textView.text.count
        if currentLength > maxCharacterLimit {
            textView.text = String(textView.text.prefix(maxCharacterLimit))
        }

        characterCountLabel.text = "\(textView.text.count)/\(maxCharacterLimit)"
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

    public func getText() -> String {
        return textView.text
    }

    public func setText(_ text: String) {
        textView.text = text
        placeholderLabel.isHidden = !text.isEmpty
        characterCountLabel.text = "\(text.count)/\(maxCharacterLimit)"
    }
}
