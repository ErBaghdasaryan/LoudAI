//
//  EmptyCollectionViewCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 25.03.25.
//

import UIKit
import Combine
import LoudAIModel

class EmptyCollectionViewCelll: UICollectionViewCell, IReusableView {

    private let image = UIImageView(image: UIImage(named: "noSongsYet"))
    private let header = UILabel(text: "No Songs Yet",
                                 textColor: UIColor.white,
                                 font: UIFont(name: "SFProText-Bold", size: 24))
    private let add = UIButton(type: .system)
    public var addSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        makeButtonActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        makeButtonActions()
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear

        add.setTitle("Generate", for: .normal)
        add.setTitleColor(UIColor.white, for: .normal)
        add.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 15)
        add.setImage(UIImage(named: "addSong"), for: .normal)
        add.tintColor = UIColor.white
        add.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 8)
        add.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 16)
        add.backgroundColor = UIColor(hex: "#4C19DE")
        add.layer.masksToBounds = true
        add.layer.cornerRadius = 16

        self.addSubview(image)
        self.addSubview(header)
        self.addSubview(add)
        setupConstraints()
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(114)
            view.centerX.equalToSuperview()
            view.height.equalTo(121)
            view.width.equalTo(117)
        }

        header.snp.makeConstraints { view in
            view.top.equalTo(image.snp.bottom).offset(25)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(26)
        }

        add.snp.makeConstraints { view in
            view.top.equalTo(header.snp.bottom).offset(32)
            view.leading.equalToSuperview().offset(68)
            view.trailing.equalToSuperview().inset(68)
            view.height.equalTo(40)
        }
    }
}

extension EmptyCollectionViewCelll {
    private func makeButtonActions() {
        self.add.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    @objc func addTapped() {
        self.addSubject.send(true)
    }
}
