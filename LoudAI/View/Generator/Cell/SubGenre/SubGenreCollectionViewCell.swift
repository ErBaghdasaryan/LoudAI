//
//  SubGenreCollectionViewCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 02.04.25.
//

import UIKit
import Combine
import LoudAIModel

class SubGenreCollectionViewCell: UICollectionViewCell, IReusableView {

    private let text = UILabel(text: "",
                               textColor: UIColor(hex: "#8D929B")!,
                               font: UIFont(name: "SFProText-Regular", size: 12))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        self.text.layer.masksToBounds = true
        self.text.layer.cornerRadius = 8
        self.text.layer.borderColor = UIColor(hex: "#8D929B")?.cgColor
        self.text.layer.borderWidth = 1

        self.addSubview(text)
        setupConstraints()
    }

    private func setupConstraints() {
        text.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview()
        }
    }

    func setup(with text: String) {
        self.text.text = text
    }

    func updateSelectionState(isSelected: Bool) {
        self.backgroundColor = isSelected ? UIColor(hex: "#1E1E1E")?.withAlphaComponent(0.7) : UIColor.clear
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = isSelected ? 0 : 1
        self.layer.borderColor = isSelected ? UIColor.clear.cgColor : UIColor(hex: "#8D929B")?.cgColor
        self.text.textColor = isSelected ? UIColor.white : UIColor(hex: "#8D929B")!
    }
}
