//
//  EnergyCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 30.03.25.
//

import UIKit
import SnapKit
import Combine

class EnergyCell: UICollectionViewCell, IReusableView {

    private let titleLabel = UILabel(text: "Energy",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Bold", size: 16))

    private let deleteButton = UIButton(type: .system)
    public let deleteTapped = PassthroughSubject<Void, Never>()

    private let lowLabel = UILabel(text: "Low",
                                   textColor: .white.withAlphaComponent(0.7),
                                   font: UIFont(name: "SFProText-Regular", size: 16))
    private let originalLabel = UILabel(text: "Original",
                                   textColor: .white.withAlphaComponent(0.7),
                                   font: UIFont(name: "SFProText-Regular", size: 16))
    private let highLabel = UILabel(text: "High",
                                   textColor: .white.withAlphaComponent(0.7),
                                   font: UIFont(name: "SFProText-Regular", size: 16))

    private let lowButton = UIButton(type: .system)
    private let originalButton = UIButton(type: .system)
    private let heighButton = UIButton(type: .system)

    private var lowStack: UIStackView!
    private var originalStack: UIStackView!
    private var heighStack: UIStackView!

    private var finalStack: UIStackView!

    public let currentEnergySubject = PassthroughSubject<String, Never>()
    var cancellables = Set<AnyCancellable>()

    private var selectedEnergy: Energy?

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

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .white

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        self.lowButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)
        self.originalButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)
        self.heighButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)

        lowButton.tag = 0
        originalButton.tag = 1
        heighButton.tag = 2

        self.lowStack = UIStackView(arrangedSubviews: [lowButton, lowLabel],
                                    axis: .horizontal,
                                    spacing: 8)
        self.lowStack.distribution = .fillProportionally

        self.originalStack = UIStackView(arrangedSubviews: [originalButton, originalLabel],
                                    axis: .horizontal,
                                    spacing: 8)
        self.originalStack.distribution = .fillProportionally

        self.heighStack = UIStackView(arrangedSubviews: [heighButton, highLabel],
                                    axis: .horizontal,
                                    spacing: 8)
        self.heighStack.distribution = .fillProportionally

        self.finalStack = UIStackView(arrangedSubviews: [lowStack, originalStack, heighStack],
                                      axis: .horizontal,
                                      spacing: 54)
        self.finalStack.distribution = .fillProportionally

        lowButton.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
        originalButton.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
        heighButton.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)

        contentView.addSubview(titleLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(finalStack)
        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
        }

        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(16)
        }

        finalStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(24)
        }
    }

    @objc private func deleteButtonTapped() {
        deleteTapped.send()
    }

    @objc private func handleButtonPress(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            lowButton.setImage(UIImage(named: "selectedEnergy"), for: .normal)
            originalButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)
            heighButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)
            self.selectedEnergy = .low
            self.currentEnergySubject.send(returnSelectedEnergy()!)
        case 1:
            originalButton.setImage(UIImage(named: "selectedEnergy"), for: .normal)
            lowButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)
            heighButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)
            self.selectedEnergy = .original
            self.currentEnergySubject.send(returnSelectedEnergy()!)
        case 2:
            heighButton.setImage(UIImage(named: "selectedEnergy"), for: .normal)
            lowButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)
            originalButton.setImage(UIImage(named: "nonSelectedEnergy"), for: .normal)
            self.selectedEnergy = .high
            self.currentEnergySubject.send(returnSelectedEnergy()!)
        default:
            break
        }
    }

    public func returnSelectedEnergy() -> String? {
        switch self.selectedEnergy {
        case .low:
            return "low"
        case .original:
            return "original"
        case .high:
            return "high"
        case .none:
            return nil
        }
    }
}

enum Energy {
    case low
    case original
    case high
}
