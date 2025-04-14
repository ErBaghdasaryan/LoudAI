//
//  PaymentButton.swift
//  LoudAI
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import UIKit
import LoudAIModel

final class PaymentButton: UIButton {
    private let title = UILabel(text: "",
                                textColor: .white,
                                font: UIFont(name: "SFProText-Bold", size: 18))
    private let count = UILabel(text: "",
                                      textColor: UIColor.white,
                                      font: UIFont(name: "SFProText-Regular", size: 12))
    private let saveLabel = UILabel(text: "Save 60%",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Regular", size: 12))
    private let whiteLine = UIView()
    private let perDuration = UILabel(text: "",
                                      textColor: .white.withAlphaComponent(0.7),
                                      font: UIFont(name: "SFProText-Semibold", size: 12))
    var isSelectedState: Bool {
        didSet {
            self.updateBorder()
        }
    }
    private var isAnnual: PlanPresentationModel
    private let borderLayer = CAShapeLayer()

    public init(isAnnual: PlanPresentationModel, isSelectedState: Bool = false) {
        self.isAnnual = isAnnual
        self.isSelectedState = isSelectedState
        super.init(frame: .zero)
        setupUI(isAnnual: isAnnual)
        self.setupBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }

    private func setupUI(isAnnual: PlanPresentationModel) {

        self.backgroundColor = UIColor.gray.withAlphaComponent(0.07)

        self.layer.cornerRadius = 12

        self.saveLabel.layer.masksToBounds = true
        self.saveLabel.layer.cornerRadius = 12
        self.saveLabel.backgroundColor = UIColor(hex: "#4C19DE")

        self.whiteLine.backgroundColor = .white

        switch self.isAnnual {
        case .yearly:
            self.title.text = "Year"
            self.count.text = "Then 49.99 $"
            self.perDuration.text = "4.16 $ / Month"
            self.addSubview(saveLabel)
        case .weekly:
            self.title.text = "Week"
            self.count.text = "Then 0.99 $"
            self.perDuration.text = "0.99 $ / Day"
            break
        }

        self.isSelectedState = false

        addSubview(title)
        addSubview(count)
        addSubview(whiteLine)
        addSubview(perDuration)
        setupConstraints()
    }

    private func setupConstraints() {
        switch self.isAnnual {
        case .yearly:
            saveLabel.snp.makeConstraints { view in
                view.top.equalToSuperview().offset(12)
                view.centerX.equalToSuperview()
                view.width.equalTo(85)
                view.height.equalTo(27)
            }

            title.snp.makeConstraints { view in
                view.top.equalTo(saveLabel.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(12)
                view.trailing.equalToSuperview().inset(12)
                view.height.equalTo(14)
            }

            count.snp.makeConstraints { view in
                view.top.equalTo(title.snp.bottom).offset(4)
                view.trailing.equalToSuperview().inset(12)
                view.leading.equalToSuperview().offset(12)
                view.height.equalTo(14)
            }

            whiteLine.snp.makeConstraints { view in
                view.top.equalTo(count.snp.bottom).offset(8)
                view.trailing.equalToSuperview().inset(44)
                view.leading.equalToSuperview().offset(44)
                view.height.equalTo(1)
            }

            perDuration.snp.makeConstraints { view in
                view.top.equalTo(whiteLine.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(12)
                view.trailing.equalToSuperview().inset(12)
                view.height.equalTo(14)
            }
        case .weekly:
            title.snp.makeConstraints { view in
                view.top.equalToSuperview().offset(28)
                view.leading.equalToSuperview().offset(12)
                view.trailing.equalToSuperview().inset(12)
                view.height.equalTo(14)
            }

            count.snp.makeConstraints { view in
                view.top.equalTo(title.snp.bottom).offset(4)
                view.trailing.equalToSuperview().inset(12)
                view.leading.equalToSuperview().offset(12)
                view.height.equalTo(14)
            }

            whiteLine.snp.makeConstraints { view in
                view.top.equalTo(count.snp.bottom).offset(8)
                view.trailing.equalToSuperview().inset(44)
                view.leading.equalToSuperview().offset(44)
                view.height.equalTo(1)
            }

            perDuration.snp.makeConstraints { view in
                view.top.equalTo(whiteLine.snp.bottom).offset(8)
                view.leading.equalToSuperview().offset(12)
                view.trailing.equalToSuperview().inset(12)
                view.height.equalTo(14)
            }
        default:
            break
        }
    }

    public func setup(with isYearly: String) {
        self.title.text = isYearly
    }

    private func setupBorder() {
        borderLayer.lineWidth = 1
        borderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(borderLayer)
        updateBorder()
    }

    private func updateBorder() {
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
        borderLayer.strokeColor = (isSelectedState ? UIColor(hex: "#4C19DE")?.cgColor : UIColor(hex: "#353746")?.cgColor)
        self.backgroundColor = isSelectedState ? UIColor(hex: "#080808") : UIColor.gray.withAlphaComponent(0.07)
    }

    func toggleSelection() {
        isSelectedState.toggle()
    }
}

enum PlanPresentationModel {
    case yearly
    case weekly
}
