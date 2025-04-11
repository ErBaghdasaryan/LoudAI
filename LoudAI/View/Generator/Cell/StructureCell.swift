//
//  StructureCell.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 30.03.25.
//

import UIKit
import SnapKit
import Combine

class StructureCell: UICollectionViewCell, IReusableView {

    private let titleLabel = UILabel(text: "Structure",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Bold", size: 16))

    private let deleteButton = UIButton(type: .system)
    public let deleteTapped = PassthroughSubject<Void, Never>()

    private let classic = UIButton(type: .system)
    private let toTheBone = UIButton(type: .system)
    private let waitForIt = UIButton(type: .system)
    private let slowBurn = UIButton(type: .system)

    private var finalStack: UIStackView!

    var cancellables = Set<AnyCancellable>()

    private var selectedStructure: Structure?

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

        self.titleLabel.textAlignment = .left

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .white

        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        self.classic.setImage(UIImage(named: "noneClassic"), for: .normal)
        self.toTheBone.setImage(UIImage(named: "noneToTheBone"), for: .normal)
        self.waitForIt.setImage(UIImage(named: "noneWaitForIt"), for: .normal)
        self.slowBurn.setImage(UIImage(named: "noneSlowBurn"), for: .normal)

        self.classic.layer.masksToBounds = true
        self.classic.layer.cornerRadius = 16

        self.toTheBone.layer.masksToBounds = true
        self.toTheBone.layer.cornerRadius = 16

        self.waitForIt.layer.masksToBounds = true
        self.waitForIt.layer.cornerRadius = 16

        self.slowBurn.layer.masksToBounds = true
        self.slowBurn.layer.cornerRadius = 16

        classic.tag = 0
        toTheBone.tag = 1
        waitForIt.tag = 2
        slowBurn.tag = 3

        self.finalStack = UIStackView(arrangedSubviews: [classic, toTheBone, waitForIt, slowBurn],
                                      axis: .vertical,
                                      spacing: 12)
        self.finalStack.distribution = .fillEqually

        classic.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
        toTheBone.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
        waitForIt.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)
        slowBurn.addTarget(self, action: #selector(handleButtonPress(_:)), for: .touchUpInside)

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
            make.top.equalToSuperview().offset(45)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(15)
        }
    }

    @objc private func deleteButtonTapped() {
        deleteTapped.send()
    }

    @objc private func handleButtonPress(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            classic.setImage(UIImage(named: "selectedClassic"), for: .normal)
            toTheBone.setImage(UIImage(named: "noneToTheBone"), for: .normal)
            waitForIt.setImage(UIImage(named: "noneWaitForIt"), for: .normal)
            slowBurn.setImage(UIImage(named: "noneSlowBurn"), for: .normal)
            self.selectedStructure = .classic
        case 1:
            toTheBone.setImage(UIImage(named: "selectedToTheBone"), for: .normal)
            classic.setImage(UIImage(named: "noneClassic"), for: .normal)
            waitForIt.setImage(UIImage(named: "noneWaitForIt"), for: .normal)
            slowBurn.setImage(UIImage(named: "noneSlowBurn"), for: .normal)
            self.selectedStructure = .toTheBone
        case 2:
            waitForIt.setImage(UIImage(named: "selectedWaitForIt"), for: .normal)
            classic.setImage(UIImage(named: "noneClassic"), for: .normal)
            toTheBone.setImage(UIImage(named: "noneToTheBone"), for: .normal)
            slowBurn.setImage(UIImage(named: "noneSlowBurn"), for: .normal)
            self.selectedStructure = .waitForIt
        case 3:
            slowBurn.setImage(UIImage(named: "selectedSlowBurn"), for: .normal)
            classic.setImage(UIImage(named: "noneClassic"), for: .normal)
            toTheBone.setImage(UIImage(named: "noneToTheBone"), for: .normal)
            waitForIt.setImage(UIImage(named: "noneWaitForIt"), for: .normal)
            self.selectedStructure = .slowBurn
        default:
            break
        }
    }

    public func returnSelectedEnergy() -> Int? {
        switch self.selectedStructure {
        case .classic:
            0
        case .toTheBone:
            1
        case .waitForIt:
            2
        case .slowBurn:
            3
        case .none:
            nil
        }
    }
}

enum Structure {
    case classic
    case toTheBone
    case waitForIt
    case slowBurn
}
