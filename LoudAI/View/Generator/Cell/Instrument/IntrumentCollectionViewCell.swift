//
//  IntrumentCollectionViewCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 31.03.25.
//

import UIKit
import Combine
import LoudAIModel


class IntrumentCollectionViewCell: UICollectionViewCell, IReusableView {

    private let image = UIImageView()
    private let name = UILabel(text: "",
                               textColor: UIColor.white,
                               font: UIFont(name: "SFProText-Regular", size: 14))

    private var isAdded: Bool = false {
        willSet {
            if newValue {
                self.image.image = UIImage(named: "genreAdded")
            } else {
                self.image.image = UIImage(named: "plusGenre")
            }
        }
    }

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
        self.image.layer.cornerRadius = 12
        self.image.contentMode = .scaleAspectFill

        self.addSubview(image)
        self.addSubview(name)
        setupConstraints()
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(24)
        }

        name.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom).offset(8)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(14)
        }
    }

    func configure(with title: String, isGenre: Bool = false) {
        if isGenre {
            self.image.image = UIImage(named: "genreImage")
        } else {
            self.image.image = UIImage(named: "plusGenre")
        }
        self.name.text = title
    }

    func updateStateUI(isAdded: Bool) {
        self.isAdded = isAdded
    }
}
