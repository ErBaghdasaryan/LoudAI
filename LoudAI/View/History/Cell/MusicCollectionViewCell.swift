//
//  MusicCollectionViewCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 25.03.25.
//

import UIKit
import Combine
import LoudAIModel

class MusicCollectionViewCell: UICollectionViewCell, IReusableView {

    private let image = UIImageView(image: UIImage(named: "emptyCellImage"))
    private let header = UILabel(text: "You dont have any works...",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Bold", size: 24))
    private let subHeader = UILabel(text: "Upload your photos to create amazing profeccional works",
                                    textColor: UIColor(hex: "#8D929B")!,
                                    font: UIFont(name: "SFProText-Regular", size: 16))

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

        self.subHeader.numberOfLines = 2
        self.subHeader.lineBreakMode = .byWordWrapping

        self.addSubview(image)
        self.addSubview(header)
        self.addSubview(subHeader)
        setupConstraints()
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(115)
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(332)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom).offset(32)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(26)
        }

        subHeader.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(40)
        }
    }
}
