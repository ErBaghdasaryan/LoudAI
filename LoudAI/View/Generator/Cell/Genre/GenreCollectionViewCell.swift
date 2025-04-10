//
//  GenreCollectionViewCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 02.04.25.
//

import UIKit
import Combine
import LoudAIModel

class GenreCollectionViewCell: UICollectionViewCell, IReusableView {

    private let forImage = UIView()
    private let image = UIImageView()
    private let name = UILabel(text: "",
                               textColor: UIColor.white.withAlphaComponent(0.7),
                               font: UIFont(name: "SFProText-Regular", size: 14))

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

        self.forImage.layer.masksToBounds = true
        self.forImage.layer.cornerRadius = 12
        self.forImage.layer.borderWidth = 1
        self.forImage.layer.borderColor = UIColor(hex: "#353746")?.cgColor

        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 8
        self.image.contentMode = .scaleAspectFill
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor

        self.addSubview(forImage)
        self.addSubview(image)
        self.addSubview(name)
        setupConstraints()
    }

    private func setupConstraints() {

        forImage.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(18)
        }

        image.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(8)
            view.leading.equalToSuperview().offset(8)
            view.trailing.equalToSuperview().inset(8)
            view.bottom.equalTo(forImage.snp.bottom).inset(8)
        }

        name.snp.makeConstraints { view in
            view.top.equalTo(forImage.snp.bottom).offset(4)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(14)
        }
    }

    func configure(with model: GenreModel) {
        self.name.text = model.title
        self.image.image = model.image
    }

    func updateSelectionState(isSelected: Bool) {
        self.image.layer.borderWidth = isSelected ? 1 : 0
        self.image.layer.borderColor = isSelected ? UIColor(hex: "#4C19DE")?.cgColor : UIColor.clear.cgColor
        self.forImage.layer.borderWidth = isSelected ? 2 : 1
        self.forImage.layer.borderColor = isSelected ? UIColor(hex: "#4C19DE")?.cgColor : UIColor(hex: "#353746")?.cgColor
    }
}
