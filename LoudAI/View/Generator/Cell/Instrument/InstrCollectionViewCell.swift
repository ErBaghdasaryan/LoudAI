//
//  InstrCollectionViewCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 11.04.25.
//

import UIKit
import Combine
import LoudAIModel

class InstrCollectionViewCell: UICollectionViewCell, IReusableView {

    private var image = UIImageView()
    private let name = UILabel(text: "",
                               textColor: UIColor.white,
                               font: UIFont(name: "SFProText-Regular", size: 12))

    private let sum = UIButton(type: .system)
    private let delete = UIButton(type: .system)
    public let shareCount = UILabel(text: "0",
                                     textColor: UIColor.white,
                                     font: UIFont(name: "SFProText-Regular", size: 12))
    private var buttonsStack: UIStackView!

    var shareCountInt: Int = 0 {
        willSet {
            self.shareCount.text = "\(newValue)"
        }
    }

    public var sumSubject = PassthroughSubject<Bool, Never>()
    public var deleteSubject = PassthroughSubject<Bool, Never>()
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

        self.name.textAlignment = .left

        self.sum.setImage(UIImage(named: "plus"), for: .normal)
        self.delete.setImage(UIImage(named: "minus"), for: .normal)

        self.buttonsStack = UIStackView(arrangedSubviews: [delete, shareCount, sum],
                                        axis: .horizontal,
                                        spacing: 0)
        buttonsStack.distribution = .fillEqually

        self.addSubview(image)
        self.addSubview(name)
        self.addSubview(buttonsStack)
        setupConstraints()
    }

    private func setupConstraints() {
        image.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(6)
            view.leading.equalToSuperview()
            view.height.equalTo(16)
            view.width.equalTo(16)
        }

        name.snp.makeConstraints { view in
            view.centerY.equalTo(image.snp.centerY)
            view.leading.equalTo(image.snp.trailing).offset(8)
            view.trailing.equalToSuperview().inset(8)
            view.height.equalTo(15)
        }

        buttonsStack.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.trailing.equalToSuperview()
            view.height.equalTo(28)
            view.width.equalTo(90)
        }
    }

    func setup(with model: InstrumentModel) {
        self.image.image = UIImage(named: model.imageName)!
        self.name.text = model.name
    }

    func plusSharesCount() {
        if shareCountInt <= 7 {
            self.shareCountInt += 1
        }
    }

    func minusSharesCount() {
        if shareCountInt > 0 {
            self.shareCountInt -= 1
        }
    }

    func resetCount() {
        self.shareCountInt = 0
    }
}

extension InstrCollectionViewCell {
    private func makeButtonActions() {
        self.sum.addTarget(self, action: #selector(sumTapped), for: .touchUpInside)
        self.delete.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    @objc func sumTapped() {
        self.sumSubject.send(true)
    }

    @objc func deleteTapped() {
        self.deleteSubject.send(true)
    }
}
