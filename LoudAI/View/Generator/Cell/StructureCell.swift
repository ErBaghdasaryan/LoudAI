//
//  StructureCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 30.03.25.
//

import UIKit
import Combine
import LoudAIModel

class StructureCell: UICollectionViewCell, IReusableView {

    private let image = UIImageView()
    private let date = UILabel(text: "Unknown",
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

        self.image.layer.masksToBounds = true
        self.image.layer.cornerRadius = 16
        self.image.contentMode = .scaleAspectFill

        self.date.textAlignment = .left

        self.addSubview(image)
        self.addSubview(date)
        setupConstraints()
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(22)
        }

        date.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom).offset(8)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(14)
        }
    }

    func configure(with title: String, and image: UIImage) {
        self.image.image = image
        self.date.text = title
    }
}
