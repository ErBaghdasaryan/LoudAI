//
//  TempoCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 30.03.25.
//

import UIKit
import SnapKit
import Combine

class TempoCell: UICollectionViewCell, IReusableView {

    private let titleLabel = UILabel(text: "Tempo",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Bold", size: 16))

    private let slider = UISlider()

    private let durationLabel =  UILabel(text: "0 BPM",
                                         textColor: .white,
                                         font: UIFont(name: "SFProText-Regular", size: 14))

    private let deleteButton = UIButton(type: .system)

    private let recomendation = UILabel(text: "Recommended: 75-100",
                                        textColor: UIColor(hex: "#8D929B")!,
                                        font: UIFont(name: "SFProText-Regular", size: 12))

    
    public let deleteTapped = PassthroughSubject<Void, Never>()
    public let valueChanged = PassthroughSubject<Int, Never>()

    var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    private func setupUI() {
        backgroundColor = UIColor(hex: "#1E1E1E")?.withAlphaComponent(0.7)
        layer.cornerRadius = 16

        slider.minimumValue = 0
        slider.maximumValue = 200
        slider.value = 0
        let smallThumb = UIImage(named: "circleImage")?.resizeImage(to: CGSize(width: 12, height: 12))
        slider.setThumbImage(smallThumb, for: .normal)
        slider.minimumTrackTintColor = UIColor(hex: "#4C19DE")
        slider.maximumTrackTintColor = UIColor(hex: "#3B3B3B")

        durationLabel.layer.masksToBounds = true
        durationLabel.layer.cornerRadius = 8
        durationLabel.layer.borderWidth = 1
        durationLabel.layer.borderColor = UIColor(hex: "#353746")?.cgColor

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .white

        recomendation.textAlignment = .left

        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        contentView.addSubview(titleLabel)
        contentView.addSubview(slider)
        contentView.addSubview(durationLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(recomendation)
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(12)
        }

        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(16)
        }

        slider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(durationLabel.snp.leading).offset(-8)
            make.height.equalTo(4)
        }

        durationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(slider)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }

        recomendation.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().offset(12)
            make.height.equalTo(14)
        }
    }

    @objc private func sliderValueChanged() {
        let value = Int(slider.value)
        durationLabel.text = "\(value) BPM"
        valueChanged.send(Int(slider.value))
    }

    @objc private func deleteButtonTapped() {
        deleteTapped.send()
    }

    public func configure(with value: Float) {
        slider.setValue(value, animated: false)
        sliderValueChanged()
    }
}
